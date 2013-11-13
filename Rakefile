# task :default => [:test]
# require 'rubygems'
# require 'pp'
# require 'tilt'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[lib]))

puts $LOAD_PATH

task :test do
  do_it
end

desc "Build a mapping between the input and the output"
task :build_mapping do
  
  SRC           = "src"
  ROOT          = Pathname(File.dirname(__FILE__))
  SOURCE_DIR    = ROOT.join(SRC)
  TEMPLATES     = "templates"
  TEMPLATES_DIR = SOURCE_DIR.join(TEMPLATES)

  puts "Templates #{TEMPLATES_DIR}"

  to_return = {}

  Dir.glob("#{TEMPLATES_DIR}/**/**", File::FNM_DOTMATCH) do |file_name|
    input_file_name = file_name
    file_or_folder = File.file?(file_name) ? :file : :folder
    ext = File.extname(file_name)

    to_return[file_name] = {
      file_or_folder: file_or_folder,
      tilt_extensions: ext.split(".").map{|e| Tilt[e]}.compact
    }
    # begin
    #   if File.file?(file_name)
    #     file_name_base   = File.basename(file_name, '.*')
    #     dest = BUILD_DIR.join(Pathname.new(file_name).relative_path_from(TEMPLATES_DIR))
    #     ext = File.extname(file_name)
    #     puts "Processing #{file_name}, #{ext}..."

    #     templates = ext.split(".").map{|e| Tilt[e]}.compact

    #     if templates.length == 0
    #       puts "not recognized by tilt, just copying to: #{dest}"

    #       FileUtils.mkpath dest.dirname
    #       FileUtils.cp(file_name, dest)
    #     else

    #       output_string = File.open(file_name, "r").read

    #       templates.each{|template|
    #         puts template
    #         # template = Tilt.new(file_name)
    #         output_string = template.new{output_string}.render conf
    #       }

    #       # puts "contents OK"

    #       file_name_output_template = Tilt[ext].new{file_name}
    #       file_name_output_inter = file_name_output_template.render(conf).strip

    #       endr = BUILD_DIR.join(Pathname.new(file_name_output_inter.chomp(File.extname(file_name))).relative_path_from(TEMPLATES_DIR))

    #       puts "...#{endr}"

    #       FileUtils.mkpath dest.dirname
    #       File.open(endr, 'w') { |f| f.puts(output_string) }

    #     end
    #   end

    # rescue Exception => e
    #   puts e.message
    #   puts e.backtrace
    # end
  end

  PP.pp to_return
end