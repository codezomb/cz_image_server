require 'rubygems'
require 'bundler'

Bundler.require

ENV['RACK_ENV'] ||= "development"
$stdout.sync = true

require './app'
ImageServer.run!