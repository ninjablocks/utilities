var 
	filter = function(arr) {

		return arr.filter(function(e) { return e == '' ? false : true });
	}
	, data = undefined
;

module.exports = [ 
	{
		name : 'ssid' // network name (SSID)
		, pattern : /ESSID:/
		, handle : function(data) {

			data
				.ssid = this.split(':')[1].replace(/"/g, '').trim() || 
					'Unnamed Network'
			;
		}
	}
	, {
		name : 'bitrate' // bit rate
		, pattern : /Bit Rate=/
		, handle : function(data) {

			data
				.bitrate = parseInt(this.split('=')[1].split(' ')[0])
			;
		}
	}
	, {
		name : 'quality' // signal quality 
		, pattern : /Quality=[0-9]+\/[0-9]+/
		, handle : function(data) {

			data.quality = filter(this.split(' '))[1].split('=')[1];
			data.signal = parseInt(filter(this.split(' '))[3].split('=')[1]);
		}
	}
];