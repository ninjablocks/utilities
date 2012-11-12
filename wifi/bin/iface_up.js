var 
	exec = require('child_process').exec
	, opts = { timeout : 100000 }
;

var error = function(err) {
	
	console.log("Error bringing interface wlan0 up.", err);
	process.send({ 'action' : 'ifaceUp', 'error' : err });
};

var up = function() { 
	
	console.log("Bringing interface wlan0 up...");
	exec('sudo ifconfig wlan0 up', opts, done);
};

var done = function(err, stdout, stderr) {

	if(err) { 

		return error(err); 
	}

	console.log("Interface wlan0 up.");
	process.send({ 'action' : 'ifaceUp', 'data' : true });
};

module.exports = up;
