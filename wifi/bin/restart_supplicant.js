var 
	exec = require('child_process').exec
	, opts = { timeout : 100000 }
	, killall = 'sudo killall -q -s SIGHUP wpa_supplicant'
;

var error = function(err) {

	console.log("Error restarting wpa_supplicant.", err);
	process.send({ 'action' : 'restartSupplicant', 'error' : err });	
};

var kill = function() {

	console.log("Restarting wpa_supplicant...");
	exec(killall, opts, done);
};

var done = function(err, stdout, stderr) {

	if(err) { 

		return error(err); 
	}

	console.log("Restarted wpa_supplicant.");
	process.send({ 'action' : 'restartSupplicant', 'data' : true });
};

module.exports = kill;
