var 
	exec = require('child_process').exec
	, opts = { timeout : 10000 }
;

function read(err, stdout, stderr) {
	
	if(err) {

		console.log("Error checking for devices.", err);
		return process.send({ 'action' : 'deviceCheck', 'error' : err });
	}

	var res = { 'action' : 'deviceCheck', 'data' : false };
	/**
	 * Check for 802.11
	 */
	if(stdout.indexOf('802.11') >= 0) {

		console.log("Found 802.11 device.");
		res.data = true;
	}
	else if(stdout.indexOf('WLAN') >= 0) {

		console.log("Found WLAN device.");
		res.data = true;
	}
	else {

		console.log("Found no recognized devices.");
	}
	process.send(res);
};

module.exports = function() { 

	console.log("Checking for devices...");
	exec('lsusb', opts, read) 
}