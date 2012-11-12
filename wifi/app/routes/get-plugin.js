;(function() {
	
	module.exports = function(app, mids) {

		app.get('/plugin', function(req, res, next) {

			console.log("Rendering plugin screen.");
			res.render("plugin");
		});
	};
	
})();
