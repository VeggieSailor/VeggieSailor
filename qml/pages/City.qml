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

        model: ListModel {
            id: listModel
        }
        header: PageHeader {
            title: qsTr(page.mytext)
        }
        delegate: BackgroundItem {
            height: Theme.itemSizeMedium
            anchors {
                left: parent.left
                right: parent.right
            }
            // Stolen from:
            // https://github.com/mattaustin/fremantleline/blob/master/qml/silica/DepartureListPage.qml
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
                id:column
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
                Row {
                    width: column.width
                Label {
                    id: text1
                    text: veg_level_description
                    color: highlighted ? Theme.highlightColor : Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    width: parent.width - image1.width

                }


                Image
                {
                    id: image1
                    source: "image://theme/icon-cover-pause"
                    height: Theme.fontSizeSmall
                    width: Theme.fontSizeSmall
//                    x: page.width - width
//                    anchors.fill: parent
//                    anchors.

                }

                }
            }

            onClicked: pageStack.push(Qt.resolvedUrl("PlaceInfo.qml"),
                                      {
                                            "uri":uri,"name":typeof name != 'undefined' ? name : '',
                                            "address1":typeof address1 != 'undefined' ? address1 : '',
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
                                            "color_txt": typeof color_txt != 'color_txt' ? tags_txt : '',

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
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('.'));
            importModule('listmodel', function () {
                loadingData = true;
                py.call('listmodel.get_entries', [page.uri], function(result) {
                    for (var i=0; i<result.length; i++) {
                        listModel.append(result[i]);
                        console.log(JSON.stringify(result[i]));
//                        number = result[i]['weighted_rating'];
                        console.log(result[i]['rating_parsed']);
                    }
                    loadingData = false;
                });
            });
        }
    }

}
