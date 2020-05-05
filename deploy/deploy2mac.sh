#!/bin/bash
# deploy script for MacOs
# description : copy swag.app to deploy directory and launch macdeployqt
# usage : .deploy/deploy2mac.sh from swag root
#produce : ./Swag.dmg (swag root dir)

PATH_TO_QT=$1
if [ -z "$PATH_TO_QT" ]
then
  echo "using default Qt Path"
  PATH_TO_QT=~/QtGPL/5.14.2/
fi

rm -Rf ./deploy/macos/swag.app
rm -Rf ./swag.dmg

mkdir -p ./deploy/macos

cp -Rf ./build/swag.app ./deploy/macos/swag.app
cp -Rf ./deploy/qt.conf ./deploy/macos/swag.app/Contents/MacOs/qt.conf
mkdir -p ./deploy/macos/swag.app/Contents/Resources/qml/Swag
cp -Rf ./Swag ./deploy/macos/swag.app/Contents/Resources/qml
#manual copy of missing qml import (don't know why macdeployqt is not doing it)
#cp -Rf "$PATH_TO_QT"clang_64/qml/ ./macos/swag.app/Contents/Resources/qml

"$PATH_TO_QT"clang_64/bin/macdeployqt ./deploy/macos/swag.app -qmlimport="$PATH_TO_QT"clang_64/qml -qmldir="./" -dmg -verbose=2
VERSION=$(cat ./Version.def); export VERSION
mv ./deploy/macos/swag.dmg ./swag.dmg
#remove last generated swag.app to force full rebuild
#rm -Rf ../build/swag.app
