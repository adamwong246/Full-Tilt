require 'rubygems'
require 'erb'
# require 'slim'
require 'yaml'
# require 'debugger'

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

class ErbBinding < OpenStruct
    def get_binding
        return binding()
    end

    def method_missing(meth, *args)
      raise "Error: #{meth} is not defined".blue.on_red unless meth.to_s.end_with?('=')
      super
    end

    def merge(hash)      
      self.marshal_load(self.to_h.merge(hash))
    end

    def render(file, opts={})

      # merge the new options in to self
      self.merge(opts)

      template = File.new(file).read
      ERB.new(template, nil, '-').result(instance_eval { binding })
    end
end

task :default do
  conf = YAML.load_file("config.yml")
  namespace = ErbBinding.new(conf)

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
      template = File.new(file_name_input).read
      
      output_string = ERB.new(template, nil, '-').result(namespace.instance_eval { binding })

      file_name_output = file_name.gsub(TEMPLATES, HOME).gsub(SRC, BUILD).chomp(File.extname(file_name))
      File.open(file_name_output, 'w') { |f| f.puts(output_string) }
      puts "...#{file_name_output}"
    end
  end



end