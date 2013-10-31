require 'rubygems'
require 'erb'
require 'yaml'
 
# renders erb to string
def render(file)
	content = File.read("#{file}")
	template = ERB.new(content).result	
end

# get the configs
config = YAML.load_file("config.yml")

# recursively process each file
Dir.glob("templates/**/*", File::FNM_DOTMATCH) do |file| # note one extra "*"
  puts "working on: #{file}..."
  File.open("home/#{File.basename(file, ".erb")}", 'w') { |f| f.puts(render(file)) }  
end
