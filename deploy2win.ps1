@rem deploy script for Windows
@rem description : copy swag.exe to deploy directory and launch windeployqt
@rem usage : .\deploy2win.bat
param ($qtpath='C:\Qt\5.14.2')


@echo ******set the proper env for windeploy to fetch the right vcredist
#call "C:\Program Files (x86)\Microsoft Visual Studio\VS2017CommunityEdition\VC\Auxiliary\Build\vcvars64.bat"
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" x64
@echo ******erase former deployement
rmdir -r -fo .\deploy\windows\bin\

@echo ******copy the newly build
copy .\build\swag.exe .\deploy\windows\bin\

@echo ******call windeploy
$qtpath\msvc2017_64\bin\windeployqt .\deploy\windows\bin\swag.exe -release -qmlimport=$qtpath\msvc2017_64\qml -qmldir=".\"

@echo ******copy swag needed stuff
robocopy .\deps .\deploy\windows\deps /MIR
robocopy .\src .\deploy\windows\src /MIR
robocopy .\examples .\deploy\windows\examples /MIR

@echo ******create new zip
Compress-Archive -path .\deploy\windows -destinationpath .\swag_windows_v0.0.1.zip -compressionlevel optimal
