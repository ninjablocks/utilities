var 
	iface = undefined
;

module.exports = function(app) {

	app.on('iface::up', function(dat) {

		iface = dat.iface;
	});

	app.on('iface::down', function(dat) {

		iface = undefined;
	});

	app.get('/status', function(req, res, next) {

		if(iface) {

			return res.json({ status : "up" });
		}
		res.json({ status : "down" });
	});
};