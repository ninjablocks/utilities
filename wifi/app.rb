#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'

@@scanned = false
@results = ""

get '/' do


  if @@scanned == false
    @results = `iw wlan0 scan | grep -i 'ssid'`
    @@scanned = true
    puts "\n\n----> Using fresh results\n\n"
  else
    @results = `iw wlan0 scan dump | grep -i 'ssid'`
    puts "\n\n----> Using cached results\n\n"
  end
  
  @aps = @results.split("\n");
  @aps.map! {|x| x.gsub('SSID: ','').strip }
  puts @aps.inspect
  
  erb :index
end

post '/connect' do
  puts params.inspect    
  basestation = params['basestation']
  password = params['password']
    
  "/connect"
  doc = "auto lo\n"+
  "iface lo inet loopback\n"+
  "\n"+
  "# The primary network interface\n"+
  "auto eth0\n"+
  "iface eth0 inet dhcp\n"+
  "# Example to keep MAC address between reboots\n"+
  "#hwaddress ether DE:AD:BE:EF:CA:FE\n"+
  "\n"+
  "# WiFi Example\n"+
  "auto wlan0\n"+
  "iface wlan0 inet dhcp\n"+
  "    wpa-ssid \"#{basestation}\"\n"+
  "    wpa-psk  \"#{password}\"\n"

  File.open('/etc/network/interfaces', 'w') {|f| f.write(doc) }

  #redirect '/'
end
