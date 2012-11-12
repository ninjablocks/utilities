;(function() {
	
	var cells = {};

	var init = function() {

		$('#rescan').click(function() { window.location.href = '/'; });
		$('#connect').click(connect);
		$('.alert, div.control-group.hidden').hide().removeClass('hidden');
		$('select').on('change', choice);

		$('#password').keyup(function(e) {

			e.preventDefault();

			if($(this).val().length > 0) {

				$('#connect').removeClass('disabled').removeAttr('disabled');
			}
			else {

				$('#connect').addClass('disabled').attr('disabled', 'disabled');
			}
		});
		// scanning for wifi alert
		$($('.alert-info')[0]).fadeIn();

		networks();
	};

	var choice = function(e) {

		e.preventDefault();
		var val = $(this).val();
		console.log(val);
		console.log(cells);
		if(val !== "null" && cells[val]) {

			if(cells[val].encryption == true) {

				$('#connect').addClass('disabled').attr('disabled', 'disabled');

				// show the password box
				return $($('div.control-group')[1]).slideDown();
			}
			else {

				$('#connect').removeClass('disabled').removeAttr('disabled');
			}
		}
		// hide the password box
		$($('div.control-group')[1]).slideUp();
	};

	var connect = function(e) {

		e.preventDefault();
		var dat = $('form').serializeObject();

		if(dat.network) {

			$.ajax({

				type : 'POST'
				, url : '/connect'
				, dataType : 'JSON'
				, data : dat
				, success : connected
				, failure : connect
			})
		};
	};

	var connected = function(dat) {

		if((dat) && !dat.error) {

			window.location.href = '/connected';
		}
	};

	var networks = function() {

		$.ajax({

			type : 'GET'
			, url : '/networks'
			, dataType : 'JSON'
			, success : function(dat) { setTimeout(function() { networkList(dat) }, 2000); }
			, failure : networks
		})
	};

	var option = function(o) {

		if(!o.address || !o.ssid) { return null; }
		return $('<option>')

			.attr('value', o.address)
			.html(o.ssid)
		;
	};

	var networkList = function(dat) {

		$('.alert:visible').slideUp();
		if((dat) && (dat.networks)) {

			var 
				list = dat.networks.map(option)
				, select = $('#networks')
			;

			// save each network in cell list
			dat.networks.forEach(function(cell) { cells[cell.address] = cell; });

			select.html('');

			if(dat.networks.length > 0) {

				list.forEach(function(option) {

					select.append(option);
				});

				select.prepend($('<option>').attr('value', 'null').html('&nbsp;'));
				$($('.control-group')[0]).slideDown();
			}
			else {

				// no networks found.
				$($('.alert-info')[1]).slideDown();		
			}
		}
		else {

			// some error happened.
			$($('.alert-info')[2]).slideDown();					
		}
	};

	$(init);	

	$.fn.serializeObject = function(){

		var o = {};
		var a = this.serializeArray();
		$.each(a, function() {

			if (o[this.name]) {

				if (!o[this.name].push) {

					o[this.name] = [o[this.name]];
				}
				o[this.name].push(this.value || '');
			} 
			else{

				o[this.name] = this.value || '';
			}
		});
		return o;
	};

})();
