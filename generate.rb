require 'rubygems'
require 'erb'
require 'slim'
require 'yaml'
require 'debugger'
require 'ostruct'
require 'fileutils'
require 'erubis'

class Hash
  def method_missing(method, *opts)
    m = method.to_s
    if self.has_key?(m)
      return self[m]
    elsif self.has_key?(m.to_sym)
      return self[m.to_sym]
    end
    super
  end
end

class Namespace
  def initialize(hash)
    hash.each do |key, value|
      singleton_class.send(:define_method, key) { value }
    end 
  end

  def get_binding
    binding
  end
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

def make_directories(src_dir, dest_dir, opts)
  Dir.glob("#{src_dir}/**/*/", File::FNM_DOTMATCH) do |file|
    puts "making directory: #{file}"
    new_dest = "#{dest_dir}/" + file.sub("#{src_dir}/", "")

    Dir.mkdir(new_dest) if !File.exists?(new_dest)
  end
end

def render_file(file, opts={})
  puts "rendering #{file} with #{opts}"
  render_template(File.new(file).read, opts)
end

def render_template(template, opts={})  
  ns = Namespace.new(@@hash.merge(opts))
  ERB.new(template).result(ns.get_binding)
end

def make_files(src_dir, dest_dir, opts)
  Dir.glob("#{src_dir}/**/**", File::FNM_DOTMATCH) do |file|

    if File.file?(file)
    
      result = render_file(file, opts)

      dest_dir = "home"
      src_dir = "templates"

      string_to_eval = dest_dir + file.sub(src_dir, '')

      debugger
      final_file = render_template(string_to_eval, @@hash)  # Proc.new { |var| eval(%Q{"#{string_to_eval}"})  }.call 
      
      new_dest = render_template(final_file, opts ).chomp(File.extname(file))      

      File.open(new_dest, 'w') { |f| f.puts(result) }      
    end
  end
end

def proccess_files(src_dir, dest_dir, opts)
  make_directories(src_dir, dest_dir, opts)
  make_files(src_dir, dest_dir, opts)  
end

##### START HERE
@@hash = YAML.load_file("config.yml")
# @conf = DeepStruct.new(YAML.load_file("config.yml"))

proccess_files("templates", "home", @@hash) 

puts "EXIT CODE 0"
