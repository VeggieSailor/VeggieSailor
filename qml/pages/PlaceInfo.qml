import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

Page {
    id: page
    property string uri
    property string uri_reviews
    property string name
    property string address1
    property string address2
    property string city
    property string country
    property string veg_level_description
    property string price_range
    property string long_description

    property string short_description
    property string phone
    property variant cousines
    property variant cuisines_txt
    property string hours_txt
    property string tags_txt
    property string color_txt
    property variant images
    property string address
    property int key_type: 1

    property int rating_parsed

    address: address1 + " " + address2 + " " + city + " " + country
    uri_reviews: uri + "/reviews"
    SilicaFlickable {
        width: page.width
        height: parent.width
        contentHeight: column.height
        contentWidth: column.width
        anchors.fill: parent
        PullDownMenu {
            MenuItem {
                id: favorite
                text: qsTr("Add to favorites")

                onClicked:
                {
                    onClicked: {
                        py.call('pyveggiesailor.controller.fav_place',
                                [page.uri, {'name':page.name, 'city':page.city,
                                     'color_txt':page.color_txt, "rating_parsed":page.rating_parsed,
                                     'uri':page.uri,'veg_level_description':page.veg_level_description}],
                                function(result) {
                                    if (result==1)
                                    {
                                        favorite.text = "Remove from favorites";
                                    } else

                                    {
                                        favorite.text = "Add to favorites";
                                    }
                                });
                    }
                }
            }
        }
        Python {
            id: py
            Component.onCompleted: {
                addImportPath(Qt.resolvedUrl('.'));
                addImportPath(Qt.resolvedUrl('..'));
                addImportPath(Qt.resolvedUrl('../..'));

                importModule('pyveggiesailor.controller', function () {


                    py.call('pyveggiesailor.controller.fav_place_check', [page.uri],function(result) {
                        if (result==1)
                        {
                            favorite.text = "Remove from favorites";
                        } else
                        {
                            favorite.text = "Add to favorites";
                        }
                    });

                    py.call('pyveggiesailor.controller.get_entry_image', [page.uri], function(res){
                        thumb.source = res;
                    });

                })


            }
        }


        Column {
            id: column
            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                id: pageHeader
                title: qsTr(name)
            }


            Image {
                id:thumb
                x: Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter

            }


            DetailItem {
                label: qsTr('Veg Level')
                value: qsTr(page.veg_level_description)
            }



            Item {
                id:header
                height: Theme.itemSizeMedium
                width: parent.width
                Rectangle {
                    anchors.fill: parent
                    color: Theme.highlightColor
                    opacity : mouseAreaHeader.pressed ? 0.3 : 0.1
                }
                Image {
                    id: icon
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    source: "image://theme/icon-m-right"
                }
                Label {
                    //                    font.pixelSize: Theme.fontSizeLarge
                    color: Theme.primaryColor
                    text: qsTr('Map')
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: icon.left
                    anchors.rightMargin: Theme.paddingMedium
                }

                MouseArea {
                    id: mouseAreaHeader
                    anchors.fill: parent
                    onClicked:
                    {
                        address.entry_id =  page.uri.split('/')[(page.uri.split('/')).length-1];
                        address.map_url = "https://veggiesailor.com/transformer/entry/"+address.entry_id+"/map";
                        pageStack.push(Qt.resolvedUrl("EntryMap.qml"), {"map_url":address.map_url, "name":page.name,
                                           "address":page.address, "phone":page.phone});
                    }
                }
            }


            DetailItem {

                id: address
                property int entry_id
                property string map_url
                label: qsTr('Address')
                value: qsTr(page.address)
                MouseArea {
                    anchors.fill: parent
                    onClicked:
                    {
                        address.entry_id =  page.uri.split('/')[(page.uri.split('/')).length-1];
                        address.map_url = "https://veggiesailor.com/transformer/entry/"+address.entry_id+"/map";
                        pageStack.push(Qt.resolvedUrl("EntryMap.qml"), {"map_url":address.map_url, "name":page.name,
                                           "address":page.address, "phone":page.phone});
                    }

                }
            }

            DetailItem {
                label: qsTr('Phone')
                value: qsTr(page.phone)
            }

            Item {
                id:headerInformations
                height: Theme.itemSizeMedium
                width: parent.width
                Rectangle {
                    anchors.fill: parent
                    color: Theme.highlightColor
                    opacity : 0.1
                }
                Image {
                    id: iconInformations
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    source: "image://theme/icon-lock-information"
                }
                Label {
                    color: Theme.primaryColor
                    text: qsTr('Information')
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: iconInformations.left
                    anchors.rightMargin: Theme.paddingMedium
                }
            }

            DetailItem {
                label: qsTr('Description')
                value: qsTr(page.short_description)
            }

            DetailItem {
                label: qsTr('Price Range')
                value: qsTr(page.price_range)
            }

            DetailItem {
                label: qsTr('Hours')
                value: qsTr(page.hours_txt)
            }

            DetailItem {
                label: qsTr('Cuisines')
                value: qsTr(page.cuisines_txt)
            }

            DetailItem {
                label: qsTr('Tags')
                value: qsTr(page.tags_txt)
            }

            Item {
                id:headerReviews
                height: Theme.itemSizeMedium
                width: parent.width
                Rectangle {
                    anchors.fill: parent
                    color: Theme.highlightColor
                    opacity : mouseAreaHeaderReviews.pressed ? 0.3 : 0.1
                }

                Image {
                    id: iconReviews
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.paddingLarge
                    source: "image://theme/icon-m-right"
                }

                Label {
                    //                    font.pixelSize: Theme.fontSizeLarge
                    color: Theme.primaryColor
                    text: qsTr('Reviews')
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: iconReviews.left
                    anchors.rightMargin: Theme.paddingMedium
                }

                MouseArea {
                    id: mouseAreaHeaderReviews
                    anchors.fill: parent
                    onClicked:
                    {
                        pageStack.push(Qt.resolvedUrl("Reviews.qml"), {"uri":page.uri_reviews, "name":page.name});
                    }
                }
            }
        }

    }
}

