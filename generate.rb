require 'rubygems'
require 'erb'
require 'slim'
require 'yaml'
require 'debugger'
require 'ostruct'


# http://andreapavoni.com/blog/2013/4/create-recursive-openstruct-from-a-ruby-hash
class DeepStruct < OpenStruct
  def initialize(hash=nil)
    @table = {}
    @hash_table = {}

    if hash
      hash.each do |k,v|
        @table[k.to_sym] = (v.is_a?(Hash) ? self.class.new(v) : v)
        @hash_table[k.to_sym] = v

        new_ostruct_member(k)
      end
    end
  end

  def to_h
    @hash_table
  end

end


def self.method_missing(m, *args, &block)  	
  @deep.send(m)
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

def render_file(file, opts={})
	#puts "\trendering #{file} with options: #{opts}"
	content = File.read("#{file}")

  case File.extname(file)
  when ".erb"
	  ERB.new(File.read("#{file}"), nil, '-').result(binding())
  when ".slim"
    Slim::Template.new(file, optional_option_hash).render(@deep)
  else
    raise "fail"
  end
end

##### START HERE

Slim::Engine.set_default_options :pretty => true

@config = YAML.load_file("config.yml")
@deep = DeepStruct.new(@config)

# recursively process each file
Dir.glob("templates/**/*", File::FNM_DOTMATCH) do |file| # note one extra "*"
	if !File.directory?(file) && file != ".DS_Store"
    puts "reading #{file}..."  
    dest = eval("\"" + "home/#{file.sub('templates/', '')}" + "\"") 
    File.open(dest, 'w') { |f| f.puts(render_file(file)) }  
    puts "... written to #{dest}."
  end
end

puts "EXIT CODE 0"
