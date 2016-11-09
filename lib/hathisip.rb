#!/usr/bin/env ruby

require './sipmaker.rb'
require 'optparse'

# Create command-line options

options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: hathisip -i bmtnid"

  opts.on( '-i', '--id id', 'bmtnid' ) do |id|
    options[:bmtnid] = id
  end
end

optparse.parse!
puts "bmtnid: #{options[:bmtnid] }"
sipmaker = SIPMaker.new(options[:bmtnid])
sipmaker.make_sip


