import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

Page {
    id: page


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

                        Label {
                            text: name
                            x: Theme.paddingLarge
                            color: bgdPlace.highlighted ? Theme.highlightColor : Theme.primaryColor
                        }
                        // onClicked: openPlace(index)

                    }
                }
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
                Python {
                    id: py
                    Component.onCompleted: {
                        addImportPath(Qt.resolvedUrl('.'));
                        importModule('listmodel', function(result) {
                            py.call('listmodel.fav_places', [],function(result) {
                                for (var i=0; i<result.length; i++) {
                                    placesModel.append(result[i]);
                                }
                            });
                        });
                    }
                }

            }
        VerticalScrollDecorator {}

    }
}

