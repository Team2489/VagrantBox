#!/usr/bin/env bash

# Switch user so stuff actually installs for the user.
oldHome=$HOME
su vagrant
export HOME="/home/vagrant"

# Add additional apt-get repositories
sudo apt-add-repository -y ppa:wpilib/toolchain
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get -yq update

# Install xfce and virtualbox additions
sudo apt-get update
sudo apt-get install -y xfce4 virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
# Permit anyone to start the GUI
sudo sed -i 's/allowed_users=.*$/allowed_users=anybody/' /etc/X11/Xwrapper.config
        
# Setup vimrc
wget -qO- https://raw.githubusercontent.com/amix/vimrc/master/vimrcs/basic.vim > ~/.vimrc
sudo chmod 664 ~/.vimrc
sudo chown vagrant ~/.vimrc

# Install Java 8, for Bazel
sudo apt-get -yq install openjdk-8-jdk

# Install Other Bazel Dependencies
sudo apt-get -yq install pkg-config zip g++ zlib1g-dev unzip

sudo chmod 775 -R ~/bin # Need to fix permissions so we can write swift to this later
sudo chown -R vagrant ~/bin

# Install FRC C++ Linux Toolchains
sudo apt-get -yq install frc-toolchain

# Install Swift Dependencies
sudo apt-get -yq install clang libicu-dev

# Install Swift
swiftURL="https://swift.org/builds/swift-3.0.1-release/ubuntu1404/swift-3.0.1-RELEASE/swift-3.0.1-RELEASE-ubuntu14.04.tar.gz"
swiftFile=$(basename $swiftURL)
swiftDir="${swiftFile/.tar.gz/}"
wget -nv $swiftURL
tar xzf $swiftFile --directory ~/bin
rm -f $swiftFile
echo 'export PATH=$PATH:$HOME/bin/'$swiftDir'/usr/bin' >> ~/.bashrc

# Reset permission again recursively: otherwise Foundation header files will not be readable to swift
sudo chmod 775 -R ~/bin # Need to fix permissions so we can write swift to this later
sudo chown -R vagrant ~/bin

# Setup python to use python2.7
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1

# Install Numpy, Scipy, matplotlib
sudo apt-get -yq install python-numpy python-scipy python-matplotlib

# Install pip, for slycot package
sudo apt-get -yq install python-pip

# Install slycot dependencies
sudo apt-get -yq install gfortran
sudo apt-get -yq install liblapack-dev

# Install slycot
sudo pip install slycot -q

# Install misc.
sudo apt-get -yq install htop

# Install eclipse.
sudo apt-get remove eclipse eclipse-platform
sudo apt-get -yq install openjdk-7-jdk
sudo apt-get -yq install oracle-java8-installer
sudo apt-get -yq install maven
sudo apt-get -yq install libc6-i386
eclipseURL="http://ftp.osuosl.org/pub/eclipse/technology/epp/downloads/release/mars/2/eclipse-cpp-mars-2-linux-gtk-x86_64.tar.gz"
eclipseFile=$(basename $eclipseURL)
wget -nv $eclipseURL
cd /opt
tar xzvf ~/$eclipseFile
cd ~

# Update CA Certificates
sudo update-ca-certificates -f

# Switch back to root. Probably doesn't matter, but it is symmetric.
sudo su
export HOME=$oldHome
