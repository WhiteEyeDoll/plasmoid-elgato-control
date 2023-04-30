import QtQuick 2.0
import QtQuick.Controls 2.5
import org.kde.kirigami 2.4 as Kirigami

Kirigami.FormLayout {
    id: page

    property alias cfg_deviceList: deviceList.text

    TextField {
        id: deviceList
        placeholderText: "Device ip addresses separated by comma"
    }
}
