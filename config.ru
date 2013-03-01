require 'rubygems'
require 'bundler'

Bundler.require

ENV['RACK_ENV'] ||= "development"
$stdout.sync = true

require './image_server'
run ImageServer