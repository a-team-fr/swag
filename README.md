# s🤘ag  ![build linux AppImage](https://github.com/a-team-fr/swag/workflows/build%20linux%20AppImage/badge.svg) ![Build windows zip](https://github.com/a-team-fr/swag/workflows/Build%20windows%20zip/badge.svg) ![Build macOS dmg](https://github.com/a-team-fr/swag/workflows/Build%20macOS%20dmg/badge.svg)
A **free** presentation system based on QML  
Swag is an effort to create a presentation system in QML.  
  * [Purpose and history](https://github.com/a-team-fr/swag/wiki) 
  * [Quick start](https://github.com/a-team-fr/swag/wiki/Quick-start) 
  * [Doxygen](https://a-team-fr.github.io/swag/html) 
![SlideThumbnails](https://user-images.githubusercontent.com/9682519/78081707-7bb3ad80-73b1-11ea-9567-9df20ddebe70.png)    
## Supported Platforms

The standalone binary packages support the following platforms:

* Windows
* GNU Linux (ubuntu 16.04 or later) (64-bit)
* macOS 

## Compiling Swag  

Pre-requisite :
 * Qt Sdk installed (>Qt5.14.2) with QtWebView module. Depending of Swag content, optional modules such as QtCharts, QtDataViz, QtWebView might be required.
 * build tools
   * MacOs : install XCode
   * Windows : install MSVisualStudio or MinGW
   * Linux : apt-get install build-essentials

1. git clone the project and get its submodules
```
git clone https://github.com/a-team-fr/swag.git
cd swag
git submodule update --init
```

1. Open the project with QtCreator

1. Build & run [& enjoy]

## Contributing
* Join the [Swag Mattermost](https://framateam.org/swagsoftware/) to get in touch with the community
* Improve the [wiki](https://github.com/a-team-fr/swag/wiki) or [Doxygen](https://a-team-fr.github.io/swag/html) 
* Test swag and [report bugs](https://github.com/a-team-fr/swag/issues/new/choose) and suggest new feature or suggestion
