#!/usr/bin/env ruby

module FullTilt < Thor

  desc "crunch INPUT_FILE_OR_FOLDER", "Processes a file or folder."
  long_desc <<-LONGDESC
    crunch is the main function of FullTilt. It processes files and/or folders according to their file extensions. For example, 'style.css.scss.erb' would be templated with ERB, then pre-processed with SCSS before finally outputting 'style.css.' When processing folders, the directory structure is maintained. You can interpolate strings into the filename BUT you must use the interpolation style as indicated by file type. That is, "{value}.html.haml" and "<%=value%>.html.erb" are legal but "\#{value}.html.erb" and "<%=value%>.html.haml" are not.
  LONGDESC
  option "dest",type: :string,  aliases: :d  
  def crunch(configuration_filename)
    
    # FullTiltcrunch(configuration_filename)    
    # conf = YAML.parse_file(configuration_filename)
    # puts "configuration_filename: #{configuration_filename}"    
    # dest = Dir.mkdir(File.basename("#{configuration_filename}_out"))
    # puts "dest: #{dest}"
    # Dir.glob("templates/**/*", File::FNM_DOTMATCH) do |file_name|
    #   if File.file?(file_name)
    #     p "file: #{file_name}"
    #       # process_file(filename)
    #   else    
    #     p "dir #{file_name}"
    #       # process_dir(file_name)
    #   end
    #     file_name_base   = File.basename(file_name, '.*')
    #     file_name_input  = file_name
    #     puts "Processing #{file_name_input}..."
    #     begin
    #       template = Tilt.new(file_name_input)
    #       output_string = template.render conf
    #       file_name_output = file_name.gsub(TEMPLATES, HOME).gsub(SRC, BUILD).chomp(File.extname(file_name))
    #       file_name_output_template = Tilt.new(File.extname(file_name)){file_name_output}
    #       file_name_output_inter = file_name_output_template.render(conf).strip
    #       puts "...#{file_name_output_inter}"
    #       File.open(file_name_output_inter, 'w') { |f| f.puts(output_string) }          
    #     rescue Exception => e
    #       puts e.message.blue
    #       puts e.backtrace.join("\n").blue
    #     end              
    #  end
    # end  
  end
end

class Hash
  def method_missing m
    self[m.to_s]
  end
end