
#!/bin/bash

if cat /etc/issue | grep "Amazon Linux AMI" > /dev/null; then

    # install deps
    yum install perl-version

    yum groupinstall "Developer Tools"

    yum install libxcb libxcb-devel xcb-util xcb-util-devel
    yum install flex bison gperf libicu-devel libxslt-devel ruby
    yum install "qt5-*"
    yum install libgcrypt-devel libgcrypt pciutils-devel nss-devel libXtst-devel gperf cups-devel pulseaudio-libs-devel libgudev1-devel systemd-devel libcap-devel alsa-lib-devel flex bison ruby gcc-c++ dbus libXrandr-devel libXcomposite-devel libXcursor-devel dbus-devel fontconfig-devel

    yum install -y cmake netpbm-devel python-multiprocessing gcc44-c++ libX11-devel libXext-devel libXrender-devel freetype-devel fontconfig-devel xorg-x11-xfs xorg-x11-xfs-utils rpm-build libtool.i386 automake autoconf m4

    if [ ! -e /usr/bin/g++ ]; then
        ln -s /usr/bin/g++44 /usr/bin/g++
    fi
fi

