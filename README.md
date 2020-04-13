# s🤘ag  [![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) ![build linux AppImage](https://github.com/a-team-fr/swag/workflows/build%20linux%20AppImage/badge.svg) ![Build windows zip](https://github.com/a-team-fr/swag/workflows/Build%20windows%20zip/badge.svg) ![Build macOS dmg](https://github.com/a-team-fr/swag/workflows/Build%20macOS%20dmg/badge.svg) [![last release](https://img.shields.io/github/v/release/a-team-fr/swag)](https://github.com/a-team-fr/swag/releases/latest)

A **free** presentation system based on QML  
Swag is an effort to create a presentation system in QML.  
  * [Purpose and history](https://github.com/a-team-fr/swag/wiki) 
  * [Quick start](https://github.com/a-team-fr/swag/wiki/Quick-start) 
  * [Doxygen](https://a-team-fr.github.io/swag/html) 
![SlideThumbnails](https://user-images.githubusercontent.com/9682519/78081707-7bb3ad80-73b1-11ea-9567-9df20ddebe70.png)    

## Installing from standalone binary packages [![last release](https://img.shields.io/github/v/release/a-team-fr/swag)](https://github.com/a-team-fr/swag/releases/latest)

The following platforms are supported:
* Windows <details><summary>(installation details)</summary>
  * From the [release page](https://github.com/a-team-fr/swag/releases/latest), download the [Inno setup](https://jrsoftware.org/isinfo.php) installer
  * Proceed with the setup 
</details>

* GNU Linux <details><summary>(installation details)</summary>
  * From the [release page](https://github.com/a-team-fr/swag/releases/latest), download the AppImage container.
  * Set the executable flag : 'chmod u+x swag*.AppImage'
  * Launch
</details>

* macOS <details><summary>(installation details)</summary>
  * From the [release page](https://github.com/a-team-fr/swag/releases/latest), download the DMG container.
  * Open the container and move the Swap.app into your applications folder
  * Authorize execution of swag from the security panel of the sytem settings
</details>

## Compiling Swag  

<details><summary>prerequisite</summary>
 * Qt Sdk installed (>Qt5.14.2) with QtWebView module. Depending of Swag content, optional modules such as QtCharts, QtDataViz, QtWebView might be required.
 * build tools
   * MacOs : install XCode
   * Windows : install MSVisualStudio or MinGW
   * Linux : apt-get install build-essentials
</details>

1. git clone the project and get its submodules
```
git clone https://github.com/a-team-fr/swag.git
cd swag
git submodule update --init
```

2. Open the project file (swag.pro) with QtCreator

3. Build & run [& enjoy]

## Contributing
* Join the [Swag Mattermost](https://framateam.org/swagsoftware/) to get in touch with the community
* Improve the [wiki](https://github.com/a-team-fr/swag/wiki) or [Doxygen](https://a-team-fr.github.io/swag/html) 
* Test swag, [report bugs](https://github.com/a-team-fr/swag/issues/new/choose), suggest new feature or suggestion
* pick a ticket and fire a PR
* give feedback
* ...

## Project big picture
* **v0.0.1** : good enough to play with to create simple documents and program your own QML stuff. Swag will likely show a poor UI, a number of bugs and a limited feature set. Also the document format is likely to change. Yet, this version should help understanding the project potential. This milestone should be reached somewhere in April 2020.
* **v0.1.0** : good enough to create presentation. First official version using a somewhat standardized document format. Swag contains all classic presentation features together with advanced features. Swag might be used to experiment others application (dynamic report, book, training support...). This milestone should be reached somewhere around April 2021.
* **v1.0.0** : good enough to create any kind of application. Swag is a mature solution to handle a number of uses cases, backed with a generous toolbox it can be used to generate easily anykind of application. This milestone might be reached somewhere around April 2030.

Feel free to review and contribute to the [project roadmap](https://github.com/a-team-fr/swag/wiki/Roadmap).
