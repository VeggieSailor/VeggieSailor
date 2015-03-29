import QtQuick 2.0
import Sailfish.Silica 1.0
import "../VegLevel.js" as VegLevel

Page {
SilicaListView {
    anchors.fill: parent

    model: ListModel {
        id: listModel
        ListElement {
            level: 0
        }
        ListElement {
            level: 1
        }
        ListElement {
            level: 2
        }
        // Does not include minimum level 3 - Vegetarian (But Not Vegan-Friendly)
        // to keep it simple. All level 3 entries are also included when choosing 2.
        ListElement {
            level: 4
        }
        ListElement {
            level: 5
        }
    }
    header: PageHeader {
        title: qsTr("Minimum Veggie-Level")
    }

    delegate: BackgroundItem {
        height: Theme.itemSizeMedium
        anchors {
            left: parent.left
            right: parent.right
        }

        Label {
            anchors {
                left: parent.left
                leftMargin: Theme.paddingLarge
                right: parent.right
                rightMargin: Theme.paddingSmall
                verticalCenter: parent.verticalCenter
            }
            text: VegLevel.VegLevel[level]
            color: highlighted ? Theme.highlightColor : Theme.primaryColor

        }



        onClicked: {
            minimumVegLevel = level
            pageStack.pop()
        }

    }
}
}
