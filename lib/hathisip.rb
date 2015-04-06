#!/usr/bin/env ruby

require './sipmaker.rb'
require 'optparse'

# Create command-line options

options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: hathisip -i bmtnid"

  opts.on( '-i', '--id id', 'process ID' ) do |id|
    options[:bmtnid] = id
  end
end

optparse.parse!
sipmaker = SIPMaker.new(options[:bmtnid])
sipmaker.make_sip
