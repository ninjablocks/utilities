var 
	exec = require('child_process').exec
	, parser = require(__dirname + '/../lib/iwlist-parser')
	, cells = []
	, retries = 0
	, opts = { timeout : 100000 }
;

function error(err) {

	console.log("Error scanning for WiFi networks.", err);
	process.send({ 'action' : 'wifiScan', 'error' : err });	
};

function delay(fn) {

	return setTimeout(function() {

		if(typeof fn === 'function') {

			fn();
		}
	}, 2000);
};

/**
 * Split output lines into array & feed to parser
 */
function read(err, stdout, stderr) {
	
	if(err) {

		return error(err);
	}	

	stdout
		.split('\n')
		.map(parse)
	;

	if(cells.length == 0) {


		if(++retries < 4) {

			console.log("Retrying WiFi scan...");
			return delay(scan);
		}
		
		retries == 0;
		console.log("No networks found.");
		return error("No networks found.");
	}
	
	console.log("Scanned WiFi networks.");
	console.log(cells);
	send();
};

function send() {

	process.send({ 'action' : 'wifiScan', 'data' : cells });	
};

/**
 * Parse matching lines into cells list
 */
function parse(line, index, list) {

	parser.map(function(rule) {

		if(line.match(rule.pattern)) {

			rule.handle.call(line, cells);
		}	
	});
};

function scan() {

	cells = [];
	console.log("Scanning for WiFi networks...");
	exec('iwlist scan', opts, read);
};

module.exports = scan;
