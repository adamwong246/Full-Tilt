require 'rubygems'
require 'erb'
require 'yaml'
require 'debugger'

# get the configs
@config = YAML.load_file("config.yml")

# renders erb to string
def render_file(file, opts={})

	puts "rendering #{file} with options: #{opts}"
	
	opts[:prefix] ||= ""
	opts[:suffix] ||= ""

	content = File.read("#{file}")
	template = ERB.new(content, nil, '-').result(binding())
end

# recursively process each file
Dir.glob("templates/**/*", File::FNM_DOTMATCH) do |file| # note one extra "*"
	puts "reading #{file}..."  
  dest = eval("\"" + "home/#{File.basename(file, ".erb")}" + "\"") 
  File.open(dest, 'w') { |f| f.puts(render_file(file)) }  
  puts "written to #{dest}."
end
