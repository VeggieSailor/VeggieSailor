import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    property int entry_id
    property string map_url
    property string name


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
        height: parent.height - (Theme.paddingLarge*2) -(header.height*2)
        url: page.map_url
    }
    }

}

