;(function() {
	
	var cells = { };

	var init = function() {

		$('#rescan').click(function() { window.location.href = '/'; });
		$('#connect').click(connect);
		$('.alert, div.control-group.hidden, #ssid').hide().removeClass('hidden');
		$($('div.control-group')[3]).slideDown(200);
		$('select').on('change', choice);
		$('#password').keyup(function(e) {

			e.preventDefault();

			if($(this).val().length > 0) {

				connectable(true);
				if(e.keyCode == 13) { // enter key

					$('#connect').trigger('click');
					return;
				}
			}
			else {

				connectable(false);
			}
		});

		$('#hidden').click(hidden);
		// scanning for wifi alert
		$($('.alert-info')[0]).fadeIn();

		networks();
		manual(false);
		secured(false);
		connectable(false);
		$('#hidden').removeAttr('checked');
	};

	var choice = function(e) {

		e.preventDefault();
		
		var 
			id = $(this).attr('id')
			, val = $(this).val()
			, networkChoice = function() {

				if(val !== 'null' && cells[val]) {

					if(cells[val].encryption == true) {

						connectable(false);
						return secured(true);
					}
					else {

						connectable(true);
					}
				}
				if(val == null) { 

					connectable(false)
				}
				secured(false);				
			}
			, securityChoice = function() {

				if(val == 'null') {

					connectable(false);
					secured(false);
				} 
				else if(val == 'WEP' || val.substr(0, 3) == "WPA") {

					connectable(false);
					secured(true);
				}
				else if(val == "NONE") {

					connectable(true);
					secured(false);
				}
			}
		;

		if(id == "networks") {

			networkChoice();
		}
		else if(id == "security") {

			securityChoice();
		}
	};

	var connect = function(e) {

		e.preventDefault();
		var dat = $('form').serializeObject();

		if(!dat.ssid) { // drop-down network choice

			delete dat.ssid;
			delete dat.security;
		}
		else { // non-broadcast (manual) network

			delete dat.network;
			if(dat.security === "NONE") {

				delete dat.password;
			}
		}

		if(dat.network || dat.ssid) {

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
			, success : function(dat) { 

				setTimeout(function() { networkList(dat) }, 2000); 
			}
			, failure : networks
			, cache : false
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
			dat.networks.forEach(function(cell) { 
				
				cells[cell.address] = cell; 
			});

			select.html('');

			if(dat.networks.length > 0) {

				list.forEach(function(option) {

					select.append(option);
				});

				select.prepend(

					$('<option>').attr('value', 'null').html('&nbsp;')
				);
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

	var hidden = function(e) {

		var elements = [

			$('#networks')
			, $('#ssid')
		];

		if(!$(this).is(':checked')) {

			elements.unshift(elements.pop());
			$('#networks').trigger('change');
			manual(false);
		}
		else{

			connectable(false);
			secured(false);
			manual(true);
		}

		// prevent double-clicks from desyncing checkbox
		if(!elements[0].is(':visible') || elements[1].is(':visible')) { 

			e.preventDefault(); 
			return false; 
		}

		elements[0].stop(true, true).fadeOut(200, function() {

			elements[1].stop(true, true).fadeIn(200);
		});
	};

	var connectable = function(bool) {

		if(!bool) {

			$('#connect').addClass('disabled').attr('disabled', 'disabled');
			return;
		}
		$('#connect').removeClass('disabled').removeAttr('disabled');
	};

	var secured = function(bool) {

		$('#password').val('');
		if(!bool) {

			$($('div.control-group')[1]).slideUp(200);	
			return;		
		}
		$($('div.control-group')[1]).slideDown(200);
	};

	var manual = function(bool) {

		$('#password').val('');		
		if(!bool) {

			$($('div.control-group')[2]).slideUp(200);
			$('#networks').val('null');	
			$('#ssid').val('');
			return;
		}
		$($('div.control-group')[2]).slideDown(200);
		$('#security').val('null');
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
