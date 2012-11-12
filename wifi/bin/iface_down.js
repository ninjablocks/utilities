var 
	exec = require('child_process').exec
	, opts = { timeout : 100000 }
;

var error = function(err) {

	console.log("Error taking interface wlan0 down.", err);
	process.send({ 'action' : 'ifaceDown', 'error' : err });
};

var down = function() { 
	
	console.log("Taking interface wlan0 down...")
	exec('sudo ifconfig wlan0 down', opts, done);
};

var done = function(err, stdout, stderr) {

	if(err) { 

		return error(err); 
	}

	console.log("Interface wlan0 down.");
	process.send({ 'action' : 'ifaceDown', 'data' : true });
};

module.exports = down;
