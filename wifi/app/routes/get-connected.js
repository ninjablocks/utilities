;(function() {
	
	module.exports = function(app) {

		var reset = function reset() {

			app.send('restartBlock', true);
			
		};

		app.get('/connected', function(req, res, next) {

			console.log("Rendering connected screen.");
			res.render('connected');
			setTimeout(reset, 5000);
		});
	};

})();
