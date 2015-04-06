import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

Page {
    id: page
    property Item contextMenuPlaces
    onStatusChanged: {


        if (page.status==PageStatus.Active)
        {
            placesModel.clear();
            citiesModel.clear();


            py.call('pyveggiesailor.controller.fav_places', [],function(result) {
                for (var i=0; i<result.length; i++) {
                    placesModel.append(result[i]);
                }
            });
            py.call('pyveggiesailor.controller.fav_cities', [],function(result) {
                for (var i=0; i<result.length; i++) {
                    citiesModel.append(result[i]);
                }
            });
        }

    }
    SilicaFlickable {
        width: page.width
        height: parent.width
        contentHeight: listView.height
        contentWidth: listView.width
        anchors.fill: parent


        Column {

            PageHeader {
                title: qsTr("Favourites")
            }
            id: listView
            width: page.width

            spacing: Theme.paddingLarge


            Label {
                text: qsTr("Places")
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeLarge
                width: parent.width
                x: Theme.paddingLarge

            }
            Repeater {
                id: repPlaces
                model: ListModel {
                    id: placesModel
                }
                delegate: EntryBackgroundItem {
                    id: bgdPlace
                    function openPlace(entryUri) {
                        py.call('pyveggiesailor.controller.get_entry', [entryUri],function(result) {
                            pageStack.push(Qt.resolvedUrl("PlaceInfo.qml"),
                                           {
                                               "uri":result['uri'],
                                               "name": result['name'] ,
                                               "address1": result['address1'],
                                               "address2": result['address2'],
                                               "city": result['city'],
                                               "country":result['country'],
                                               "veg_level_description": result['veg_level_description'],
                                               "price_range": result['price_range'],
                                               "long_description": result['long_description'],
                                               "short_description": result['short_description'],
                                               "hours_txt": result['hours_txt'],
                                               "cuisines_txt": result['cuisines_txt'],
                                               "tags_txt": result['tags_txt'],
                                               "phone": result['phone'],
                                               "color_txt": result['color_txt']
                                           });
                        });

                    }
                    onClicked: openPlace(uri)

                }
            }
            Label {
                text: qsTr("Cities")
                color: Theme.highlightColor
                width: parent.width
                font.pixelSize: Theme.fontSizeLarge
                x: Theme.paddingLarge
            }

            ListView {
                id: repCities
                //                quickScroll : false
                model: ListModel {
                    id: citiesModel
                }

                property Item contextMenuCities

                delegate: Item {
                    id: myListItemCities
                    property bool menuOpen: repCities.contextMenuCities != null && repCities.contextMenuCities.parent === myListItemCities
                    height: menuOpen ? repCities.contextMenuCities.height + bgdCity.height : bgdCity.height
                    width: Repeater.view.width

                    BackgroundItem {
                        id: bgdCity
                        height: Theme.itemSizeSmall
                        width: parent.width
                        function openCity(cityUri, cityName) {
                            pageStack.push(Qt.resolvedUrl("Entries.qml"),
                                           {
                                               "uri": cityUri,
                                               "mytext":name
                                           });
                        }

                        Label {
                            text: name
                            x: Theme.paddingLarge
                            color: bgdCity.highlighted ? Theme.highlightColor : Theme.primaryColor
                            //                            anchors {
                            //                                left: parent.left
                            //                                leftMargin: Theme.paddingLarge
                            //                                right: parent.right
                            //                                rightMargin: Theme.paddingSmall
                            ////                                verticalCenter: parent.verticalCenter
                            //                            }
                        }
                        onClicked: openCity(uri, name)

                        onPressAndHold: {
                            console.log("HOLD");
                            if (!contextMenuCities)
                                contextMenuCities = contextMenuComponentCities.createObject(repCities)
                            contextMenuCities.show(myListItemCities)
                        }
                    }
                }
                Component {
                    id: contextMenuComponentCities
                    ContextMenu {
                        MenuItem {
                            text: "Option 1"
                            onClicked: console.log("Clicked Option 1")
                        }
                        MenuItem {
                            text: "Option 2"
                            onClicked: console.log("Clicked Option 2")
                        }
                    }
                }
            }
            Python {
                id: py
                Component.onCompleted: {
                    addImportPath(Qt.resolvedUrl('../..'));
                    importModule('pyveggiesailor.controller', function () {
                    });
                }
            }
        }
        VerticalScrollDecorator {}
    }
}
