import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page
    Column {
        id: column
        width: page.width
        spacing: Theme.paddingLarge
        PageHeader {
            title: qsTr("Credits")
        }

        Text {
            text: qsTr("Veggie Sailor")
            color: Theme.primaryColor

            font.pixelSize: Theme.fontSizeExtraLarge

            anchors.horizontalCenter: parent.horizontalCenter
        }


        Repeater {
            id: repeater
            width: page.width

        model: ListModel {
            ListElement { mytext: "Author, Coding"; myvalue: "Rafał bluszcz Zawadzki"; mysize: "Theme.fontSizeExtraLarge" }
            ListElement { mytext: "Fixes, Ideas, Coding"; myvalue: "Florian Wittmann"; mysize: "Theme.fontSizeExtraLarge" }
            ListElement { mytext: "Copenhagen photo"; myvalue: "Nelson L. https://creativecommons.org/licenses/by/2.0/"; mysize: "Theme.fontSizeExtraLarge" }
            ListElement { mytext: "API Provide"; myvalue: "VegGuide http://www.vegguide.org"; mysize: "Theme.fontSizeExtraLarge" }
        }
        delegate: BackgroundItem {
            id: delegate
            DetailItem {
                label: qsTr(mytext)
                value: qsTr(myvalue)
            }
        }
    }

        Text {
            text: qsTr("If you like the app - please support us, we need developers, translators, content editors and more :)")
            width: parent.width - (Theme.paddingLarge*2)
            wrapMode: Text.WordWrap
            color: Theme.primaryColor
            x: Theme.paddingLarge

        }

}
}

