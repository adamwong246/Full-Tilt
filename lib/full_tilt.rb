#!/usr/bin/env ruby

class FullTilt  < Thor

  desc "hello NAME", "say hello to NAME"
  def hello(name)
    puts "Hello #{name}"
  end

  desc "crunch INPUT_FILE_OR_FOLDER", "Processes a file or folder."
  long_desc <<-LONGDESC
    crunch is the main function of FullTilt. It processes files and/or folders according to their file extensions. For example, 'style.css.scss.erb' would be templated with ERB, then pre-processed with SCSS before finally outputting 'style.css.' When processing folders, the directory structure is maintained. You can interpolate strings into the filename BUT you must use the interpolation style as indicated by file type. That is, "{value}.html.haml" and "<%=value%>.html.erb" are legal but "\#{value}.html.erb" and "<%=value%>.html.haml" are not.
  LONGDESC
  option "dest",type: :string,  aliases: :d  
  def crunch(conf)

    conf = YAML.load_file(conf)
    templates_dir = conf[:templates_dir]
    includes_dir  = conf[:includes_dir]

    dest = options[:dest] || Dir.pwd
    puts "dest: #{dest}"

    debugger 
    
    Dir.glob("#{templates_dir}/**/**", File::FNM_DOTMATCH) do |file_name|
      if File.file?(file_name)    
        file_name_base   = File.basename(file_name, '.*')
        file_name_input  = file_name
        puts "Processing #{file_name_input}..."

        begin
          template = Tilt.new(file_name_input)
          output_string = template.render conf

          file_name_output = file_name.gsub(TEMPLATES, HOME).gsub(SRC, BUILD).chomp(File.extname(file_name))

          file_name_output_template = Tilt.new(File.extname(file_name)){file_name_output}
          file_name_output_inter = file_name_output_template.render(conf).strip


          puts "...#{file_name_output_inter}"
          File.open(file_name_output_inter, 'w') { |f| f.puts(output_string) }
          
        rescue Exception => e
          puts e.message.blue
          puts e.backtrace.join("\n").blue
        end              
      end
    end
  end

  desc "predom INPUT_FILE", "Extract the predominate colors from an image"
  long_desc <<-LONGDESC
    predom uses imagemagick to extract the predominate colors from an image file. 
    Default is 8 colors. 
  LONGDESC
  option "dest",type: :string,  aliases: :d
  option "num", type: :numeric, aliases: :n
  def predom(src)
    color_hash = ColorExtractor.new.predominate_colors(src, options[:num] || 8)
    color_hash.each do |k, v|
      puts v
    end
    if options[:dest]
      File.open(options[:dest], "w") do |file|
        file.write color_hash.to_yaml
      end      
    end    
  end
end

class Filer
  def easy_copy(destination, *files, &block)
  end
end

class Hash
  def method_missing m
    self[m.to_s]
  end
end

class ColorExtractor
  def initialize    
  end

  def get_points(img, num_colors)
    img.quantize(num_colors).color_histogram.sort{|a, b| b[1] <=> a[1] }
  end

  def predominate_colors(filename, num_colors)
    img = Magick::Image::read(filename)[0]
    points = get_points(img, num_colors)

    hash = {}

    points.each_with_index{|p, idx|
        hash["color_#{idx}"] = p[0].to_color(Magick::AllCompliance, false, 8, true).gsub('#', '')
    }

    hash
  end
  
end