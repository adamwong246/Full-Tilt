#!/usr/bin/env ruby

require 'rubygems' 
require 'bundler/setup'

require 'liquid'

template = "Hear ye: {{ foo }} {% include 'derp' with 'flerp' %} "

ROOT          = Pathname(File.dirname(__FILE__)).parent
SRC           = "src/includes"
SOURCE_DIR    = ROOT.join(SRC)

Liquid::Template.file_system = Liquid::LocalFileSystem.new(SOURCE_DIR)
Liquid::Template.error_mode = :strict
 
puts Liquid::Template.parse(template).render!({'foo'=> 'bar'})
puts Liquid::Template.parse(template).render!({'fooz'=> 'bar'})
puts Liquid::Template.parse(template, :error_mode => :strict).render!({'foo'=> 'bar'})
puts Liquid::Template.parse(template, :error_mode => :strict).render!({'fooz'=> 'bar'})