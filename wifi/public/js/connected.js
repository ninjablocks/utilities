;(function() {
	
	var
		token = ""
		, init = function() {

			$('button').click(restart);
			$('#close').removeClass('hidden').hide();
		}
		, close = function() {

			$('#close').fadeIn(200);
		}
		, error = function(dat) {

			$('p').html([

				'An error occurred while restarting your Ninja Block.'
				, 'Please try again.'
			].join(' '));
		}
		, restarting = function(dat) {

			if(!(dat) || dat.error) {

				return error(null);
			}

			$('p').html([

				'Your Ninja Block is now restarting...'
				, 'Please be patient.'
			].join(' '));

			setTimeout(close, 15000);
		}
		, restart = function(e) {

			e.preventDefault();

			$.ajax({

				url : '/restart'
				, data : { 'token' : token }
				, dataType : 'JSON'
				, success : restarting
				, error : error
			});
		}
	;

	$(init);

})();
