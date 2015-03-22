import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

Page {
    id: page

    property string city
    property string mytext
    property string country
    property string uri
    property string entries_uri
    property var children
    property string call_uri
    call_uri: uri ? uri : "https://www.vegguide.org"
    property string header
    property bool loadingData

    header: mytext ? mytext : "Sail"

    SilicaListView {
        anchors.fill: parent

        model: ListModel {
            id: listModel
        }
        header: PageHeader {
            id: page_header
            title: qsTr(page.header)
        }

        delegate: BackgroundItem {
            height: Theme.itemSizeSmall
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
                text: name
                color: highlighted ? Theme.highlightColor : Theme.primaryColor

            }
            onClicked: {
//                console.log(JSON.stringify(entries_uri));
                if(isRegion()) {
                    pageStack.push(Qt.resolvedUrl("Browse.qml"),
                                    {
                                        "name":name,
                                        "mytext": name,
                                        "entries_uri": entries_uri,
                                        "uri": uri
                                    });
                } else {
                    pageStack.push(Qt.resolvedUrl("Entries.qml"),
                                    {
                                        "uri": uri,
                                        "mytext":name
                                    });
                }
            }

            function isRegion() {
                console.log("BLA BLA has_entries", has_entries);
                 return has_entries == 0
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
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('.'));
            addImportPath(Qt.resolvedUrl('..'));
            addImportPath(Qt.resolvedUrl('../..'));
            loadingData = true;
            //TODO: rewrite everything to pyveggiesailor.controller
            importModule('pyveggiesailor.controller', function () {
                if (!page.uri) {
                py.call('pyveggiesailor.controller.get_root', [], fillListModel);
                }
                })
            importModule('listmodel', function () {
                if (page.uri) {
                    // Get the children
                    py.call('listmodel.get_vegguide_children', [page.call_uri], fillListModel);
                }
            });
        }

        function fillListModel(data) {
            for (var i=0; i<data.length; i++) {
                listModel.append(data[i]);
            }
            loadingData = false;
        }
    }
}
