import QtQuick 2.0
import Sailfish.Silica 1.0
BackgroundItem {
    height: Theme.itemSizeMedium
    anchors {
        left: parent.left
        right: parent.right
    }
    // Stolen from:
    // https://github.com/mattaustin/fremantleline/blob/master/qml/silica/DepartureListPage.qml

    Rectangle {
        width: Theme.paddingSmall
        radius: Math.round(height/3)
        color: color_txt
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            topMargin: Theme.paddingSmall/2
            bottomMargin: Theme.paddingSmall/2
            leftMargin: - width/2
        }
    }
    Column {
        id:column
        anchors {
            left: parent.left
            leftMargin: Theme.paddingLarge
            right: parent.right
            rightMargin: Theme.paddingSmall
            verticalCenter: parent.verticalCenter
        }
        Label {
            text: name
            color: highlighted ? Theme.highlightColor : Theme.primaryColor

        }
        Row {
            width: column.width
            Label {
                id: text1
                text: veg_level_description
                color: highlighted ? Theme.highlightColor : Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall
                width: parent.width - (Theme.fontSizeSmall * rating_parsed)
            }
            Repeater {
                id: repeater

                model: rating_parsed

                Image
                {
                    id:image
                    source: "image://theme/icon-m-favorite-selected"
                    height: Theme.fontSizeSmall
                    width: Theme.fontSizeSmall
                }
            }
        }
    }


}
