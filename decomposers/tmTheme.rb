require 'rubygems'
require 'erb'
require 'yaml'
require 'debugger'

##### START HERE
@config = YAML.load_file("../config.yml")

file = File.open("monokai_bright.thTheme", "rb")
contents = file.read

puts contents.gsub(/#\w{6}/){|m|"#<%=@config['colors']['"+@config['colors'].to_a.sample[0]+"']%>"}