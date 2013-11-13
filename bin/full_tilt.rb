#!/usr/bin/env ruby

require 'rubygems' 
require 'bundler/setup'

require 'debugger'

require 'yaml'
require 'pathname'
require 'tilt'
require 'colorize'
require 'artii'

require 'haml'

ROOT          = Pathname(File.dirname(__FILE__)).parent
BUILD         = "build"

SRC           = "src"
INCLUDES      = "includes"
TEMPLATES     = "templates"
CONF          = "config.yml"

BUILD_DIR     = ROOT.join(BUILD)

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

class Hash
  def method_missing m
    self[m.to_s]
  end
end

def files_as_hash
  "asd"
end

def set (key, value)
  self[key] = value
end

#https://github.com/rails/rails/blob/58ab79ff9b34c22c3477e29763fdd4f4612e938d/actionpack/lib/action_view/helpers/text_helper.rb#L216
def word_wrap(text, options = {})
  self.merge!(options)
  prefix     = self.fetch(:prefix, "")
  suffix     = self.fetch(:suffix, "")
  line_width = self.fetch(:line_width, 80) - prefix.length - suffix.length

  (text.split("\n").map { |line|
    line.length > line_width ? line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1\n").strip : line 
  } * "\n").split("\n").map { |line|
    prefix + line + (" " * [(line_width - line.length ), 0].max) + suffix
  }.join("\n")

end

def render_file (path, confs= {})
  # puts "RENDERING FILE: #{path} with #{confs}"
  Tilt.new(path).render self.merge(confs)
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

FileUtils.rm_rf('build/')
Dir.mkdir('build')

# compile all the liquid files
Dir.glob("#{TEMPLATES_DIR}/**/**", File::FNM_DOTMATCH) do |file_name|
  begin
    if File.file?(file_name)
      file_name_base   = File.basename(file_name, '.*')
      dest = BUILD_DIR.join(Pathname.new(file_name).relative_path_from(TEMPLATES_DIR))
      ext = File.extname(file_name)
      puts "Processing #{file_name}, #{ext}..."

      templates = ext.split(".").map{|e| Tilt[e]}.compact

      if templates.length == 0
        puts "not recognized by tilt, just copying to: #{dest}"

        FileUtils.mkpath dest.dirname
        FileUtils.cp(file_name, dest)
      else

        output_string = File.open(file_name, "r").read

        templates.each{|template|
          puts template
          # template = Tilt.new(file_name)
          output_string = template.new{output_string}.render conf
        }

        # puts "contents OK"

        file_name_output_template = Tilt[ext].new{file_name}
        file_name_output_inter = file_name_output_template.render(conf).strip

        endr = BUILD_DIR.join(Pathname.new(file_name_output_inter.chomp(File.extname(file_name))).relative_path_from(TEMPLATES_DIR))

        puts "...#{endr}"

        FileUtils.mkpath dest.dirname
        File.open(endr, 'w') { |f| f.puts(output_string) }

      end
    end

    rescue Exception => e
      puts e.message
      puts e.backtrace
    end


    # template = File.new(file_name_input).read  
    # # https://www.altamiracorp.com/blog/employee-posts/better-jekyll-error-reporting
    # output_string = Liquid::Template.parse(template).render! conf
    # file_name_output = file_name.gsub(TEMPLATES, HOME).gsub(SRC, BUILD).chomp(File.extname(file_name))
    # file_name_output_inter = Liquid::Template.parse(file_name_output).render! conf
    

end