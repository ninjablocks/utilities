;(function() {

	var cells = [];
	
	module.exports = function(app) {

		app.on('wifiScan', function(dat) {
			
			if((typeof dat !== "object") || dat.length < 1) { return; }

			cells = dat;
		});

		app.get('/networks', function(req, res, next) {

			console.log("Client requested network list...");
			console.log(cells);
			res.json({ 'networks' : cells });
		});
	};

})();
