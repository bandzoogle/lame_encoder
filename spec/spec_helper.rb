# -*- coding: utf-8 -*-
#require 'simplecov'
#SimpleCov.start

require 'bundler/setup'
Bundler.require

require 'tempfile'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

