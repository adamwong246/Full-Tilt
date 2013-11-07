#!/usr/bin/env ruby

class FullTilt  < Thor

  desc "hello NAME", "say hello to NAME"
  def hello(name)
    puts "Hello #{name}"
  end

  desc "predom INPUT_FILE", "Extract the predominate colors from an image"
  long_desc <<-LONGDESC
    Uses imagemagick to extract the predominate colors from an image file. 
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
  def initialize
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