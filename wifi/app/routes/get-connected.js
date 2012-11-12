;(function() {
	
	module.exports = function(app) {

		app.get('/connected', function(req, res, next) {

			console.log("Rendering connected screen.");
			res.render('connected');
			
		});
	};

})();
