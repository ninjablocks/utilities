;(function() {
	
	var 
		routes = {

			connected : require('./get-connected')
			, networks : require('./xhr-networks')
			, connect : require('./post-connect')
			, device : require('./xhr-device')
			, status : require('./get-status')
			, plugin : require('./get-plugin')
			, index : require('./get-index')
		}
		, router = function(app, mids) {

			Object.keys(routes).forEach(function(route) {
		
				module.exports[route] = routes[route](app, mids);
			});

			return app;	
		}
	;

	module.exports = router;

})();
