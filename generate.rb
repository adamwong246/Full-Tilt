require 'rubygems'
require 'erb'
 
# setup - could be initialized from script arguments
classname = "Contact"
listener_methods = ["added", "removed", "blackListed"]
 
# create file based on 'listener.java.erb'
content = File.read('listener.java.erb')
template = ERB.new(content)
File.open("#{classname}Listener.java", 'w') { |f| f.puts(template.result) }