;(function() {

	var 
		device = false
		, iface = false
		, calls = 0
	;
	
	module.exports = function(app) {

		app.on('deviceCheck', function(dat) {

			--calls;
			if(!dat) { return device = false; }
			device = true;
		});

		app.on('ifaceCheck', function(dat){

			--calls;
			if(!dat) { return iface = false; }
			iface = true;
		});

		app.get('/device', function(req, res, next) {

			if(calls += 2 <= 2) {

				app.send('deviceCheck', true);
				app.send('ifaceCheck', true);
			}
			res.json({ 'device' : device, 'iface' : iface });
		});
	};

})();
