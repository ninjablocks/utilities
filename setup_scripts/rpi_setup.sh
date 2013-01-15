#!/bin/bash

# Run this script as root ie:
# sudo wget -O - https://raw.github.com/ninjablocks/utilities/master/setup_scripts/rpi_setup.sh | sudo bash

set -e

bold=`tput bold`;
normal=`tput sgr0`;
username="pi"
space_left=`df | grep rootfs | awk '{print $3}'`


if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

if [[ $space_left -lt 100000 ]]
then
	echo "${bold} In order to install the ninjablock software, you must have at least 100 megs of free space. Try running raspi-config and using the \"expand_rootfs\" option to free up some space ${normal}"
	exit 1
fi


# Updating apt-get
echo -e "\n→ ${bold}Updating apt-get${normal}\n";
sudo apt-get update > /dev/null;

echo -e "\n→ ${bold}Installing ntpdate${normal}\n";
sudo apt-get -qq -y -f -m install ntpdate > /dev/null;
sudo /etc/init.d/ntp stop
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
sudo /etc/init.d/ntp start



# Download and install the Essential packages.
echo -e "\n→ ${bold}Installing git${normal}\n";
sudo apt-get -qq -y -f -m  install git > /dev/null; 

echo -e "\n→ ${bold}Installing node${normal}\n";
sudo apt-get -qq -y -f -m  install nodejs > /dev/null;  #potentially pull down binairies here?
sudo ln -s /usr/bin/nodejs /usr/bin/node 

echo -e "\n→ ${bold}Installing npm${normal}\n"; 
sudo apt-get -qq -y -f -m  install npm > /dev/null;

echo -e "\n→ ${bold}Installing ruby1.9.1-dev${normal}\n"; 
sudo apt-get -qq -y -f -m  install ruby1.9.1-dev > /dev/null;

echo -e "\n→ ${bold}Installing avrdude${normal}\n"; 
sudo apt-get -qq -y -f -m  install avrdude > /dev/null;

echo -e "\n→ ${bold}Installing psmisc${normal}\n"; 
sudo apt-get -qq -y -f -m  install psmisc > /dev/null;

echo -e "\n→ ${bold}Installing curl${normal}\n"; 
sudo apt-get -qq -y -f -m  install curl > /dev/null;


# Install Sinatra
echo -e "\n→ ${bold}Installing the sinatra gem${normal}\n"; 
sudo gem install sinatra  --verbose --no-rdoc --no-ri > /dev/null;

# Install getifaddrs
echo -e "\n→ ${bold}Installing the getifaddrs gem${normal}\n"; 
sudo gem install system-getifaddrs  --verbose --no-rdoc --no-ri > /dev/null;


# Create the Ninja Blocks utilities folder
echo -e "\n→ ${bold}Create the Ninja Blocks Utilities Folder${normal}\n"; 
sudo mkdir -p  /opt/utilities;   


# Clone the Ninja Utilities into /opt/utilities
echo -e "\n→ ${bold}Fetching the Utilities Repo from Github${normal}\n";
git clone https://github.com/ninjablocks/utilities.git /opt/utilities > /dev/null;
cd /opt/utilities;
git checkout master; #this will change once release is finished


echo -e "\n→ ${bold}Copying init scripts into place${normal}\n";
sudo sed -i 's/exit 0$/\/opt\/utilities\/bin\/ninjapi_get_serial\n\/opt\/utilities\/bin\/ninjapi_start\nexit 0/' /etc/rc.local


# Copy /etc/udev/rules.d/ scripts into place (for web cams)
echo -e "\n→ ${bold}Copy /etc/udev/rules.d/ scripts into place${normal}\n";
sudo cp /opt/utilities/udev/* /etc/udev/rules.d/;


# Create Ninja Directory (-p to preserve if already exists).
echo -e "\n→ ${bold}Create the Ninja Directory${normal}\n";
sudo mkdir -p /opt/ninja;


# Clone the Ninja Client into opt
echo -e "\n→ ${bold}Clone the Ninja Client into opt${normal}\n";
git clone https://github.com/ninjablocks/client.git /opt/ninja > /dev/null;
cd /opt/ninja;
git checkout master;
sudo sed -i 's/ttyO1/null/' beagle.js #changing serial port to /dev/null until we work out a way to use RPI's
sudo sed -i 's/beagle/pi/' beagle.js  #change client to "pi"


echo -e "${bold}Pulling down RPI binaries${normal}";
cd /tmp;
wget https://s3.amazonaws.com/ninjablocks/binaries/pi/rpi-binaries.tgz > /dev/null;
tar -C / -xzf rpi-binaries.tgz > /dev/null;
echo -e "${bold}Deploying RPI binaries${normal}";
rm rpi-binaries.tgz;
sudo ln -s /opt/ninja/node_modules/forever/bin/forever /usr/bin/forever


# Create directory /etc/opt/ninja
echo -e "\n→ ${bold}Adding /etc/opt/ninja${normal}\n";
sudo mkdir -p /etc/opt/ninja;

# Set user as the owner of this directory.
echo -e "\n→ ${bold}Set ${username} user as the owner of this directory${normal}\n";
sudo chown -R ${username} /opt/;


# Add /opt/utilities/bin to root's path
echo -e "\n→ ${bold}Adding /opt/utilities/bin to root's path${normal}\n";
echo 'export PATH=/opt/utilities/bin:$PATH' >> /root/.bashrc;

# Add /opt/utilities/bin to user's path
echo -e "\n→ ${bold}Adding /opt/utilities/bin to ${username}'s path${normal}\n";
echo 'export PATH=/opt/utilities/bin:$PATH' >> /home/${username}/.bashrc;

# Set the beagle's environment
echo -e "\n→ ${bold}Setting the pi's environment to stable${normal}\n";
echo 'export NINJA_ENV=stable' >> /home/${username}/.bashrc;

# Add ninja_update to the hourly cron
echo -e "\n→ ${bold}Add ninja_update to the hourly cron${normal}\n";
ln -s /opt/utilities/bin/ninja_update /etc/cron.hourly/ninja_update;

echo -e "\n→ ${bold}Getting serial number from system${normal}\n";
sudo /opt/utilities/bin/ninjapi_get_serial;



echo -e "\n→ ${bold}Guess what? We're done! ${normal}\n";

echo -e "Before you reboot, write down this serial-- this is what you will need to activate your new Pi!"

echo -e "--------------------------------------------------------------"
echo -e "|                                                            |"
echo -e "|           Your NinjaPi Serial is: `cat /etc/opt/ninja/serial.conf`         |"
echo -e "|                                                            |"
echo -e "--------------------------------------------------------------"

read -p " When you are ready, please hit the [Enter] key" nothing

if [[ ! -d /etc/update-motd.d ]]
then
	sudo mkdir /etc/update-motd.d
fi

sudo /opt/utilities/bin/ninja_update_system;
