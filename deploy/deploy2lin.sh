@rem deploy script for Windows
@rem description : copy swag.exe to deploy directory and launch windeployqt
@rem usage : .\deploy2win.bat


@echo ******set the proper env for windeploy to fetch the right vcredist
call "C:\Program Files (x86)\Microsoft Visual Studio\VS2017CommunityEdition\VC\Auxiliary\Build\vcvars64.bat"

@echo ******erase former deployement
rmdir -r -fo .\windows\bin\

@echo ******copy the newly build
copy ..\build\swag.exe .\windows\bin\

@echo ******call windeploy
C:\Qt\5.14.2\msvc2017_64\bin\windeployqt .\windows\bin\swag.exe -release -qmlimport=C:\Qt\5.14.2\msvc2017_64\qml -qmldir="..\"

@echo ******copy swag needed stuff
robocopy ..\deps .\windows\deps /MIR
robocopy ..\src .\windows\src /MIR
robocopy ..\examples .\windows\examples /MIR

@echo ******create new zip
Compress-Archive -path .\windows -destinationpath .\swag_windows_v0.0.1.zip -compressionlevel optimal