;(function() {
	
	module.exports = function(app, mids) {

		app.get('/', mids.ready, function(req, res, next) {

			console.log("Rendering index screen.");
			res.render("index");

		});
	};

})();
