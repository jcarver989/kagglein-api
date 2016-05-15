RACK_ENV = "test"
require "./server"
require 'minitest/autorun'
require 'timecop'

set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false
