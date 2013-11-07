#!/usr/bin/env ruby

require 'rubygems' 
require 'bundler/setup'

require 'debugger'

require 'yaml'
require 'pathname'
require 'tilt'
require 'colorize'
require 'artii'

require 'haml'
require "thor"
require 'full_tilt'
 
FullTilt.start(ARGV)