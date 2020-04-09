#!/bin/bash
#deploy script for Linux
#description : copy swag to deploy directory and launch windeploylin
#usage : .\deploy2win.bat

PATH_TO_QT=$1
if [ -z "$PATH_TO_QT" ]
then
  echo "using default Qt Path"
  PATH_TO_QT=/home/charby/Qt5.14.2/5.14.2/
fi

echo ******erase former deployement
rm -rf ./linux/

echo ******recreate appdir
mkdir -p ./linux/usr/bin
mkdir -p ./linux/usr/lib
mkdir -p ./linux/usr/share/applications
mkdir -p ./linux/usr/share/icons/hicolor/512x512

echo ******copy the newly build
cp ../build/swag ./linux/usr/bin/

echo ******copy desktop file
cp ../swag.desktop ./linux/usr/share/applications/

echo ******copy appicon
cp ../res/SwagLogo.iconset/Swag.iconset/icon_512x512.png ./linux/usr/share/icons/hicolor/512x512/

echo ******copy swag needed stuff

cp -rf ../deps ./linux/usr/deps
cp -rf ../src ./linux/usr/src 
cp -rf ../examples ./linux/usr/examples

exit

echo ******call linuxdeploy
~/Applications/linuxdeployqt-continuous-x86_64.AppImage usr/share/applications/swag.desktop -qmake="$PATH_TO_QT"/gcc_64/bin/qmake -appimage -qmldir=../


