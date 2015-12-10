#!/bin/bash

set -e
function error_handler() {
    echo "Error during build!"
    exit 666
}

trap error_handler EXIT

./setup_build_env.sh

# linking directly to source for now
#./build_giflib.sh

source common.sh
subm

if [ ! -e netpbm/lib/libnetpbm.a ]; then
    pushd netpbm
    make
    popd
fi

if [ ! -e jsoncpp/build/lib/libjsoncpp.a ]; then
    pushd jsoncpp
    # go back to an older version of cmake
    # git revert --no-edit ae5a56f9ff6932feb641bafe323195b6aa30bd21
    rm -rf build
    mkdir build
    pushd build
    cmake -DJSONCPP_LIB_BUILD_SHARED=OFF -DJSONCPP_WITH_TESTS=OFF -G "Unix Makefiles" ../
    make
    popd
    popd
fi

if [ ! -e qt_install ]; then
    mkdir -p qt_build
    pushd qt_build
    # ../qt/configure -v -continue -opensource -confirm-license -release -static -qt-xcb -no-sql-ibase -no-sql-mysql -no-sql-odbc -no-sql-psql -no-sql-sqlite -no-sql-sqlite2 -xrender -largefile -rpath -openssl -D ENABLE_VIDEO=0 -nomake examples --prefix=../../qt_install || die "cannot configure qt"
    ../qt/configure -v -continue -opensource -confirm-license -release -static -no-strip -qt-xcb -qt-zlib -qt-libpng -qt-libjpeg -no-sse2 -gui -widgets -no-accessibility -no-xinput2 -no-pulseaudio -no-qml-debug -opengl -no-sql-ibase -no-sql-mysql -no-sql-odbc -no-sql-psql -no-sql-sqlite -no-sql-sqlite2 -nomake examples -nomake tests -silent -xrender -largefile -rpath -openssl -no-dbus -no-nis -no-cups -no-iconv -no-pch -no-gtkstyle -no-sm -no-xshape -no-xinerama -no-xcursor -no-xfixes -no-xrandr -no-mitshm -no-xinput -no-xkb -no-glib -no-gstreamer -D ENABLE_VIDEO=0 -no-openvg -no-xsync -no-audio-backend -no-sse3 -no-ssse3 -no-sse4.1 -no-sse4.2 -no-avx -no-avx2 -no-mips_dsp -no-mips_dspr2 -skip qtandroidextras -skip qttranslations -skip qtdoc -skip qtwinextras -skip qtmacextras -skip qtwebkit-examples -skip qtpim --prefix=../../qt_install || die "cannot configure qt"
    if ! make -j8 -q; then
        make -j8 || die "cannot make qt"
    fi
    make install || die "cannot install qt"
    popd
    #rm -rf qt_build
fi

./qt_install/bin/qmake ichabod.pro
make

./test.sh

./archive_src.sh

./build_rpm.sh

# all done, reset everything
trap - EXIT
exit 0
