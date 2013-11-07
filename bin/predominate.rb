#!/usr/bin/env ruby

require 'rubygems' 
require 'bundler/setup'

require 'debugger'

require 'rmagick'
require 'yaml'

ROOT          = Pathname(File.dirname(__FILE__)).parent

def get_points(img)
    img.quantize(8).color_histogram.sort{|a, b| b[1] <=> a[1] }
end

def colorz(filename, n=8)
    img = Magick::Image::read(filename)[0]
    points = get_points(img)

    hash = {}

    points.map{|p, idx|
        hash["color_#{idx}"] = p.to_color(Magick::AllCompliance, false, 8, true).gsub('#', '')
    }

    hash
end

File.open("frog_predom_colors.yml", "w") do |file|
  file.write colorz("frog.jpg").to_yaml
end
    