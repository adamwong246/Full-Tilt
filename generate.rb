require 'rubygems'
require 'erb'
require 'yaml'
 
# renders erb to string
def render_file(file)
	content = File.read("#{file}")
	template = ERB.new(content).result	
end

# get the configs
config = YAML.load_file("config.yml")

# recursively process each file
Dir.glob("templates/**/*", File::FNM_DOTMATCH) do |file| # note one extra "*"
	puts "reading #{file}..."  
  dest = "home/#{File.basename(file, ".erb")}"
  File.open(dest, 'w') { |f| f.puts(render_file(file)) }  
  puts "written to #{dest}."

end
