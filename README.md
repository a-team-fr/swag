<center><img src="https://user-images.githubusercontent.com/9682519/78081857-cd5c3800-73b1-11ea-9ba8-ae27ec8e4b5c.png" alt="s🤘ag logo" ></center>  

# s🤘ag, a **free** presentation system based on QML   

## Purpose
The aim of this project is to provide a tool to easily create simple application with building blocks made in QML.  
As s🤘ag is basically loading and interpreting QML documents, there is no reason why s🤘ag would be limited to a presentation system : it could be possible to use it to create any kind of application.

There are already a number of similar projects, why create yet another one ?  
Well... :
1. because it is ***fun*** ! s🤘ag is the kind of project that covers lots of domain.
1. because it is **free** ! Most of the existing mature solution I know are based on a user locking in : either because of closed license or because of SaaS mode. That's the reason why s🤘ag is GPL, to ensure users will always be free to use, study, modify or redistribute it !
1. because **Low Tech** matters (at least to me) ! One more and more consume SaaS service for everything and whilst these demanding huge datacenter are producing lots of CO2. I am convinced that this model is not sustainable and that we should and we will move from SaaS. s🤘ag is thus an autonomous desktop solution, some very cool feature will be relying on network communication but they will remain optional and limited.

## Project history ##
For years, I was enthusiastic of speakers using their own presentation system.
As the community manager of the Nantes Qt Meetup, I had considered a number of times to use one the existing Qt based presentation projects (such as the excellent https://github.com/qt-labs/qml-presentation-system ).  
Quite recently during the 2020 FOSDEM last February, I have seen a stunning talk of Christophe de Dinechin made with a custom presentation system (TAO with XL langage), and this time it really convinced me that my next presentations should be made with such a system. My first need was very simple : design a training material that could show QML code and render it dynamically.  
Following the confinement call in March, as my business stalled whilst having to stay at home I had plenty of time to design a very simple version...  
Starting working on the project strengthen my initial feelings that such a tool is quite fun to design, very useful for creating rocking presentation and could be used for a lot more of use cases !

## why Swag as name ? ##
In french somethin "swag" is something cool, and i think s🤘ag is very cool !
I also liked the "Sophisticated Wild Ass Guess" as something that quickly do the job.
One can also think of fun abbreviation such as :

## How it works ?
![Welcome](https://user-images.githubusercontent.com/9682519/78081693-70f91880-73b1-11ea-8cb0-c1d27468816b.png)
From the welcome page, one can either create a new s🤘ag or open and existing one.  
A s🤘ag is currently handled as directory so you will need to select the parent folder of the s🤘ag content ( this might change in a near future).

![SlideThumbnails](https://user-images.githubusercontent.com/9682519/78081707-7bb3ad80-73b1-11ea-9567-9df20ddebe70.png)
When a s🤘ag is opened, it is possible to create a new slide or clone an existing one from the drawer menu.  

Enter in "Edit mode" (with Ctrl+D or from the edit menu) to show the toolbox (at the screen right side) with the list of Element you can integrate into your slide : a Text, an Image, a chart etc...

![EditMode](https://user-images.githubusercontent.com/9682519/78046008-f01d2b00-7376-11ea-91a0-92c439ecee53.png)

While "Edit mode" is active, hover an element to display its bounding box with editing functions (repositioning, changing properties or deleting the element).

At anytime, it is possible to trigger the "Show code" mode to inspect the current slide QML code, edit and reload the slide to see the changes without restarting s🤘ag.

![ShowCodeMode](https://user-images.githubusercontent.com/9682519/78081715-82422500-73b1-11ea-88c0-dde9cd81a098.png)

From the Deck settings, it is possible to choose the display mode between :
* Loader : only one slide is rendered at a time
* ListView : to swipe from one slide to another
* FlatView : to navigate from one element or slide to another in a similar manner than Prezi.

![DeckSettings](https://user-images.githubusercontent.com/9682519/78081724-85d5ac00-73b1-11ea-8980-35b23d2e5e72.png)

### Toolbox
* a Text element (currently only a limited set of a text properties are supported)
* a Code element : to show code with syntax highlighting (relying on highlight.js) together with a rendered object from QML code
* GotoButton : a button to change the current slide
* Webview
* Image
* Map
* Multiple Choice Question : each choice is made of an image and/or a text. When the MCQ is validated, each choice can be flipped to show an image and/or a text.
* Chart
* Dataviz
* Video or camera
* Entity 3D : show a 3D mesh
* PDF : a pdf reader based on pdf.js
One can find an example of using these elements with the "Gallery" s🤘ag.

## Installation
It is strongly advised to use the latest stable Qt version (Qt5.14.1 at the time of the project start).

1. git clone the project and get its submodules
```
git clone https://github.com/a-team-fr/QtWorkshop.git
git submodule update --init
```

2. Open the project with QtCreator

3. Build & run

## Roadmap
The project is driven using kanban.
Its comprehensive roadmap is visible [(here)]( https://kanboard.a-team.fr/?controller=BoardViewController&action=readonly&token=c735ac4810eaf0cb8b1d34b76d0f9d91bb142c640e4682f5271861dc4d7d)
The following is an overview of the roadmap and the current status.

### Version 0.0.1 (expected in April 2020)
**Target :** A draft with a limited feature set, incomplete and buggy.
Just good enough to show to experienced (and imaginative) developers what s🤘ag could become.

**Key features :**
* [x] basic navigation (create, open, close ) a slide deck and a slide
* [x] limited set of Elements
* [x] several display modes
* [x] publish to github
* [ ] landing page swagsoftware.net (Work in progress but I am getting lost with WordPress :-) )
* [ ] released with binaries for MacOs, Windows, GNU Linux (to be tested without Qt sdk installed) - would be nice to automate releases with GitHub actions if that is possible (help needed)

### Version 0.1
**Target :**  A workable solution but for a limited use : create presentation.

**Key features :**
* [ ] nice UI and great UX (help needed)
* [ ] PDF and HTML export (Work in progress)
* [ ] authentication, loading & saving to swagsoftware.net
* [ ] presenter mode with a dual screen

### Version 1.0
**Target :**
First official release containing "killer features" :-)

**Key features :**
  * [ ] mobile (iOS & Android) application that could connect to a running live presentation to support polling features
  * [ ] export to mpeg
  * [ ] sWaggies : sWag generator (for instance generate a sWag for project code documentation parsing Doxygen comments)
  * [ ] support opening of media/custom file by loading a templated s🤘ag (ex : use s🤘ag as a viewer)
