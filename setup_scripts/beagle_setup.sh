#!/bin/bash

# Run this script as root ie:
# sudo -s
# bash <(wget -q -O - https://raw.github.com/ninjablocks/utilities/master/setup_scripts/beagle_setup.sh)

bold=`tput bold`;
normal=`tput sgr0`;

# Setup the timezone
echo -e "\n→ ${bold}Setting up Sydney as the default timezone.${normal}\n";
sudo echo "Australia/Sydney" | sudo tee /etc/timezone;
sudo dpkg-reconfigure --frontend noninteractive tzdata;

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

# Stop Ubuntu from saving the Mac Address
echo -e "\n→ ${bold}Stopping Ubuntu from saving the MAC address information${normal}\n";
sudo touch /etc/udev/rules.d/75-persistent-net-generator.rules;
sudo echo 'ENV{MATCHADDR}=="*", GOTO="persistent_net_generator_end"'> /etc/udev/rules.d/75-persistent-net-generator.rules;

# Updating apt-get
echo -e "\n→ ${bold}Updating apt-get${normal}\n";
sudo apt-get update;

# Remove the Apache2 default install
echo -e "\n→ ${bold}Removing Apache2${normal}\n";
sudo apt-get -f -y --force-yes remove apache2;
sudo apt-get -f -y --force-yes remove apache2.2-bin apache2.2-common apache2-utils apache2-mpm-worker;


# Download and install the Essential packages.
echo -e "\n→ ${bold}Installing g++${normal}\n";
sudo apt-get -f -y --force-yes install g++;
echo -e "\n→ ${bold}Installing node${normal}\n";
sudo apt-get -f -y --force-yes install node;
echo -e "\n→ ${bold}Installing npm${normal}\n"; 
sudo apt-get -f -y --force-yes install npm;
echo -e "\n→ ${bold}Installing ruby1.9.1-dev${normal}\n"; 
sudo apt-get -f -y --force-yes install ruby1.9.1-dev;
echo -e "\n→ ${bold}Installing ruby1.9.1${normal}\n"; 
sudo apt-get -f -y --force-yes install ruby1.9.1;
echo -e "\n→ ${bold}Installing make${normal}\n"; 
sudo apt-get -f -y --force-yes install make;
echo -e "\n→ ${bold}Installing build-essential${normal}\n"; 
sudo apt-get -f -y --force-yes install build-essential;
echo -e "\n→ ${bold}Installing avrdude${normal}\n"; 
sudo apt-get -f -y --force-yes install avrdude;
echo -e "\n→ ${bold}Installing libgd2-xpm-dev${normal}\n"; 
sudo apt-get -f -y --force-yes install libgd2-xpm-dev;
echo -e "\n→ ${bold}Installing libv4l-dev${normal}\n"; 
sudo apt-get -f -y --force-yes install libv4l-dev;

echo -e "\n→ ${bold}Installing subversion${normal}\n"; 
sudo apt-get -f -y --force-yes install subversion;
echo -e "\n→ ${bold}Installing libjpeg8-dev${normal}\n"; 
sudo apt-get -f -y --force-yes install libjpeg8-dev;
echo -e "\n→ ${bold}Installing imagemagick${normal}\n"; 
sudo apt-get -f -y --force-yes install imagemagick;

echo -e "\n→ ${bold}Installing psmisc${normal}\n"; 
sudo apt-get -f -y --force-yes install psmisc;

echo -e "\n→ ${bold}Installing curl${normal}\n"; 
sudo apt-get -f -y --force-yes install curl;

# Switching to /home/ubuntu
echo -e "\n→ ${bold}Switching to /home/ubuntu${normal}\n"; 
cd /home/ubuntu/;

# Checking out mjpeg-streamer
echo -e "\n→ ${bold}Checking out mjpeg-streamer${normal}\n"; 
svn co https://mjpg-streamer.svn.sourceforge.net/svnroot/mjpg-streamer mjpg-streamer;

# Entering the mjpeg-streamer dir
echo -e "\n→ ${bold}Entering the mjpeg-streamer dir${normal}\n"; 
cd /home/ubuntu/mjpg-streamer/mjpg-streamer/;

