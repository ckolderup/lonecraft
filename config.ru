require 'rubygems'
require 'bundler/setup'

Bundler.require

require './minebound.rb'
run Sinatra::Application
