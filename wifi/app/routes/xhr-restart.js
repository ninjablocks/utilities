;(function() {
	
	module.exports = function(app) {

		app.get('/restart', function(req, res, next) {

			app.send('restartBlock', true);
			res.json({ 'restart' : true });
		});
	};

})();
