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
    call_uri: uri ? uri : "http://www.vegguide.org"
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


        delegate: delegate

        Component {
            id: regionComponent
            BackgroundItem {
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
                    text: myName
                    color: highlighted ? Theme.highlightColor : Theme.primaryColor

                }
                onClicked: pageStack.push(Qt.resolvedUrl("Browse.qml"),
                                          {
                                              "name":myName,
                                              "mytext": myName,
                                              "entries_uri": myEntries_uri,
                                              "uri": myUri
                                          })
            }
        }
        Component {
            id: entryComponent
            BackgroundItem {
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
                    text: myName
                    color: highlighted ? Theme.highlightColor : Theme.primaryColor
                }
                onClicked: pageStack.push(Qt.resolvedUrl("City.qml"),{"uri": myUri, "mytext":myName})
            }

        }

        Component {
            id: delegate


            Loader {
                anchors {
                    left: parent.left
                    right: parent.right
                }
                property string myUri: uri
                property string myName: name
                property string myText: mytext
                property string myEntries_uri: entries_uri
                sourceComponent: has_entries == 0 ? regionComponent : entryComponent
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
            if (page.uri) {
                importModule('listmodel', function () {
                    loadingData = true;
                    py.call('listmodel.get_vegguide_children', [page.call_uri], function(result) {
                        loadingData = false;
                        for (var i=0; i<result.length; i++) {
                            listModel.append(result[i]);
                        }
                    });
                });
            } else {
                importModule('listmodel', function () {
                    loadingData = true;
                    py.call('listmodel.get_vegguide_regions', ['primary',page.call_uri], function(result) {
                        loadingData = false;
                        for (var i=0; i<result.length; i++) {
                            listModel.append(result[i]);

                        }
                    });
                });
            }
        }
    }

}
