#!/usr/bin/env ruby

require 'rubygems' 
require 'bundler/setup'

require 'debugger'

require 'yaml'
require 'pathname'
require 'tilt'
require 'colorize'
require 'artii'


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
 
# make all the directories we need
# Dir.glob("#{TEMPLATES_DIR}/**/*/", File::FNM_DOTMATCH) do |file|
#   puts "making directory: #{file}"
#   new_dest = "#{HOME_DIR}/" + file.sub("#{TEMPLATES_DIR}/", "")
#   new_dest_interp = Liquid::Template.parse(new_dest).render! conf
#   Dir.mkdir(new_dest_interp) if !File.exists?(new_dest_interp)
# end

#https://github.com/rails/rails/blob/58ab79ff9b34c22c3477e29763fdd4f4612e938d/actionpack/lib/action_view/helpers/text_helper.rb#L216
def word_wrap(text, options = {})  
  prefix     = options.fetch(:prefix, "")
  suffix     = options.fetch(:suffix, "")
  line_width = options.fetch(:line_width, 80) - prefix.length - suffix.length

  (text.split("\n").map { |line|
    line.length > line_width ? line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1\n").strip : line 
  } * "\n").split("\n").map { |line|
    prefix + line + (" " * [(line_width - line.length ), 0].max) + suffix
  }.join("\n")

end

def render_file (path, confs={})
  Tilt.new("src/includes/#{path}").render confs
end

# compile all the liquid files
Dir.glob("#{TEMPLATES_DIR}/**/**", File::FNM_DOTMATCH) do |file_name|
  if File.file?(file_name)    
    file_name_base   = File.basename(file_name, '.*')
    file_name_input  = file_name
    puts "Processing #{file_name_input}..."

    begin
      template = Tilt.new(file_name_input)
      output_string = template.render conf

      file_name_output = file_name.gsub(TEMPLATES, HOME).gsub(SRC, BUILD).chomp(File.extname(file_name))

      file_name_output_template = Tilt['erb'].new{file_name_output}
      file_name_output_inter = file_name_output_template.render conf


      puts "...#{file_name_output_inter}"
      File.open(file_name_output_inter, 'w') { |f| f.puts(output_string) }
      
    rescue Exception => e
      puts e.message.blue
      puts e.backtrace.join("\n").blue
    end      


    # template = File.new(file_name_input).read  
    # # https://www.altamiracorp.com/blog/employee-posts/better-jekyll-error-reporting
    # output_string = Liquid::Template.parse(template).render! conf
    # file_name_output = file_name.gsub(TEMPLATES, HOME).gsub(SRC, BUILD).chomp(File.extname(file_name))
    # file_name_output_inter = Liquid::Template.parse(file_name_output).render! conf
    
  end
end

puts (Artii::Base.new(font: 'basic').asciify ("Done     :-)")).green