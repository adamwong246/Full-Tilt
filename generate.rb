require 'rubygems'
require 'erb'
require 'yaml'
 
# author = "adam wong!!!"
config = YAML.load_file("config.yml")

Dir.glob("templates/**/*", File::FNM_DOTMATCH) do |my_text_file| # note one extra "*"
  puts "working on: #{my_text_file}..."
  content = File.read("#{my_text_file}")
	template = ERB.new(content)
	File.open("home/#{File.basename(my_text_file, ".erb")}", 'w') { |f| f.puts(template.result) }
end

# # setup - could be initialized from script arguments
# classname = "Contact"
# listener_methods = ["added", "removed", "blackListed"]
 
# # create file based on 'listener.java.erb'
# content = File.read('listener.java.erb')
# template = ERB.new(content)
# File.open("#{classname}Listener.java", 'w') { |f| f.puts(template.result) }