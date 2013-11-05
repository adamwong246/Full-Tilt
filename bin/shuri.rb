#!/usr/bin/env ruby

require 'rubygems' 
require 'bundler/setup'

require 'yaml'
require 'pathname'
require 'liquid'

ROOT          = Pathname(File.dirname(__FILE__)).parent
BUILD         = "build"
HOME          = "Home"
SRC           = "src"
INCLUDES      = "includes"
TEMPLATES     = "templates"
CONF          = "config.yml"

BUILD_DIR     = ROOT.join(BUILD)
HOME_DIR      = BUILD_DIR.join(HOME)
SOURCE_DIR    = ROOT.join(SRC)
INCLUDE_DIR   = SOURCE_DIR.join(INCLUDES) 
TEMPLATES_DIR = SOURCE_DIR.join(TEMPLATES)
PARTIALS_DIR  = SOURCE_DIR.join("partials")

conf = YAML.load_file(CONF)

# puts "Shuri starting up..."
# puts "Current dir:  - #{Dir.pwd}"
# puts "ROOT          - #{ROOT}"
# puts "BUILD_DIR     - #{BUILD_DIR}"
# puts "HOME_DIR      - #{HOME_DIR}"
# puts "TEMPLATES_DIR - #{TEMPLATES_DIR}"

Liquid::Template.file_system = Liquid::LocalFileSystem.new(INCLUDE_DIR)
# Liquid::Template.error_mode = :strict 
 
# make all the directories we need
Dir.glob("#{TEMPLATES_DIR}/**/*/", File::FNM_DOTMATCH) do |file|
  puts "making directory: #{file}"
  new_dest = "#{HOME_DIR}/" + file.sub("#{TEMPLATES_DIR}/", "")
  new_dest_interp = Liquid::Template.parse(new_dest).render! conf
  Dir.mkdir(new_dest_interp) if !File.exists?(new_dest_interp)
end

# compile all the liquid files
Dir.glob("#{TEMPLATES_DIR}/**/*.liquid", File::FNM_DOTMATCH) do |file_name|
  if File.file?(file_name)    
    file_name_base   = File.basename(file_name, '.*')
    file_name_input  = file_name
    puts "#{file_name_input}..."
    template = File.new(file_name_input).read  
    # https://www.altamiracorp.com/blog/employee-posts/better-jekyll-error-reporting
    output_string = Liquid::Template.parse(template).render! conf
    file_name_output = file_name.gsub(TEMPLATES, HOME).gsub(SRC, BUILD).chomp(File.extname(file_name))
    file_name_output_inter = Liquid::Template.parse(file_name_output).render! conf
    File.open(file_name_output_inter, 'w') { |f| f.puts(output_string) }
    puts "...#{file_name_output_inter}"
  end
end

# class ErbBinding < RecursiveOpenStruct
#     def get_binding
#         return binding()
#     end

#     def method_missing(meth, *args)
#       raise "Error: #{meth} is not defined".blue.on_red unless meth.to_s.end_with?('=')
#       super
#     end

#     def each
#       self_as_a_hash.to_a.each
#     end

#     def merge(hash)      
#       self.marshal_load(self.to_h.merge(hash))
#     end

#     def render(file, opts={})
#       puts "rendering #{file.blue} with #{self.to_s.green}"
#       template = File.new(file).read
#       render_string(template, opts)      
#     end

#     def render_string(template, opts={})
#       # merge the new options in to self
#       self.merge(opts)
#       ERB.new(template, nil, '-').result(instance_eval { binding })
#     end

#     def darken_color(hex_color, amount)
#       hex_color = hex_color.gsub('#','')
#       rgb = hex_color.scan(/../).map {|color| color.hex}
#       rgb[0] = (rgb[0].to_i * amount).round
#       rgb[1] = (rgb[1].to_i * amount).round
#       rgb[2] = (rgb[2].to_i * amount).round
#       "#%02x%02x%02x" % rgb
#     end

#     def black_white(ratio)
#       darken_color("#FFFFFF", ratio)
#     end

#     def red_component_as_percent(color)
#       component(color, :red) / 255.to_f
#     end

#     def blue_component_as_percent(color)
#       component(color, :blue) / 255.to_f
#     end

#     def green_component_as_percent(color)
#       component(color, :green) / 255.to_f
#     end

#     def component(color, component)
#       map = {
#         red: 0,
#         green: 1,
#         blue: 2
#       }
#       color.scan(/../).map {|color| color.to_i(16)}[map[component]]
#     end

# end