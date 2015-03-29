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
TARGET = harbour-veggiesailor

CONFIG += sailfishapp

SOURCES += src/VegSailor.cpp

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    rpm/VegSailor.spec \
    translations/*.ts \
    qml/cover/VegSailor.png \
    qml/pages/images/barcelona.jpg \
    qml/pages/Credits.qml \
    qml/pages/PlaceInfo.qml \
    qml/pages/Browse.qml \
    qml/pages/Fav.qml \
    rpm/harbour-veggiesailor.spec \
    rpm/harbour-veggiesailor.changes.in \
    harbour-veggiesailor.png \
    harbour-veggiesailor.desktop \
    qml/harbour-veggiesailor.qml \
    qml/pages/Entries.qml \
    pyveggiesailor/__init__.py \
    rpm/harbour-veggiesailor.legacy \
    rpm/harbour-veggiesailor.yaml \
    pyveggiesailor/vegguide_cache.py \
    qml/pages/EntryMap.qml \
    qml/pages/EntryBackgroundItem.qml \
    qml/pages/ChooseMinimumVegLevel.qml \
    qml/VegLevel.js


# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-veggiesailor-de.ts
TRANSLATIONS += translations/harbour-veggiesailor-fr.ts
TRANSLATIONS += translations/harbour-veggiesailor-es.ts



RESOURCES += \
    images.qrc

pyveggiesailor.path = /usr/share/$${TARGET}
pyveggiesailor.files = pyveggiesailor
INSTALLS += pyveggiesailor
