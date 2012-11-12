var 
	exec = require('child_process').exec
	, opts = { timeout : 10000 }
	, fs = require('fs')
	, path = require('path')
	, util = require('util')
	, confPath = '/etc/wpa_supplicant.conf'
	, writeConfig = function(conf) {

		var fd = fs.createWriteStream(confPath);

		console.log("Writing WiFi configuration...");
		fd.on('error', function(err) {

			console.log("Error writing WiFi configuration.", err);
			process.send({ 'action' : 'writeConfig', error : err });
			fd.end();
			return; 
		});

		var write = [

			"ctrl_interface=/var/run/wpa_supplicant"
		];

		write.push("network={");
		write.push(util.format("\tssid=\"%s\"", conf.ssid));

		if(conf.encryption) {

			if(conf.auth == "PSK") {

				write.push("\tkey_mgmt=WPA-PSK");
				write.push("\tproto=" + (conf.encType == "WPA2" ? 

					"WPA2" : "WPA"
				));
				write.push("\tpairwise=TKIP");
				write.push("\tgroup=TKIP");
				write.push(util.format("\tpsk=\"%s\"", conf.password));
			}
		}
		else {

			write.push("key_mgmt=NONE");
		}

		write.push("}\n");
		fd.end(write.join("\n"));
		console.log("Wrote WiFi configuration.");
		console.log(write);
		process.send({ 'action' : 'writeConfig', data : true });
	}
;

module.exports = writeConfig;
