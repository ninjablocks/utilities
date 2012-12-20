var 
	exec = require('child_process').exec
	, parser = require(__dirname + '/../lib/iwconfig-parser')
	, data = {}
	, opts = { timeout : 100000 }
;

/**
 * Split output lines into array & feed to parser
 */
function read(err, stdout, stderr) {
	
	if(err) {

		/**
		* Send no device error as null instead of error, it's expected.
		*/
		if(err.code == 237) {

			console.log('No interface detected.');
			return process.send({ 'action' : 'ifaceCheck', 'data' : null });
		}
		console.log("Error checking interface.", err);
		return process.send({ 'action' : 'ifaceCheck', 'error' : err });
	}	

	stdout
		.split('\n')
		.map(parse)
	;

	console.log("Interface check complete.");
	console.log(data);
	process.send({ 'action' : 'ifaceCheck', 'data' : data });
};

/**
 * Parse matching lines into data object
 */
function parse(line, index, list) {

	parser.map(function(rule) {

		if(line.match(rule.pattern)) {

			rule.handle.call(line, data);
		}	
	});
};

module.exports = function() { 

	data = {};
	console.log("Checking interface...");
	exec('iwconfig wlan0', opts, read);

};