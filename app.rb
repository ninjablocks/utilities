#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'system/getifaddrs'

@@scanned = false
@results = ""

get '/' do
  `ifconfig wlan0 down`
  `ifconfig wlan0 up`
  ifstatus = `ifconfig wlan0`
  `ifconfig wlan0 down`
  unless ifstatus.include? 'Device not found'
	@access_points = []
	`/opt/utilities/wifi/wiscan.pl`.split("\n").each do |scan_results|
  		result = scan_results.split(",")
  		basestation = {}
  		basestation["name"]       = result[1].gsub('"','').strip
 		basestation["key"]        = result[4].gsub('"','').strip
  		basestation["encryption"] = result[5].gsub('"','').strip
  		@access_points << basestation
	end
	erb :index
  else 	
     redirect "/plug_it_in"
  end
end

get '/plug_it_in' do
	"Plug in the wifi adaptor buster!"
end

get '/interface_status' do
  
  if System.get_ifaddrs.include? :wlan0
	"the interface is up"
  else
	"the interface is down"
  end
end

get '/status' do
  erb :interface_status
  #sleep(4)
  #system('reboot');
end

get '/reboot' do
  "rebooting"
  system('reboot');
end

post '/connect' do
  puts params.inspect    
  basestation = params['basestation']
  password = params['password']
    
  doc = "ctrl_interface=/var/run/wpa_supplicant\n"+
  "ctrl_interface_group=0\n"+
  "eapol_version=1\n"+
  "ap_scan=1\n"+
  "fast_reauth=1\n"+
  "\n"+
  "network={\n"+
  "        ssid=\"#{basestation}\"\n"+
  "        proto=WPA\n"+
  "        key_mgmt=WPA-PSK\n"+
  "        pairwise=TKIP\n"+
  "        group=TKIP\n"+
  "        psk=\"#{password}\"\n"+
  "}\n"

  File.open('/etc/wpa_supplicant.conf', 'w') {|f| f.write(doc) }

  redirect '/status'
end
