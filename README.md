Utilities
=========

The Utilities git repository is a set of helper apps for Ninja Blocks.
The scripts are kept in /utilities/bin/


arduino_update
--------------
This script updates your Arduino by: 

- Downloading the latest Arduino hex code hosted on gist 2850770.
- Calling setgpio to enable the pin on the Beagle that is attached to the ATMEGA reset pin on the Arduino. 
- Calling setserial to enable the UART serial port for programming the Arduino. 
- Calling avrdude and uploading the hex code to the board. 


color
-----
A tiny script that sets the color of the RGB Led on the Arduino. 
- options are: red, orange, blue, green, and off.


document_config
---------------
This script prints out the configuration of the Beagle Bone including: 
- The Ubuntu Config.
- A list of installed debian packages.
- A list of installed ruby gems.


fswebcam
--------
Fswebcam is a light weight webcam snapshot grabber that's open source.
* Requires libgd2-xpm & libgd2-xpm-dev
* Available here: http://www.firestorm.cx/fswebcam/ 
* Command used by picture: fswebcam -q --no-banner --save /tmp/output.jpeg 2>&1


ninja_update
------------
Ninja Update is intended to be run after a git pull.
It runs all scripts in /utilities/update_scripts/*


picture
-------
Picture takes an picture using fswebcam and outputs a base64 string.
The idea is that it can be called from node. 


reset_arduino
-------------
Call this script to reset your Arduino.
- reset_arduino must be run as root.


serialnumber
------------
Returns the Beaglebone's Serial Number. 
- Serialnumber (must be run as root).


setgpio
-------
- This sets pin 7 on the Beaglebone to GPIO, allowing us to later reset the Arduino.


setserial
---------
- This sets the MUX for the UART pins on the Beagle so we can speak serial to the Arduino. 


wifi_status
-----------
- Returns 'up' if the Wi-Fi network is up.
- Returns 'down' if the Wi-Fi network is down.