import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

Page {
    id: page

    property string city
    property string mytext
    property string country
    property string uri
    property string color

    property bool loadingData


    SilicaListView {
        anchors.fill: parent
        PullDownMenu {
            MenuItem {
                id: favorite
                text: qsTr("Add to favorites")

                onClicked:
                {
                    onClicked: {
                        py.call('pyveggiesailor.controller.fav_city', [page.uri, {'name':page.mytext, 'uri':page.uri}],function(result) {
                            if (result==1)
                            {
                                favorite.text = qsTr("Remove from favorites");
                            } else

                            {
                                favorite.text = qsTr("Add to favorites");
                            }
                        });
                    }
                }
            }
        }
        model: ListModel {
            id: listModel
        }
        header: PageHeader {
            title: qsTr(page.mytext)
        }

        delegate: EntryBackgroundItem {

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
            addImportPath(Qt.resolvedUrl('../..'));
            importModule('pyveggiesailor.controller', function () {
                loadingData = true;
                py.call('pyveggiesailor.controller.fav_city_check', [page.uri],function(result) {
                    if (result==1)
                    {
                        favorite.text = "Remove from favorites";
                    } else
                    {
                        favorite.text = "Add to favorites";
                    }
                });
                py.call('pyveggiesailor.controller.get_entries', [page.uri], function(result) {
                    for (var i=0; i<result.length; i++) {
                        listModel.append(result[i]);
                    }

                    loadingData = false;
                });
            });
        }
    }

}
