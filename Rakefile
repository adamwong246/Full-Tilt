require 'rubygems'
require 'erb'
# require 'slim'
require 'yaml'
# require 'debugger'
require 'ostruct'

Bundler.require

ROOT          = Pathname(File.dirname(__FILE__))
BUILD         = "build"
HOME          = "Home"
SRC           = "src"
TEMPLATES     = "templates"

BUILD_DIR     = ROOT.join(BUILD)
HOME_DIR      = BUILD_DIR.join(HOME)
SOURCE_DIR    = ROOT.join(SRC)
TEMPLATES_DIR = SOURCE_DIR.join(TEMPLATES)
PARTIALS_DIR  = SOURCE_DIR.join("partials")

class ErbBinding < RecursiveOpenStruct

    def get_binding
        return binding()
    end

    def method_missing(meth, *args)
      raise "Error: #{meth} is not defined".blue.on_red unless meth.to_s.end_with?('=')
      super
    end

    def each
      self_as_a_hash.to_a.each
    end

    def merge(hash)      
      self.marshal_load(self.to_h.merge(hash))
    end

    def render(file, opts={})
      puts "rendering #{file.blue} with #{self.to_s.green}"
      template = File.new(file).read
      render_string(template, opts)      
    end

    def render_string(template, opts={})
      # merge the new options in to self
      self.merge(opts)
      ERB.new(template, nil, '-').result(instance_eval { binding })
    end

    def darken_color(hex_color, amount)
      hex_color = hex_color.gsub('#','')
      rgb = hex_color.scan(/../).map {|color| color.hex}
      rgb[0] = (rgb[0].to_i * amount).round
      rgb[1] = (rgb[1].to_i * amount).round
      rgb[2] = (rgb[2].to_i * amount).round
      "#%02x%02x%02x" % rgb
    end

    def black_white(ratio)
      darken_color("#FFFFFF", ratio)
    end

    def red_component_as_percent(color)
      component(color, :red) / 255.to_f
    end

    def blue_component_as_percent(color)
      component(color, :blue) / 255.to_f
    end

    def green_component_as_percent(color)
      component(color, :green) / 255.to_f
    end

    def component(color, component)
      map = {
        red: 0,
        green: 1,
        blue: 2
      }
      color.scan(/../).map {|color| color.to_i(16)}[map[component]]
    end

end

task :default do
  conf = YAML.load_file("config.yml")
  

  # make all the directories we need
  Dir.glob("#{TEMPLATES_DIR}/**/*/", File::FNM_DOTMATCH) do |file|
    puts "making directory: #{file}"
    new_dest = "#{HOME_DIR}/" + file.sub("#{TEMPLATES_DIR}/", "")
    Dir.mkdir(new_dest) if !File.exists?(new_dest)
  end

  # compile all ERB the files
  Dir.glob("#{TEMPLATES_DIR}/**/*.erb", File::FNM_DOTMATCH) do |file_name|
    if File.file?(file_name)
      
      file_name_base   = File.basename(file_name, '.*')
      puts "== #{file_name_base} =="

      file_name_input  = file_name
      puts "#{file_name_input}..."

      namespace = ErbBinding.new(conf, :recurse_over_arrays => true)
      output_string = namespace.render(file_name_input)

      file_name_output = file_name.gsub(TEMPLATES, HOME).gsub(SRC, BUILD).chomp(File.extname(file_name))
      debugger
      
      File.open(file_name_output, 'w') { |f| f.puts(output_string) }
      puts "...#{file_name_output}".red
    end
  end



end