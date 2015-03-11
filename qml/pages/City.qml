import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

Page {
    id: page

        property string city
        property string mytext
        property string country
        property string uri
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


                onClicked: pageStack.push(Qt.resolvedUrl("PlaceInfo.qml"),
                                          {
                                              "uri":uri,
                                              "name":typeof name != 'undefined' ? name : '',
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
                        }
                        loadingData = false;
                    });
                });
            }
        }

}
