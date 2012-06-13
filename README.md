Utilities
=========

The Utilities git repository is a set of helper apps for Ninja Blocks.
The scripts are kept in /utilities/bin/

arduino_update
---------------
This script updates your Arduino by: 

* Downloading the latest Arduino hex code hosted on gist 2850770.
* Calling setgpio to enable the pin on the Beagle that is attached to the ATMEGA reset pin on the Arduino. 
* Calling setserial to enable the UART serial port for programming the Arduino. 
* Calling avrdude and uploading the hex code to the board. 


serialnumber |  Serial Number
----------------------------
* Returns the Beaglebone's Serial Number. 
* Serialnumber (must be run as root).

picture | Images as Base64
--------------------------
* Takes an image with the first available camera and outputs a Base64 string of the image.

wifi_status | Prints the status of the Wi-Fi network
----------------------------------------------------
* Returns 'up' if the Wi-Fi network is up. 
* Reutnrs 'down' if the Wi-Fi netowrk is down. 

setgpio | Sets the GPIO on Pin 7
--------------------------------
* This sets pin 7 on the beagleboard to GPIO, allowing us to later reset the arduino

setserial | Sets up the Serial Pins
---------------------------------
* This sets the mux for the UART pins on the Beagle so we can speak serial to the Arduino 

color | Sets the color of the RGB LED
-------------------------------------
* A tiny script that sets the color of the RGB Led on the Arduino. 
* options are: red, orange, blue, green, and off

fswebcam | A light weight webcam snapshot grabber
----------------------------------------------
* Requires libgd2-xpm & libgd2-xpm-dev
* Available here: http://www.firestorm.cx/fswebcam/ 
* Command used by picture: fswebcam -q --no-banner --save /tmp/output.jpeg 2>&1