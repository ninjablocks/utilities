;(function() {

	var 
		cells = {}
		, util = require('util')
	;
	
	module.exports = function(app, mids) {

		app.on('wifiScan', function(dat) {
			
			if((typeof dat !== "object") || dat.length < 1) { return; }

			dat.forEach(function(cell) {

				cells[cell.address] = cell;
			});
		});

		app.post('/connect', function(req, res, next) {
			
			if(!req.body) { return error(res, "Invalid request"); }

			var 
				params = { 

					ssid : req.body.ssid || undefined
					, network : req.body.network || undefined
					, password : req.body.password || undefined
					, security : req.body.security || null
				}
			;

			if(params.ssid && params.ssid.length > 0) { // non-broadcast

				console.log("Client submitting non-broadcast network...");
				if(!params.security) {

					return error(res, "Invalid parameters");
				}
				if(!params.password && params.security !== "NONE") {

					return error(res, "Invalid password");
				}

				if(params.password) {

					params.auth = (params.security == "WEP") ? "WEP" : "PSK";
					params.encType = params.security;
					params.encryption = true;
				}
				else {

					params.auth = null;
					params.encryption = false;
				}
				params.hidden = true;
			}
			else if(params.network) { // pre-scanned

				var record = cells[params.network] || undefined;

				console.log("Client submitting pre-scanned network...");
				if(!record) { return error(res, "Network not found"); }

				if(params.password && record.encryption) {

					params.auth = record.auth;
					params.encryption = true;
				}
				else {

					params.encryption = false;
					delete params.password;
				}
				params.ssid = record.ssid;
				params.encType = record.encType;
			}

			delete params.network; 
			
			console.log(

				util.format(

					"Requesting wpa_supplicant config for %s (%s)."
					, params.ssid || "Unknown Network"
					, params.encType || "OPEN"
				)
			);
			app.send("writeConfig", params);
			res.json({ 'connected' : true });
		});
	};

	function error(res, err) {

		res.json({ "error" : err || "Unknown error" });
	};

})();
