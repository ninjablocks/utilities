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
			
			var
				conf = {

					'address' : req.body.network
					, 'password' : req.body.password
				}
			;

			console.log("Client requested connection for cell address %s.", conf.address);

			if(!cells[conf.address]) {

				return res.json({ error : "Unknown Network"});
			}

			cells[conf.address].password = conf.password;

			// request config write-out
			app.send("writeConfig", cells[conf.address]);
			process.stdout.write(

				util.format(

					"Writing wpa_supplicant.conf for %s (%s)."
					, cells[conf.address].ssid || "Unknown Network"
					, cells[conf.address].encType
				)
			);
			
			res.json({ 'connected' : true });
		});
	};

})();
