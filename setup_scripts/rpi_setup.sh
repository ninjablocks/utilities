#!/bin/bash

# Run this script as root ie:
# sudo -s
# bash <(wget -q -O - https://raw.github.com/ninjablocks/utilities/pi/setup_scripts/rpi_setup.sh)

bold=`tput bold`;
normal=`tput sgr0`;
username="pi"

# Setup the timezone
echo -e "\n→ ${bold}Setting up Sydney as the default timezone.${normal}\n";
sudo echo "Australia/Sydney" | sudo tee /etc/timezone;
sudo dpkg-reconfigure --frontend noninteractive tzdata;

# Updating apt-get
echo -e "\n→ ${bold}Updating apt-get${normal}\n";
sudo apt-get update;

echo -e "\n→ ${bold}Installing ntpdate${normal}\n";
sudo apt-get -qq -y -f -m install ntpdate

# Add NTP Update as a daily cron job
echo -e "\n→ ${bold}Create the ntpdate file${normal}\n";
sudo touch /etc/cron.daily/ntpdate;
echo -e "\n→ ${bold}Add ntpdate ntp.ubuntu.com${normal}\n";
sudo echo "ntpdate ntp.ubuntu.com" > /etc/cron.daily/ntpdate;
echo -e "\n→ ${bold}Making ntpdate executable${normal}\n";
sudo chmod 755 /etc/cron.daily/ntpdate;


# Update the timedate
echo -e "\n→ ${bold}Updating the time${normal}\n";
sudo ntpdate ntp.ubuntu.com pool.ntp.org;

# Download and install the Essential packages.
echo -e "\n→ ${bold}Installing git${normal}\n";
sudo apt-get -qq -y -f -m  install git; 
echo -e "\n→ ${bold}Installing g++${normal}\n";
sudo apt-get -qq -y -f -m  install g++;
echo -e "\n→ ${bold}Installing node${normal}\n";
sudo apt-get -qq -y -f -m  install nodejs;
echo -e "\n→ ${bold}Installing npm${normal}\n"; 
sudo apt-get -qq -y -f -m  install npm;
echo -e "\n→ ${bold}Installing ruby1.9.1-dev${normal}\n"; 
sudo apt-get -qq -y -f -m  install ruby1.9.1-dev;
echo -e "\n→ ${bold}Installing make${normal}\n"; 
sudo apt-get -qq -y -f -m  install make;
echo -e "\n→ ${bold}Installing build-essential${normal}\n"; 
sudo apt-get -qq -y -f -m  install build-essential;
echo -e "\n→ ${bold}Installing avrdude${normal}\n"; 
sudo apt-get -qq -y -f -m  install avrdude;
echo -e "\n→ ${bold}Installing libgd2-xpm-dev${normal}\n"; 
sudo apt-get -qq -y -f -m  install libgd2-xpm-dev;
echo -e "\n→ ${bold}Installing libv4l-dev${normal}\n"; 
sudo apt-get -qq -y -f -m  install libv4l-dev;

echo -e "\n→ ${bold}Installing subversion${normal}\n"; 
sudo apt-get -qq -y -f -m  install subversion;
echo -e "\n→ ${bold}Installing libjpeg8-dev${normal}\n"; 
sudo apt-get -qq -y -f -m  install libjpeg8-dev;
echo -e "\n→ ${bold}Installing imagemagick${normal}\n"; 
sudo apt-get -qq -y -f -m  install imagemagick;

echo -e "\n→ ${bold}Installing psmisc${normal}\n"; 
sudo apt-get -qq -y -f -m  install psmisc;

echo -e "\n→ ${bold}Installing curl${normal}\n"; 
sudo apt-get -qq -y -f -m  install curl;

# Switching to user dir
echo -e "\n→ ${bold}Switching to /home/${username}${normal}\n"; 
cd /home/${username};

# Checking out mjpeg-streamer
echo -e "\n→ ${bold}Checking out mjpeg-streamer${normal}\n"; 
svn co https://mjpg-streamer.svn.sourceforge.net/svnroot/mjpg-streamer mjpg-streamer;

# Entering the mjpeg-streamer dir
echo -e "\n→ ${bold}Entering the mjpeg-streamer dir${normal}\n"; 
cd /home/${username}/mjpg-streamer/mjpg-streamer/;

# Making mjpeg-streamer
echo -e "\n→ ${bold}Making mjpeg-streamer${normal}\n"; 
sudo make;

# Copying input_uvc.so into place
echo -e "\n→ ${bold}Copying input_uvc.so into place${normal}\n"; 
sudo cp /home/${username}/mjpg-streamer/mjpg-streamer/input_uvc.so /usr/local/lib/;

# Copying output_http.so into place
echo -e "\n→ ${bold}Copying output_http.so into place${normal}\n"; 
sudo cp /home/${username}/mjpg-streamer/mjpg-streamer/output_http.so /usr/local/lib/;

# Copying the mjpg-streamer binary into /usr/bin
echo -e "\n→ ${bold}Copying the mjpg-streamer binary into /usr/bin${normal}\n"; 
sudo cp /home/${username}/mjpg-streamer/mjpg-streamer/mjpg_streamer /usr/local/bin;

# Not essential packages
echo -e "\n→ ${bold}Installing aptitude${normal}\n"; 
sudo apt-get -qq -y -f -m  install aptitude;
echo -e "\n→ ${bold}Installing vim${normal}\n"; 
sudo apt-get -qq -y -f -m  install vim;

