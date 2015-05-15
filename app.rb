#!/usr/bin/ruby
$LOAD_PATH.unshift File.expand_path('./lib')
require 'dotenv'
require 'cta'
require 'json'
# Expects a .env file to contain required parameters
Dotenv.load

busapi = CTA::BusAPI.new(ENV['CTA_API_KEY'])
#busapi.get_time
#busapi.get_vehicles(:rt => 50)
#busapi.get_routes
#busapi.directions(12)