# Making mjpeg-streamer
echo -e "\n→ ${bold}Making mjpeg-streamer${normal}\n"; 
sudo make;

# Copying input_uvc.so into place
echo -e "\n→ ${bold}Copying input_uvc.so into place${normal}\n"; 
sudo cp /home/ubuntu/mjpg-streamer/mjpg-streamer/input_uvc.so /usr/local/lib/;

# Copying output_http.so into place
echo -e "\n→ ${bold}Copying output_http.so into place${normal}\n"; 
sudo cp /home/ubuntu/mjpg-streamer/mjpg-streamer/output_http.so /usr/local/lib/;

# Copying the mjpg-streamer binary into /usr/bin
echo -e "\n→ ${bold}Copying the mjpg-streamer binary into /usr/bin${normal}\n"; 
sudo cp /home/ubuntu/mjpg-streamer/mjpg-streamer/mjpg_streamer /usr/local/bin;

# Not essential packages
echo -e "\n→ ${bold}Installing aptitude${normal}\n"; 
sudo apt-get -f -y --force-yes install aptitude;
echo -e "\n→ ${bold}Installing vim${normal}\n"; 
sudo apt-get -f -y --force-yes install vim;

# Install Sinatra
echo -e "\n→ ${bold}Installing the sinatra gem${normal}\n"; 
sudo gem install sinatra  --verbose --no-rdoc --no-ri;

# Install getifaddrs
echo -e "\n→ ${bold}Installing the getifaddrs gem${normal}\n"; 
sudo gem install system-getifaddrs  --verbose --no-rdoc --no-ri;

# Create the rtl8192cu folder
echo -e "\n→ ${bold}Create the rtl8192cu Folder${normal}\n";
sudo mkdir -p /opt/rtl8192cu;

# Clone rtl8192cu into /opt/rtl8192cu
echo -e "\n→ ${bold}Fetching the rtl8192cu Repo from Github${normal}\n";
sudo git clone https://github.com/ninjablocks/rtl8192cu.git /opt/rtl8192cu;

# Removing the shitty Realtek drivers from /lib/modules/`uname -r`/kernel/drivers/net/wireless/rtlwifi/rtl8*
echo -e "\n→ ${bold}Removing the shitty Realtek drivers${normal}\n";
sudo rm -rf /lib/modules/`uname -r`/kernel/drivers/net/wireless/rtlwifi/rtl8*;

# Copy /opt/utilities/etc/wpa_supplicant.conf to /etc/
echo -e "\n→ ${bold}Copy /opt/utilities/etc/wpa_supplicant.conf to /etc/${normal}\n";
sudo cp /opt/utilities/etc/wpa_supplicant.conf /etc/;

# Set the permissions of the wpa_supplicant.conf file
echo -e "\n→ ${bold}Set the permissions of the wpa_supplicant.conf file${normal}\n";
sudo chmod 644 /opt/utilities/etc/wpa_supplicant.conf;

# Make /etc/network/interfaces use wpa_supplicant for wlan0
echo -e "\n→ ${bold} Make /etc/network/interfaces use wpa_supplicant for wlan0${normal}\n";

sudo echo "auto wlan0" >> /etc/network/interfaces;
sudo echo "iface wlan0 inet dhcp" >> /etc/network/interfaces;
sudo echo "pre-up wpa_supplicant -f /var/log/wpa_supplicant.log -B -D wext -i wlan0 -c /etc/wpa_supplicant.conf" >> /etc/network/interfaces;
sudo echo "post-down killall -q wpa_supplicant" >> /etc/network/interfaces;

# Install our rtl8192cu driver
echo -e "\n→ ${bold}Install our rtl8192cu driver${normal}\n";
cd /opt/rtl8192cu;
sudo install -p -m 644 8192cu.ko /lib/modules/`uname -r`/kernel/drivers/net/wireless/;
sudo /sbin/depmod -a `uname -r`;

# Create the Ninja Blocks utilities folder
echo -e "\n→ ${bold}Create the Ninja Blocks Utilities Folder${normal}\n"; 
sudo mkdir -p  /opt/utilities;

