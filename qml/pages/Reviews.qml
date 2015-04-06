import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3
import "../VegLevel.js" as VegLevel
Page {
    id: page

    property string city
    property string name
    property string country
    property string uri
    property string color

    property bool loadingData
    property var entries : null


    SilicaListView {
        anchors.fill: parent

        model: ListModel {
            id: listModel
        }
        header: PageHeader {
            title: qsTr(page.name)
        }

        delegate: ListItem {
//            height: Theme.itemSizeMedium
            contentHeight: label.height+row_rating.height+review.height

            anchors {
                left: parent.left
                right: parent.right
            }

            Image {
                id: image
                x: Theme.paddingLarge
                width: Theme.paddingLarge * 3
                source: user_image
                height: Theme.paddingLarge * 3
            }
                Label {
                    id: label
                    text: user['name']
                    color: Theme.primaryColor
                    anchors {
                        left: image.right
                    }

                }
                Row {
                    id: row_rating
                    width: column.width

                    anchors {
                        left: image.right
                        top: label.bottom
                    }
                    Repeater {
                        id: repeater_rating
                        model: rating
                        Image
                        {
                            source: "image://theme/icon-m-favorite-selected"
                            height: Theme.fontSizeSmall
                            width: Theme.fontSizeSmall
                        }
                    }
                    Repeater {
                        id: repeater_rating_empty

                        model: rating_empty

                        Image
                        {
                            source: "image://theme/icon-m-favorite"
                            height: Theme.fontSizeSmall
                            width: Theme.fontSizeSmall
                        }
                    }
                }

                Text {
                    id: review
                    anchors {
                        left: image.right
                        top: row_rating.bottom
                    }
                    text: body['text/html']
                    color: Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.WordWrap
                    width: parent.width - Theme.paddingLarge * 4
                }
        }
    }
    BusyIndicator {
        anchors.centerIn: parent
        size: BusyIndicatorSize.Large
        running: loadingData
        visible: loadingData
    }
    Python {
        id: py

        function loadData() {
            addImportPath(Qt.resolvedUrl('../..'));

            loadingData = true;
            importModule('pyveggiesailor.controller', function () {
                py.call('pyveggiesailor.controller.get_reviews', [page.uri], fillListModel);
            })
        }
        function fillListModel(data) {
            //            console.log(JSON.stringify(data));
            for (var i=0; i<data.length; i++) {
                listModel.append(data[i]);
            }
            loadingData = false;
        }
    }

    function showEntries(entries) {
        loadingData = false;
        listModel.clear();
        for (var i=0; i<entries.length; i++) {
            if(entries[i].veg_level >= minimumVegLevel) {
                listModel.append(entries[i]);
            }
        }
    }
    onStatusChanged: {
        if (status === PageStatus.Active) {
            py.loadData();
        }
    }

}
