import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    property int entry_id
    property string map_url
    property string name
    property string address
    property string phone


    Column {
        id: column
        width: page.width
        height: page.height
        spacing: Theme.paddingLarge
        anchors.fill: parent

        PageHeader {
            id: header
            title: page.name
        }
    SilicaWebView {
        id: webView
        x: Theme.paddingLarge
        width: parent.width - (Theme.paddingLarge*2)
        height: parent.height - (Theme.paddingLarge*4) -header.height - label1.height - label2.height
        url: page.map_url
    }

    DetailItem {
        id: label1
        label: qsTr('Address')
        value: qsTr(page.address)
    }

    DetailItem {
        id: label2
        label: qsTr('Phone')
        value: qsTr(page.phone)
    }

    }

}

