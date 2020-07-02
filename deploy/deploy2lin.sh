#!/bin/bash
#deploy script for Linux
#description : copy swag to deploy directory and launch lindeployqt
#usage : ./deploy/deploy2lin.sh  from swag root
#produce : ./Swag.AppImage (swag root dir)
PATH_TO_QT=$1
if [ -z "$PATH_TO_QT" ]
then
  echo "using default Qt Path"
  PATH_TO_QT=/home/charby/Qt/5.15.0/
fi

echo ******erase former deployement
rm -rf ./deploy/linux/

echo ******recreate appdir
mkdir -p ./deploy/linux/usr/bin
mkdir -p ./deploy/linux/usr/lib
mkdir -p ./deploy/linux/usr/share/applications
mkdir -p ./deploy/linux/usr/share/icons/hicolor/512x512
mkdir -p ./deploy/linux/usr/share/icons/hicolor/48x48

echo ******copy the newly build
cp ./build/swag ./deploy/linux/usr/bin/

echo ******copy desktop file
cp ./deploy/swag.desktop ./deploy/linux/usr/share/applications/

echo ******copy appicons
cp ./res/SwagLogo.iconset/Swag.iconset/icon_512x512.png ./deploy/linux/usr/share/icons/hicolor/512x512/swag_logo.png
cp ./res/SwagLogo.iconset/Swag.iconset/icon_48x48.png ./deploy/linux/usr/share/icons/hicolor/48x48/swag_logo.png

echo ******copy swag needed stuff
mkdir -p ./deploy/linux/usr/qml
cp -rf ./Swag ./deploy/linux/usr/qml/Swag
cp -rf ./deps ./deploy/linux/usr/deps
cp -rf ./src ./deploy/linux/usr/src
cp -rf ./examples ./deploy/linux/usr/examples
cp -rf ./translations ./deploy/linux/usr/translations

echo *** fetch libpulse-mainloop-glib.so.0
sudo apt-get install libpulse-dev
sudo apt-get install libxcb-icccm4
sudo apt-get install libxcb-image0-dev
sudo apt-get install libxcb-keysyms1
sudo apt-get install libxcb-randr0-dev libxcb-xtest0-dev libxcb-xinerama0-dev libxcb-shape0-dev libxcb-xkb-dev
sudo apt-get install libxkbcommon-dev
sudo apt-get install libxkbcommon-x11-dev
sudo apt-get install libgstreamer-plugins-base1.0-0

PATH="$PATH:"$PATH_TO_QT"gcc_64/bin";export PATH

VERSION=$(cat ./Version.def); export VERSION

echo ******call linuxdeploy
./linuxdeployqt-continuous-x86_64.AppImage ./deploy/linux/usr/share/applications/swag.desktop -qmake="$PATH_TO_QT"gcc_64/bin/qmake -appimage -qmldir=./ -extra-plugins=iconengines,platformthemes,geometryloaders,geoservices,sceneparsers,webview
mv ./Swag-$VERSION-x86_64.AppImage ./Swag.AppImage
