# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = VegSailor

CONFIG += sailfishapp

SOURCES += src/VegSailor.cpp

OTHER_FILES += qml/VegSailor.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    rpm/VegSailor.spec \
    rpm/VegSailor.yaml \
    translations/*.ts \
    VegSailor.desktop \
    qml/pages/listmodel.py \
    VegSailor.png \
    qml/cover/VegSailor.png \
    qml/pages/images/barcelona.jpg \
    qml/pages/Credits.qml \
    qml/pages/PlaceInfo.qml \
    qml/pages/vegguide.py \
    qml/pages/City.qml \
    qml/pages/Browse.qml \
    qml/pages/veggiesailor.py \
    qml/pages/veganguide.py \
    qml/pages/veggiesailor.py \
    qml/pages/veganguide.py \
    rpm/VegSailor.changes.in

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/VegSailor-de.ts

RESOURCES += \
    images.qrc