# Set ubuntu user as the owner of this directory.
echo -e "\n→ ${bold}Set ubuntu user as the owner of this directory${normal}\n";
sudo chown ubuntu /opt/utilities;

# Clone the Ninja Utilities into /opt/utilities
echo -e "\n→ ${bold}Fetching the Utilities Repo from Github${normal}\n";
git clone https://github.com/ninjablocks/utilities.git /opt/utilities;

# Clone the Wifi Setup into /opt/wifi
#sudo mkdir -p  /opt/wifi;
#echo -e "\n→ ${bold}Fetching the Wifi Repo from Github${normal}\n";
#git clone https://github.com/ninjablocks/wifi.git /opt/wifi;

# Copy /etc/init scripts into place
echo -e "\n→ ${bold}Copy /etc/init scripts into place${normal}\n";
sudo cp /opt/utilities/init/* /etc/init/

# Set the correct owner and permissions on the files
echo -e "\n→ ${bold}Set the correct owner and permissions on the init files${normal}\n";
sudo chown root:root /etc/init/*;
sudo chmod 644 /etc/init/*;

# Turn off SSH Password Authentication
echo -e "\n→ ${bold}Turning of SSH Password Authentication${normal}\n";
#sudo perl -pi -e 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config;
#sudo perl -pi -e 's/\#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config;

# Copy /etc/udev/rules.d/ scripts into place
echo -e "\n→ ${bold}Copy /etc/udev/rules.d/ scripts into place${normal}\n";
sudo cp /opt/utilities/udev/* /etc/udev/rules.d/;


# Create Ninja Directory (-p to preserve if already exists).
echo -e "\n→ ${bold}Create the Ninja Directory${normal}\n";
sudo mkdir -p /opt/ninja;

# Set ubuntu users as the owner of this directory.
echo -e "\n→ ${bold}Set ubuntu users as the owner of this directory${normal}\n";
sudo chown ubuntu /opt/ninja;

# Clone the Ninja Client into opt
echo -e "\n→ ${bold}Clone the Ninja Client into opt${normal}\n";
git clone https://github.com/ninjablocks/client.git /opt/ninja;

# Install the node packages
echo -e "\n→ ${bold}Install the node packages${normal}\n";
cd /opt/ninja;
npm install;

# Create directory /etc/opt/ninja
echo -e "\n→ ${bold}Adding /etc/opt/ninja${normal}\n";
sudo mkdir -p /etc/opt/ninja;

# Set owner of this directory to ubuntu
echo -e "\n→ ${bold}Set owner of this directory to ubuntu${normal}\n";
sudo chown ubuntu /etc/opt/ninja;

# Add /opt/utilities/bin to root's path
echo -e "\n→ ${bold}Adding /opt/utilities/bin to root's path${normal}\n";
echo 'export PATH=/opt/utilities/bin:$PATH' >> /root/.bashrc;

# Add /opt/utilities/bin to ubuntu's path
echo -e "\n→ ${bold}Adding /opt/utilities/bin to ubuntu's path${normal}\n";
echo 'export PATH=/opt/utilities/bin:$PATH' >> /home/ubuntu/.bashrc;

# Set the beagle's environment
echo -e "\n→ ${bold}Setting the beagle's environment to stable${normal}\n";
echo 'export NINJA_ENV=stable' >> /home/ubuntu/.bashrc;

# Add ninja_update to the hourly cron
#echo -e "\n→ ${bold}Add ninja_update to the hourly cron${normal}\n";
#ln -s /opt/utilities/bin/ninja_update /etc/cron.hourly/ninja_update;

# Run the setserial command so we can flash the Arduino later
echo -e "\n→ ${bold}Running setserial${normal}\n";
sudo /opt/utilities/bin/setserial;

# Run the setgpio command so we can flash the Arduino later
echo -e "\n→ ${bold}Running setgpio${normal}\n";
sudo /opt/utilities/bin/setgpio;

# Remove old Arduino hex files;
sudo rm /opt/utilities/tmp/*;

# Run Arduino Update
echo -e "\n→ ${bold}Updating the Arduino${normal}\n";
sudo /opt/utilities/bin/ninja_update_arduino;

echo -e "\n→ ${bold}Guess what? We're done!!!${normal}\n";

sudo reboot;
