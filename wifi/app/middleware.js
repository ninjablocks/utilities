var 
	device = false
	, iface = undefined
	, connected = false
	, cycling = false
	, state
;

module.exports = function(app) {

	/**
	 * When device comes up, try to bring the
	 * interface up as well
	 */
	app.on('deviceCheck', function(dat) {

		if((!dat) || ((dat) && dat.error)) { 
		
			return device = false;
		}

		if(!device) {

			app.send('ifaceUp', true);
		}

		device = true;
	});

	app.on('ifaceCheck', function(dat) {

		if((!dat) || ((dat) && dat.error)) { 

			return iface = undefined;
		}

		iface = dat;
	});
	
	/**
	 * When config has been written, sync
	 * to disc and start an iface cycle
	 */
	app.on('writeConfig', function(dat) {

		if((!dat) || ((dat) && dat.error)) {

			return;
		}
		cycling	= true;
		app.send('syncDisk', true);		
		app.send('ifaceDown', true);

	});

	/**
	 * Bring the iface back up if we are
	 * in the middle of cycling
	 */
	app.on('ifaceDown', function(dat) {

		if(!cycling) { return; }

		app.send('ifaceUp', true);
		state = setTimeout(function() {

			cycling = false;
		}, 10000);

	});

	/**
	 * Scan for networks when the iface 
	 * comes up. 
	 */
	 app.on('ifaceUp', function(dat) {

 		app.send('wifiScan', true);
	 });
	 
	/**
	 * Clear the cycle state if applicable
	 */
	app.on('ifaceUp', function(dat) {

		if(!cycling) { return; }

		clearTimeout(state);
		cycling = false;

	});

	/**
	* Could use a refactor
	*/
	var mids = {

		hasDevice : function(req, res, next) {

			if(!device) {

				return res.redirect('/plugin');
			}
			next();
		}
		, hasIface : function(req, res, next) {

			if(!iface) {

				return res.redirect('/plugin');
			}
			next();
		}
		, isConnected : function(req, res, next) {

			// check for AP association
			next();
		}
		, notCycling : function(req, res, next) {

			if(cycling) {

				return res.redirect('/plugin');
			}
			next();
		}
	};

	/**
	 * Convenience wrappers
	 */
	mids.ready = [ 

		mids.hasDevice
		, mids.hasIface 
		, mids.notCycling
	];

	mids.online = [ 

		mids.hasDevice
		, mids.hasIface
		, mids.isConnected 
	];

	return mids;
};
