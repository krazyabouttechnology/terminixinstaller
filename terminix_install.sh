#! /bin/bash
###################################################################################
# Installer and Updater script for Terminix 
# 
# Terminix is a great tiling GTK3 based terminal emulator created by Gerald Nunn
# It is available at : https://github.com/gnunn1/terminix.
#
# This script automates the process of downloading and 
# installing/upgrading Terminix from its GitHub repo.
#
# Created by: Sumit Bhardwaj
# Released under GPL v3.
####################################################################################


#URL for the Terminix GitHub repository. 
base_url="https://github.com/gnunn1/terminix"

echo
echo "Installer/Updater Script for Terminix from Github v1.0"
echo "----------------------------------------------------------"
echo
echo -n "Checking for installed release of Terminix, if any..."
terminix_path=`whereis terminix | cut -d ':' -f 2 | cut -d ' ' -f 2 | xargs`

if [ -e "$terminix_path" ] 
then
	current_version=`$terminix_path -v | xargs | tr -s "()',;" " " | cut -d ' ' -f 4`
	echo "Found v$current_version at $terminix_path."
else
	current_version="0.0.0"
	echo "none."
fi

echo

echo "Finding out the latest release available...."
latest_release=`curl "$base_url/releases/latest" -s -L -I -o /dev/null -w '%{url_effective}' | rev | cut -d / -f 1 | rev `

if [ "$current_version" == "$latest_release" ] 
then
	echo
	echo "You are already on the latest release : $latest_release."
	echo
	echo "Nothing to do. Exiting..."
	echo
    exit 0
fi

echo 
echo "Latest release is $latest_release. Downloading using curl in current directory..."

echo

url="$base_url/releases/download/$latest_release/terminix.zip"

curl -L $url -o ./terminix.zip

echo
echo "Download complete. Unzipping into system directories. Please enter your password if prompted, you need to be a sudoer..."
echo

sudo unzip terminix.zip -d /
echo
echo "Extraction Complete. Compiling GLib Schemas...."
echo 
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/
echo
echo "Installation Complete. Removing downloaded zip and exiting."
rm ./terminix.zip
echo




