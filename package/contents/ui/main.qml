import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import QtQml.Models 2.15

ColumnLayout {
    id: app

    Layout.minimumWidth: PlasmaCore.Units.gridUnit * 14

    ObjectModel {
        id: deviceListModel
        property string deviceList: plasmoid.configuration.deviceList
        onDeviceListChanged: {
            deviceListModel.clear();
            var component = Qt.createComponent("ElgatoKeyLightControl.qml");
            var deviceArray = plasmoid.configuration.deviceList.split(",");
            deviceArray.forEach(device => {
                    if (component.status == Component.Ready) {
                        console.log("Adding device: " + device);
                        deviceListModel.append(component.createObject(deviceListModel, {
                                    "ip_address": `${device}`
                                }));
                    }
                });
        }
    }

    ListView {
        id: deviceList
        Layout.fillWidth: true
        implicitHeight: contentHeight
        model: deviceListModel
    }
}
