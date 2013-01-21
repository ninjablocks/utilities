;(function() {
	
	var 
		check = function() {

			$.ajax({

				type : "GET"
				, url : "/device"
				, dataType : "JSON"
				, success : connected
				, failure : error
				, cache : false
			})
		}
		, connected = function(dat) {

			if((dat)) {

				if(dat.device && dat.iface) {

					/**
					 * Reload and let the app reroute
					 * us appropriately.
					 */

					connecting();
					setTimeout(function() {

						window.location.href = '/';

					 }, 10000);
				}
				else {

					/**
					 * Wait for them to plug it in
					 */
					setTimeout(check, 2000);
				}
			}
		}
		, error = function() {

			/**
			 * Oh well, let's try again.
			 */
			setTimeout(check, 2000);
		}
		, connecting = function() {

			$('#waiting').fadeOut(200, function() {
				
				$('#connecting').fadeIn(200);
			})
		}
	;

	$(function() {

		check();
		$('#connecting')
			.removeClass('hidden')
			.hide()
		;			
	});

})();