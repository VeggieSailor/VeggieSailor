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
            onClicked: pageStack.push(Qt.resolvedUrl("PlaceInfo.qml"),
            {
                "uri":uri,"name":typeof name != 'undefined' ? name : '',
                "address1":typeof address1 != 'undefined' ? address1 : '',
                "phone":phone,"phone":typeof phone != 'undefined' ? phone : '',
                "address2":typeof address2 != 'undefined' ? address2 : '',
                "city":typeof city != 'undefined' ? city : '',
                "country":typeof country != 'undefined' ? country : '',
                "veg_level_description":typeof veg_level_description != 'undefined' ? veg_level_description : '',
                "price_range":typeof price_range != 'undefined' ? price_range : '',
                "long_description":typeof long_description != 'undefined' ? long_description : '',
                "short_description":typeof short_description != 'undefined' ? short_description : '',
                "hours_txt": typeof hours_txt != 'undefined' ? hours_txt : '',
                "cuisines_txt": typeof cuisines_txt != 'undefined' ? cuisines_txt : '',
                "tags_txt": typeof tags_txt != 'undefined' ? tags_txt : '',
                "color_txt": typeof color_txt != 'undefined' ? color_txt : '',
                "rating_parsed":typeof rating_parsed != 'undefined' ? rating_parsed : '',

                 })
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
