import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

Page {
    id: page

        property string city
        property string mytext
        property string country
        property string uri

        SilicaListView {
            anchors.fill: parent

            model: ListModel {
                id: listModel
            }
            header: PageHeader {
                title: qsTr(page.mytext)
            }
            delegate: Label {
                x: Theme.paddingLarge
                text: name
                color: Theme.primaryColor
                MouseArea {
                    anchors.fill: parent
                    onClicked: pageStack.push(Qt.resolvedUrl("PlaceInfo.qml"),
                                              {
                                                  "name":name,
                                                  "address1":address1,
                                                  "address2":address2,
                                                  "city":city,
                                                  "country":country,
                                                  "veg_level_description":veg_level_description,
                                                  "price_range":price_range,
                                                  "long_description":long_description,
                                                  "short_description":short_description,
                                              })
                }
            }
        }
        Python {
            id: py
            Component.onCompleted: {
                addImportPath(Qt.resolvedUrl('.'));
                importModule('listmodel', function () {
                    py.call('listmodel.get_entries', [page.uri], function(result) {
                        for (var i=0; i<result.length; i++) {
                            listModel.append(result[i]);
                        }
                    });
                });
            }
        }

}
