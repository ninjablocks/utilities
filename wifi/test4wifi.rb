#!/usr/bin/env ruby

require 'rubygems'

lsusb_output = `lsusb`

if lsusb_output.include? "WLAN"
  puts "WLAN connected"
else
  puts "WLAN not connected"
end

