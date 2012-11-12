var 
	exec = require('child_process').exec
	, opts = { timeout : 20000 }
;

function sync(err, stdout, stderr) {
	
	if(err) {

		console.log("Error syncing to disk.");
		return process.send({ 'action' : 'syncDisk', 'error' : err });
	}

	/**
	 * Delay before signaling a successful sync, just
	 * to make sure the system has a chance to write.
	 */
	setTimeout(function() {

		console.log("Synced to disk.");
		process.send({ 'action' : 'syncDisk', 'data' : true });
	}, 1000);
};

module.exports = function() { 

	console.log("Syncing to disk...");
	exec('sync', opts, sync) 
};
