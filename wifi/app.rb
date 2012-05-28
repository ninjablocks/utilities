#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'

@scanned = false
@results = ""


get '/' do
  if scanned == false
    @results = `iw wlan0 scan | grep -i 'ssid'`
    @scanned = true  
  else
    @results = `iw wlan0 scan dump | grep -i 'ssid'`
  end
  
  @aps = @results.split("\n");
  @aps.map! {|x| x.gsub('SSID: ','').strip }
  puts @aps.inspect
  
  erb :index
end