import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

Page {
    id: page




    onStatusChanged: {


        if (page.status==PageStatus.Active)
        {
            placesModel.clear();

    py.call('listmodel.fav_places', [],function(result) {
        for (var i=0; i<result.length; i++) {
            placesModel.append(result[i]);
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
                    delegate: BackgroundItem {
                        id: bgdPlace
                        height: Theme.itemSizeSmall
                        function openPlace(entryUri) {


                            py.call('listmodel.get_vegguide_entry', [entryUri],function(result) {


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
                                  "tags_txt": result['tags_txt']

                              });
//                                for (var i=0; i<result.length; i++) {
//                                    placesModel.append(result[i]);
//                                }
                            });

                        }
                        Rectangle {
                            width: Theme.paddingSmall
                            radius: Math.round(height/3)
                            color: color_txt
                            anchors {
                                top: parent.top
                                bottom: parent.bottom
                                left: parent.left
                                topMargin: Theme.paddingSmall/2
                                bottomMargin: Theme.paddingSmall/2
                                leftMargin: -width/2
                            }
                        }
                        Column {
                            anchors {
                                left: parent.left
                                leftMargin: Theme.paddingLarge
                                right: parent.right
                                rightMargin: Theme.paddingSmall
                                verticalCenter: parent.verticalCenter
                            }
                            Label {
                                text: name
                                color: highlighted ? Theme.highlightColor : Theme.primaryColor
                            }
                            Label {
                                text: veg_level_description
                                color: highlighted ? Theme.highlightColor : Theme.secondaryColor
                                font.pixelSize: Theme.fontSizeSmall
                            }
                        }

                        onClicked: openPlace(uri)

                    }
                }
                /* // Commented since model does not work yet
                Label {
                    text: qsTr("Cities")
                    color: Theme.highlightColor
                    width: parent.width
                    font.pixelSize: Theme.fontSizeLarge
                    x: Theme.paddingLarge
                }

                Repeater {
                    id: repCities
                    model: ListModel {

                    }
                    delegate: BackgroundItem {
                        id: bgdCity
                        height: Theme.itemSizeSmall

                        Label {
                            text: fruit
                            x: Theme.paddingLarge
                            color: bgdCity.highlighted ? Theme.highlightColor : Theme.primaryColor
                            anchors {
                                left: parent.left
                                leftMargin: Theme.paddingLarge
                                right: parent.right
                                rightMargin: Theme.paddingSmall
                                verticalCenter: parent.verticalCenter
                            }
                        }
                        onClicked: openCity(index)

                    }
                }
                */
                Python {
                    id: py
                    Component.onCompleted: {
                        addImportPath(Qt.resolvedUrl('.'));
                        importModule('listmodel', function(result) {
                            placesModel.clear();

//                            py.call('listmodel.fav_places', [],function(result) {
//                                for (var i=0; i<result.length; i++) {
//                                    placesModel.append(result[i]);
//                                }
//                            });
                        });
                    }


                }

            }
        VerticalScrollDecorator {}

    }
}

