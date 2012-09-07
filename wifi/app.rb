#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'system/getifaddrs'

get '/' do
	lsusb=`lsusb`
	unless ( lsusb =~ /wifi|wireless|wlan/i ) 
		puts "redirected line 10" 
   		redirect "/plug_it_in"
  	end
  
  `ifconfig wlan0 down`
  `ifconfig wlan0 up`
  ifstatus = `ifconfig wlan0`
	puts `sudo /opt/utilities/wifi/wiscan.pl`
  unless ifstatus.include? 'Device not found' or `sudo /opt/utilities/wifi/wiscan.pl`.include? 'No scan results' 
	@access_points = []
	`sudo /opt/utilities/wifi/wiscan.pl`.split("\n").each do |scan_results|
  		result = scan_results.split(",")
		puts result;
  		basestation = {}
  		basestation["name"]       = result[1].gsub('"','').strip
 		basestation["key"]        = result[4].gsub('"','').strip
  		basestation["encryption"] = result[5].gsub('"','').strip
  		@access_points << basestation
	end
	erb :index
  else 	
	puts "redirect to plug it in 30"
     redirect "/plug_it_in"
  end
end

get '/plug_it_in' do
	erb :plug_it_in
end

get '/interface_status' do
  
  if System.get_ifaddrs.include? :wlan0
	"up"
  else
	"down"
  end
end

get '/status' do
  erb :interface_status
end

get '/connected' do
  erb :connected
end

post '/connect' do
  basestation = params['basestation'].split(',')
  password = params['password']
  
    if basestation[1] == "on"
       puts "key on"
      if basestation[2].include? "WPA"
        doc = "ctrl_interface=/var/run/wpa_supplicant\n"+
        "network={\n"+
        "        ssid=\"#{basestation[0]}\"\n"+
        "        psk=\"#{password}\"\n"+
        "}\n"
        puts doc
      else
        puts "WEP on"
        doc = "ctrl_interface=/var/run/wpa_supplicant\n"+
        "network={\n"+
        "        ssid=\"#{basestation[0]}\"\n"+
        "        key_mgmt=NONE\n"+
        "        wep_key0=\"#{password}\"\n"+
        "        wep_tx_keyidx=0\n"+
        "}\n"
        puts doc
      end
    else
      puts "key off"
      doc = "ctrl_interface=/var/run/wpa_supplicant\n"+
      "network={\n"+
      "        ssid=\"#{basestation[0]}\"\n"+
      "        key_mgmt=NONE\n"+
      "}\n"
      puts doc
    end
    

  puts "writing file"
  File.open('/etc/wpa_supplicant.conf', 'w') {|f| f.write(doc) }
  puts "done writing file"
  system('sudo ifdown wlan0')
  system('killall -q wpa_supplicant')
  system('sudo ifup wlan0')
  
  redirect '/status'
end
