RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined?(RACK_ENV)
ZB_ROOT = File.expand_path('../..', __FILE__)

require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

require "#{ZB_ROOT}/app/app.rb"

