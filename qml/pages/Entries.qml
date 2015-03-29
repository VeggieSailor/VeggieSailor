import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3
import "../VegLevel.js" as VegLevel
Page {
    id: page

    property string city
    property string mytext
    property string country
    property string uri
    property string color

    property bool loadingData
    property var entries : null


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
            MenuItem {
                id: minimumVegLevelMenu
                text: qsTr("Minimum Veggie-Level")

                onClicked:
                {
                    onClicked: pageStack.push(Qt.resolvedUrl("ChooseMinimumVegLevel.qml"))
                }
            }
        }
        model: ListModel {
            id: listModel
        }
        header: PageHeader {
            title: qsTr(page.mytext)
            description: minimumVegLevel == 0 ? "" : qsTr("At least %1").arg(VegLevel.VegLevel[minimumVegLevel])
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
        function loadData() {
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
                if(entries == null) {
                    py.call('pyveggiesailor.controller.get_entries', [page.uri], function(result) {
                        entries = result;
                        showEntries(result);
                    });
                } else {
                     showEntries(entries);
                }


            });
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
