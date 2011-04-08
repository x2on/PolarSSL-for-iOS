#!/bin/bash

#  Automatic build script for polarssl
#  for iPhoneOS and iPhoneSimulator
#
#  Created by Felix Schulze on 08.04.11.
#  Copyright 2010 Felix Schulze. All rights reserved.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
###########################################################################
#  Change values here
#
VERSION="0.14.3"
SDKVERSION="4.3"
#
###########################################################################
#
# Don't change anything here
CURRENTPATH=`pwd`
ARCHS="i386 armv6 armv7"


##########
set -e
if [ ! -e polarssl-${VERSION}-gpl.tgz ]; then
	echo "Downloading polarssl-${VERSION}-gpl.tgz"
    curl -O http://polarssl.org/code/releases/polarssl-${VERSION}-gpl.tgz
else
	echo "Using polarssl-${VERSION}-gpl.tgz"
fi

mkdir -p bin
mkdir -p lib
mkdir -p src

for ARCH in ${ARCHS}
do
	if [ "${ARCH}" == "i386" ];
	then
		PLATFORM="iPhoneSimulator"
	else
		PLATFORM="iPhoneOS"
	fi

	tar zxvf polarssl-${VERSION}-gpl.tgz -C src
	cd src/polarssl-${VERSION}/library
	
	echo "Building polarssl for ${PLATFORM} ${SDKVERSION} ${ARCH}"

	echo "Patching Makefile..."
	sed -i.bak '4d' ${CURRENTPATH}/src/polarssl-${VERSION}/library/Makefile
	
	echo "Please stand by..."

	export DEVROOT="/Developer/Platforms/${PLATFORM}.platform/Developer"
	export SDKROOT="${DEVROOT}/SDKs/${PLATFORM}${SDKVERSION}.sdk"
	export CC=${DEVROOT}/usr/bin/gcc
	export LD=${DEVROOT}/usr/bin/ld
	export CPP=${DEVROOT}/usr/bin/cpp
	export CXX=${DEVROOT}/usr/bin/g++
	export AR=${DEVROOT}/usr/bin/ar
	export AS=${DEVROOT}/usr/bin/as
	export NM=${DEVROOT}/usr/bin/nm
	export CXXCPP=$DEVROOT/usr/bin/cpp
	export RANLIB=$DEVROOT/usr/bin/ranlib
	export LDFLAGS="-arch ${ARCH} -pipe -no-cpp-precomp -isysroot ${SDKROOT}"
	export CFLAGS="-arch ${ARCH} -pipe -no-cpp-precomp -isysroot ${SDKROOT} -I${CURRENTPATH}/src/polarssl-${VERSION}/include"

	make

	cp libpolarssl.a ${CURRENTPATH}/bin/libpolarssl-${ARCH}.a
	cp -R ${CURRENTPATH}/src/polarssl-${VERSION}/include ${CURRENTPATH}
	cp ${CURRENTPATH}/src/polarssl-${VERSION}/LICENSE ${CURRENTPATH}/include/polarssl/LICENSE
	cd ${CURRENTPATH}
	rm -rf src/polarssl-${VERSION}
	
done
lipo "bin/libpolarssl-i386.a" "bin/libpolarssl-armv6.a" "bin/libpolarssl-armv7.a" -create -output "lib/libpolarssl.a"

echo "Build library..."



echo "Building done."