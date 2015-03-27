BackgroundItem {
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
                    width: parent.width - (Theme.fontSizeSmall * rating_parsed)

                }
                Repeater {
                    id: repeater

                    model: rating_parsed

                    Image
                    {
                        id:image
                        source: "image://theme/icon-m-favorite-selected"
                        height: Theme.fontSizeSmall
                        width: Theme.fontSizeSmall

                    }
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