# Install Sinatra
echo -e "\n→ ${bold}Installing the sinatra gem${normal}\n"; 
sudo gem install sinatra  --verbose --no-rdoc --no-ri;

# Install getifaddrs
echo -e "\n→ ${bold}Installing the getifaddrs gem${normal}\n"; 
sudo gem install system-getifaddrs  --verbose --no-rdoc --no-ri;


# # Copy /opt/utilities/etc/wpa_supplicant.conf to /etc/
echo -e "\n→ ${bold}Copy /opt/utilities/etc/wpa_supplicant.conf to /etc/${normal}\n";
sudo cp /opt/utilities/etc/wpa_supplicant.conf /etc/;

# Set the permissions of the wpa_supplicant.conf file
echo -e "\n→ ${bold}Set the permissions of the wpa_supplicant.conf file${normal}\n";
sudo chmod 644 /opt/utilities/etc/wpa_supplicant.conf;

# Make /etc/network/interfaces use wpa_supplicant for wlan0
echo -e "\n→ ${bold} Make /etc/network/interfaces use wpa_supplicant for wlan0${normal}\n";

sudo echo "auto wlan0" >> /etc/network/interfaces;
sudo echo "iface wlan0 inet dhcp" >> /etc/network/interfaces;
sudo echo "pre-up wpa_supplicant -B -D wext -i wlan0 -c /etc/wpa_supplicant.conf" >> /etc/network/interfaces;
sudo echo "post-down killall -q wpa_supplicant" >> /etc/network/interfaces;

# Create the Ninja Blocks utilities folder
echo -e "\n→ ${bold}Create the Ninja Blocks Utilities Folder${normal}\n"; 
sudo mkdir -p  /opt/utilities;

# Set user as the owner of this directory.
echo -e "\n→ ${bold}Set ${username} user as the owner of this directory${normal}\n";
sudo chown ${username} /opt/utilities;

# Clone the Ninja Utilities into /opt/utilities
echo -e "\n→ ${bold}Fetching the Utilities Repo from Github${normal}\n";
git clone https://github.com/ninjablocks/utilities.git /opt/utilities;
cd /opt/utilities
git checkout pi

# Clone the Wifi Setup into /opt/wifi
sudo mkdir -p  /opt/wifi;
echo -e "\n→ ${bold}Fetching the Wifi Repo from Github${normal}\n";
git clone https://github.com/ninjablocks/wifi.git /opt/wifi;


echo -e "\n→ ${bold}Copying init scripts into place${normal}\n";
sudo sed -i 's/exit 0/\/opt\/utilities\/bin\/ninja_start\nexit 0/' /etc/rc.local


# Copy /etc/udev/rules.d/ scripts into place
echo -e "\n→ ${bold}Copy /etc/udev/rules.d/ scripts into place${normal}\n";
sudo cp /opt/utilities/udev/* /etc/udev/rules.d/;


# Create Ninja Directory (-p to preserve if already exists).
echo -e "\n→ ${bold}Create the Ninja Directory${normal}\n";
sudo mkdir -p /opt/ninja;

# Set user as the owner of this directory.
echo -e "\n→ ${bold}Set ${username} users as the owner of this directory${normal}\n";
sudo chown ${username} /opt/ninja;

# Clone the Ninja Client into opt
echo -e "\n→ ${bold}Clone the Ninja Client into opt${normal}\n";
git clone https://github.com/ninjablocks/client.git /opt/ninja;
cd /opt/ninja
git checkout pi

# Install the node packages
echo -e "\n→ ${bold}Install the node packages${normal}\n";
cd /opt/ninja;
npm install;

# Create directory /etc/opt/ninja
echo -e "\n→ ${bold}Adding /etc/opt/ninja${normal}\n";
sudo mkdir -p /etc/opt/ninja;

# Set owner of this directory to user
echo -e "\n→ ${bold}Set owner of this directory to ${username}${normal}\n";
sudo chown ${username} /etc/opt/ninja;

# Add /opt/utilities/bin to root's path
echo -e "\n→ ${bold}Adding /opt/utilities/bin to root's path${normal}\n";
echo 'export PATH=/opt/utilities/bin:$PATH' >> /root/.bashrc;

# Add /opt/utilities/bin to user's path
echo -e "\n→ ${bold}Adding /opt/utilities/bin to ${username}'s path${normal}\n";
echo 'export PATH=/opt/utilities/bin:$PATH' >> /home/${username}/.bashrc;

# Set the beagle's environment
echo -e "\n→ ${bold}Setting the beagle's environment to stable${normal}\n";
echo 'export NINJA_ENV=stable' >> /home/${username}/.bashrc;

# Add ninja_update to the hourly cron
#echo -e "\n→ ${bold}Add ninja_update to the hourly cron${normal}\n";
#ln -s /opt/utilities/bin/ninja_update /etc/cron.hourly/ninja_update;

# Run the setserial command so we can flash the Arduino later
echo -e "\n→ ${bold}Getting serial number from system${normal}\n";
sudo /opt/utilities/bin/serialnumber;

echo -e "Running system update script"
sudo /opt/utilities/bin/ninja_update_system;

echo -e "\n→ ${bold}Guess what? We're done!!!${normal}\n";

echo -e "Before you reboot, write down this serial-- this is what you will need to activate your new Pi!"

echo -e "--------------------------------------------------------------"
echo -e "|                                                            |"
echo -e "|           Your NinjaPi Serial is: `cat /etc/opt/ninja/serial.conf`         |"
echo -e "|                                                            |"
echo -e "--------------------------------------------------------------"


