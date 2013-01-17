var 
	exec = require('child_process').exec
	, opts = { timout : 10000 }
	, actions = {

		"wifiScan" : require('./bin/wifi_scan')
		, "ifaceUp" : require('./bin/iface_up')
		, "syncDisk" : require('./bin/sync_disk')
		, "ifaceDown" : require('./bin/iface_down')
		, "ifaceCheck" : require('./bin/iface_check')
		, "deviceCheck" : require('./bin/device_check')
		, "writeConfig" : require('./bin/write_config')
		, "restartBlock" : require('./bin/restart_block')
		, "restartSupplicant" : require('./bin/restart_supplicant')
		, "init" : function() {

			actions.deviceCheck();

		}
	}
;

function handleMessage(dat) {

	if(!dat) { return; }
	
	var action = dat.action || undefined;
	if((actions[action]) && typeof actions[action] == "function") {

		actions[action](dat.data || null);
	}
	else {

		process.send({ 'error' : 'unknownAction', 'action' : action });
	}
};

process.on('message', handleMessage);
