import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    property string name
    property string address1
    property string address2
    property string city
    property string country
    property string veg_level_description
    property string price_range
    property string long_description

    property string short_description

    property variant cousines


    property variant images


    property string address

    address: address1 + " " + address2 + " " + city + " " + country

        Column {
            id: column
            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr(name)
            }

            DetailItem {
                label: qsTr('Veg Level')
                value: qsTr(page.veg_level_description)
            }

            DetailItem {
                label: qsTr('Address')
                value: qsTr(page.address)
            }

            DetailItem {
                label: qsTr('Description')
                value: qsTr(page.short_description)
            }

            DetailItem {
                label: qsTr('Price Range')
                value: qsTr(page.price_range)
            }

          }
}
