    QT += quick multimedia location positioning texttospeech sensors bluetooth quickcontrols2 printsupport webview charts datavisualization websockets
QT += 3dcore 3drender 3dinput 3dlogic 3dquick 3danimation
CONFIG += c++17

include(deps/vendor.pri)


# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        deps/miniz-2.1.0/miniz.c \
        src/networking.cpp \
        src/main.cpp \
        src/pdfexporter.cpp \
        src/prezmanager.cpp \
        src/restinpeace.cpp \
        src/wordprest.cpp

HEADERS += \
    deps/miniz-2.1.0/miniz.h \
    src/networking.h \
    src/pdfexporter.h \
    src/prezmanager.h \
    src/qclearablecacheqmlengine.hpp \
    src/qttshelper.hpp \
    src/restinpeace.h \
    src/wordprest.h \
    src/ziputils.hpp

RESOURCES += qml.qrc

TARGET.CAPABILITY += SwEvent


#enforce to build target
DESTDIR = $$PWD/build

#$$QMAKE_COPY
#macx {
#    QMAKE_POST_LINK += macdeployqt $${DESTDIR}/$${TARGET}.app &
#} else: win32 {
#    QMAKE_POST_LINK += windeployqt $${DESTDIR}/$${TARGET}.exe &
#}

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += $$PWD

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$$TARGET/bin
!isEmpty(target.path): INSTALLS += target

OTHER_FILES +=  $$files(examples/*.*, true) \
                $$files(Swag/*.*, true) \
                $$files(src/qml/*.*, true)


VERSION = "$$cat($$PWD/Version.def)"
message("building version $$VERSION")

DEFINES += \
    VERSION=\\\"$${VERSION}\\\" \

SRCDIR =
CONFIG(debug, debug|release) {
    SRCDIR = $$PWD
} else {
}
DEFINES += SRCDIR=\\\"$${SRCDIR}\\\" \

macx{
    ICON = swag.icns

    BUNDLED_FILES.files += $$PWD/deps \
                            $$PWD/examples \
                            $$PWD/src
    BUNDLED_FILES.path = Contents/MacOs
    QMAKE_BUNDLE_DATA += BUNDLED_FILES

    QMAKE_INFO_PLIST = deploy/info.plist
    #Q_PRODUCT_BUNDLE_IDENTIFIER.name = PRODUCT_BUNDLE_IDENTIFIER
    #Q_PRODUCT_BUNDLE_IDENTIFIER.value = fr.a-team.swag
    #QMAKE_MAC_XCODE_SETTINGS += Q_PRODUCT_BUNDLE_IDENTIFIER
    QMAKE_TARGET_BUNDLE_PREFIX = fr.a-team.
    QMAKE_BUNDLE = swag
    QMAKE_FRAMEWORK_BUNDLE_NAME = swag
    QMAKE_FRAMEWORK_VERSION = $$VERSION
}
else:win32{
    QMAKE_TARGET_COMPANY = A-Team (https://a-team.fr)
    QMAKE_TARGET_PRODUCT = Swag software
    QMAKE_TARGET_DESCRIPTION = A free (GPLv3) presentation system
    QMAKE_TARGET_COPYRIGHT = Copyright(C) 2020 A-Team GPLv3

    RC_ICONS = res/swag.ico
}

lupdate_only{
    SOURCES = *.qml \
              *.cpp \
              *.js \
              src/qml/*.qml \
              Swag/*.qml
}

TRANSLATIONS = translations/swag_fr_FR.ts


DISTFILES += \
    Swag/ColorPicker.qml \
    Swag/FormItem.qml \
    Swag/TextFieldDelegate.qml \
    src/qml/CloseButton.qml \
    src/qml/FileTransfertView.qml \
    src/qml/IconPicker.qml \
    src/qml/LeftMenu.qml \
    src/qml/Navigator.qml \
    src/qml/Networking.qml \
    src/qml/WPConnect.qml \
    src/qml/WPProfile.qml


