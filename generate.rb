require 'rubygems'
require 'erb'
require 'yaml'
require 'debugger'

def red_component_as_percent(color)
	component_as_percent(color, :red)
end

def blue_component_as_percent(color)
	component_as_percent(color, :blue)
end

def green_component_as_percent(color)
	component_as_percent(color, :green)
end

def component_as_percent(color, component)
	color + component.to_s
end

def render_file(file, opts={})
	puts "rendering #{file} with options: #{opts}"
	content = File.read("#{file}")
	template = ERB.new(content, nil, '-').result(binding())
end

##### START HERE
@config = YAML.load_file("config.yml")

# recursively process each file
Dir.glob("templates/**/*", File::FNM_DOTMATCH) do |file| # note one extra "*"
	puts "reading #{file}..."  
  dest = eval("\"" + "home/#{File.basename(file, ".erb")}" + "\"") 
  File.open(dest, 'w') { |f| f.puts(render_file(file)) }  
  puts "written to #{dest}."
end
