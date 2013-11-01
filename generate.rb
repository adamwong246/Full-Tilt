require 'rubygems'
require 'erb'
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
  puts "method_missing(#{m}, #{args}, #{block})"    
  @deep.send(m)

  # if @config.has_key?(m.to_s)
  # 	to_return = @config[m.to_s]
  # else
  # 	to_return = false
  # end
  # puts "--- returning with #{to_return}"
  # to_return
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
	puts "\trendering #{file} with options: #{opts}"
	content = File.read("#{file}")
	template = ERB.new(content, nil, '-').result(binding())
end

##### START HERE
@config = YAML.load_file("config.yml")
@deep = DeepStruct.new(@config)

# recursively process each file
Dir.glob("templates/**/*", File::FNM_DOTMATCH) do |file| # note one extra "*"
	puts "reading #{file}..."  
  dest = eval("\"" + "home/#{File.basename(file, ".erb")}" + "\"") 
  File.open(dest, 'w') { |f| f.puts(render_file(file)) }  
  puts "written to #{dest}."
end

puts ""
puts "EXIT 0"
