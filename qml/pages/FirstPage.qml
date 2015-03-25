import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

Page {
    id: page
    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Clear cache")
                onClicked: {
                    py.call('pyveggiesailor.veggiesailor.purge_all_cache',  [], function(result) {});
                }            }
            MenuItem {
                text: qsTr("Credits")
                onClicked: pageStack.push(Qt.resolvedUrl("Credits.qml"))
            }
            MenuItem {
                text: qsTr("Sail")
                onClicked: pageStack.push(Qt.resolvedUrl("Browse.qml"))
            }
            MenuItem {
                text: qsTr("Favorites")
                onClicked: pageStack.push(Qt.resolvedUrl("Fav.qml"))
            }
        }
        Python {
            id: py
            Component.onCompleted: {
                addImportPath(Qt.resolvedUrl('../..'));
                importModule('pyveggiesailor.veggiesailor', function() {});
            }
        }
        contentHeight: column.height

        Column {
            id: column
            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Veggie Sailor")
            }


            Repeater {
                id: repeater
                width: page.width
                model: ListModel {
                    ListElement {
                        mytext: "Barcelona"
                        image: "qrc:///static/images/barcelona.jpg"
                        country: "Spain"
                        city: "barcelona"
                        uri: "http://www.vegguide.org/region/583"
                    }
                    ListElement {
                        mytext: "London"
                        image: "qrc:///static/images/london.jpg"
                        country: "United Kingdom"
                        city: "london"
                        uri: "http://www.vegguide.org/region/54"
                    }
                    ListElement {
                        mytext: "Berlin"
                        image: "qrc:///static/images/berlin.jpg"
                        country: "Germany"
                        city: "berlin"
                        uri: "http://www.vegguide.org/region/60"
                    }
                }
                delegate: customblock
            }
            Component {
                id: customblock
                Column {
                    height: 220
                    width: page.width
                    Label {
                        text: qsTr(mytext)
                        color: Theme.primaryColor
                        x: Theme.paddingLarge
                        MouseArea {
                            anchors.fill: parent
                            onClicked: pageStack.push(Qt.resolvedUrl("Entries.qml"), {"city":city,"country":country, "mytext":mytext,"uri":uri  })
                        }
                    }
                    Image {

                        width: column.width
                        height: 200
                        fillMode: Image.PreserveAspectCrop
                        source: image
                        MouseArea {
                            anchors.fill: parent
                            onClicked: pageStack.push(Qt.resolvedUrl("Entries.qml"), {"city":city,"country":country, "mytext":mytext,"uri":uri  })
                        }
                    }
                }
            }

            Label {
                text: qsTr("Powered by VegGuide.org")
                color: Theme.secondaryHighlightColor
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}


