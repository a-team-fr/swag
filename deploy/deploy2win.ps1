#deploy script for Windows
#description : copy swag.exe to deploy directory and launch windeployqt
#usage : powershell.exe -noprofile -executionpolicy bypass -file ".\deploy\deploy2win.ps1" (from swag root)
#produce : ./Swag.AppImage (swag root dir)

param ($qtpath='C:\Qt\5.14.2')


echo "******set the proper env for windeploy to fetch the right vcredist"
#Start-Process "C:\Program Files (x86)\Microsoft Visual Studio\VS2017CommunityEdition\VC\Auxiliary\Build\vcvars64.bat"
Start-Process "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" x64

echo "******erase former deployement"
Remove-Item ".\deploy\windows\bin\" -Recurse -ErrorAction Ignore
Remove-Item ".\deploy\Output\" -Recurse -ErrorAction Ignore

echo "******copy the newly build"
New-Item -ItemType File -Path ".\deploy\windows\bin\swag.exe" -Force
copy-item ".\build\swag.exe" ".\deploy\windows\bin\swag.exe" -Force

echo "******call windeploy"
& "${qtpath}\msvc2017_64\bin\windeployqt" ".\deploy\windows\bin\swag.exe" -release -qmlimport="$qtpath\msvc2017_64\qml" -qmldir=".\"

echo "******copy swag needed stuff"
copy-item .\Swag .\deploy\windows\bin\Swag -Recurse -Force
copy-item .\deps .\deploy\windows\deps -Recurse -Force
copy-item .\src .\deploy\windows\src -Recurse -Force
copy-item .\examples .\deploy\windows\examples -Recurse -Force

#echo "******create new zip"
#Compress-Archive -path .\deploy\windows -destinationpath .\swag.zip -compressionlevel optimal -Force

#echo "******copy vcredist to deploy"
#
#(New-Object System.Net.WebClient).DownloadFile($url, ".\deploy\vcredist_x64.exe")
#copy-item "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Redist\MSVC\14.16.27012\vcredist_x64.exe" ".\deploy\vcredist_x64.exe" -Force
#copy-item "C:\Program Files (x86)\Microsoft Visual Studio\VS2017CommunityEdition\VC\Redist\MSVC\14.16.27012\vcredist_x64.exe" ".\deploy\vcredist_x64.exe" -Force

echo "******create innosetup installer"
$version = [IO.File]::ReadAllText("./Version.def")
$issFile = ".\deploy\innoSetup.iss"
(get-content $issFile).Replace('%%%VERSION%%%',$version) | Set-Content $issFile

& "C:\Program Files (x86)\Inno Setup 6\iscc.exe" ".\deploy\innoSetup.iss"
New-Item -ItemType File -Path ".\swag-setup.exe" -Force
copy-item ".\deploy\Output\setup.exe" ".\swag-setup.exe" -Force