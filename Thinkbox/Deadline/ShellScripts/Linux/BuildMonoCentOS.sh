#!/bin/sh

# Pre-flight stuff
yum install automake libtool autoconf gcc-c++ bison gettext make # Mono deps
yum install glib2-devel libpng-devel libX11-devel #libgdiplus deps

curl -L http://ftp.novell.com/pub/mono/sources/mono/mono-2.10.2.tar.bz2 | tar jx
cd mono*

./autogen.sh --prefix=/opt/mono
make all
make install

cd ..

curl -L http://ftp.novell.com/pub/mono/sources/libgdiplus/libgdiplus-2.10.tar.bz2 | tar jx
cd libgdi*

./configure --prefix=/opt/mono
make all
make install

cd ..

# Post-flight goodies
echo 'PATH=/opt/mono/bin:$PATH' > /etc/profile.d/deadline-path
echo "/opt/mono/lib" > /etc/ld.so.conf.d/deadline-mono.conf
ldconfig

