#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'

#results = `iw wlan0 scan | grep -i 'ssid'`
results = `cat scan.txt | grep -i ssid`

@aps = results.split("\n");
@aps.map! {|x| x.gsub('SSID: ','').strip }
puts @aps.inspect

#exit 0

get '/' do
  results = `cat scan.txt | grep -i ssid`

  @aps = results.split("\n");
  @aps.map! {|x| x.gsub('SSID: ','').strip }
  puts @aps.inspect
  erb  :index

end
