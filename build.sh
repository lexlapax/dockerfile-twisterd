#!/bin/bash
# combining all build steps into a shell script for a single commit
# there's too many -dev libraries that are not needed and just makes the image bloated
#
# get required dependencies
apt-get update
apt-get upgrade -y
apt-get install build-essential libtool libssl-dev python-distutils-extra python-software-properties wget curl git -y
add-apt-repository -y ppa:bitcoin/bitcoin 
apt-get update 
apt-get install libboost-all-dev libdb4.8-dev libdb4.8++-dev libminiupnpc8=1.6-3ubuntu1 libminiupnpc-dev -y 

# get and build from source
mkdir -p /usr/local/src /root/.twister 
cd /usr/local/src 
git clone https://github.com/miguelfreitas/twister-core.git
git clone https://github.com/miguelfreitas/twister-html.git

cd /usr/local/src/twister-core 
./bootstrap.sh --enable-logging --enable-debug --enable-statistics 
make V=1 
make install-binPROGRAMS 

cd /root/.twister 
mv /usr/local/src/twister-html ./html 
cd /root
echo "rpcuser=user" >> /root/.twister/twister.conf 
echo "rpcpassword=pwd" >> /root/.twister/twister.conf
echo "rpcallowip=*.*.*.*" >> /root/.twister/twister.conf 

# clean up
rm -rf /usr/local/src/twister-core
apt-get purge libboost-all-dev libdb4.8-dev libdb4.8++-dev libminiupnpc-dev -y 
apt-get purge build-essential libtool libssl-dev python-distutils-extra -y 
dpkg -l '*-dev'|grep ^ii |awk '{print $2}'|xargs apt-get purge -y 
dpkg -l '*-perl'|grep ^ii |awk '{print $2}'|xargs apt-get purge -y 
apt-get purge -y libboost-wave1.46.1 libboost-test1.46.1 libboost-signals1.46.1 libboost-serialization1.46.1 libboost-regex1.46.1 libboost-python1.46.1 libboost-mpi1.46.1 libboost-math1.46.1 libboost-iostreams1.46.1 libboost-graph1.46.1  libboost-graph-parallel1.46.1  libboost-date-time1.46.1
apt-get purge -y python-software-properties openmpi-common libopenmpi1.3 
apt-get purge -y libx11-6 libx11-data libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxmuu1
apt-get purge -y libedit2 libpopt0 libtorque2 libgmp10 libmpfr4 libunistring0 libicu48 libgomp1 gettext-base xml-core libbsd0 
apt-get purge -y libquadmath0 cpp libgdbm3 libssl-doc sgml-base ucf python-gnupginterface libnuma1 libibverbs1 libmpc2 
apt-get purge -y fakeroot python-pycurl libpython2.7 git-man netbase manpages patch libc-dev-bin libltdl7
apt-get purge -y make m4 libsqlite3-0
apt-get purge -y libkrb5-3 libk5crypto3 libroken18-heimdal iso-codes libasn1-8-heimdal libgnutls26 libtasn1-3 libexpat1 libp11-kit0 libwind0-heimdal libkrb5support0 libgcrypt11 libkeyutils1
apt-get purge -y libheimbase1-heimdal mime-support krb5-locales libsasl2-2 openssl binutils libsasl2-modules ca-certificates libmagic1 libgpg-error0

apt-get -y clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#apt-get purge -y gcc gcc-4.6 gcc-4.6-base 
#apt-get purge -y libdrm-intel1 libdrm-nouveau1a libdrm-radeon1 libdrm2
# gcc gcc-4.6
#python-pycurl libpython2.7 