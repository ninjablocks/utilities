var 
	filter = function(arr) {

		return arr.filter(function(e) { return e == '' ? false : true });
	}
	, cell = undefined
;

module.exports = [ 
	{
		name : 'cell' // beginning of an AP definition
		, pattern : /Cell ([0-9][0-9])/
		, handle : function(cells) {

			var 
				dat = filter(this.split(' '))
			;
			cell = {};
			cell.address = dat[4];
			cells[cells.length] = cell;
		}
	}
	, {
		name : 'ssid' // network name (SSID)
		, pattern : /ESSID/
		, handle : function() {

			cell
				.ssid = this.split(':')[1].replace(/"/g, '') || 
					'Unnamed Network'
			;
		}
	}
	, {
		name : 'encryption' // encryption status
		, pattern : /Encryption key/
		, handle : function() {

			cell
				.encryption = (this.split(':')[1] || '') == 'on' ? 
					true : false
			;
		}
	}
	, {
		name : 'quality' // signal quality
		, pattern : /Quality=[0-9]+\/[0-9]+/
		, handle : function() {

			cell.quality = filter(this.split(' '))[0].split('=')[1];
			cell.signal = parseInt(filter(this.split(' '))[2].split('=')[1]);
		}
	}
	, {
		name : 'enc-type' // WPA
		, pattern : /IE: WPA .+ [0-9]/
		, handle : function() {

			cell.encType = 'WPA' + filter(this.split(' '))[3];
		}
	}
	, {
		name : 'enc-type2' // WPA 2
		, pattern : /IE: IEEE 802.11i\/WPA.+[0-9]/
		, handle : function() {

			cell.encType = 'WPA2';
		}
	}
	, {
		name : 'auth' // auth types available
		, pattern : /Authentication Suites/
		, handle : function() {

			cell.auth = filter(this.split(' '))[4];
		}
	}
];