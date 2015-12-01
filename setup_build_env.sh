
#!/bin/bash

if cat /etc/issue | grep "Amazon Linux AMI" > /dev/null; then
    yum install -y cmake netpbm-devel python-multiprocessing gcc44-c++ libX11-devel libXext-devel libXrender-devel freetype-devel fontconfig-devel xorg-x11-xfs xorg-x11-xfs-utils rpm-build libtool.i386 automake autoconf m4 flex bison gperf libicu-devel libxslt-devel ruby

    if [ ! -e /usr/bin/g++ ]; then
        ln -s /usr/bin/g++44 /usr/bin/g++
    fi
fi

