
if (process.argv.length < 3) {
  process.exit(1);
}
var baudParam = parseInt(process.argv[2]);
if (isNaN(baudParam)) {
  process.exit(1);
}

var serialport = require('serialport'),
    SerialPort = serialport.SerialPort;
try {
  // Setup the TTY serial port
  var tty = new SerialPort('/dev/ttyO1', {
      parser: serialport.parsers.readline("\n")
      , baudrate : baudParam
  });
}
catch (err) {
  process.exit(1);
}
tty.on('data',function(data){
    try {
        var device = JSON.parse(data);
    } catch (err) { return; }
    if (device.ACK && device.ACK[0].D===1003) {
        process.stdout.write(device.ACK[0].DA);
        process.exit(0);
    }
});

setInterval(function() {
    tty.write('{"DEVICE":[{"G":"0","V":0,"D":1003,"DA":"VNO"}]}');
},500);

tty.write('{"DEVICE":[{"G":"0","V":0,"D":1003,"DA":"VNO"}]}');

setTimeout(function() {
    process.exit(1);
},3000);
