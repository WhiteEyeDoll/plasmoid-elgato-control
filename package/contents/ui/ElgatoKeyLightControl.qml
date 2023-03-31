import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

ColumnLayout {

    id: controls

    property string ip_address

        ElgatoKeyLightSettings {
            id: settings
            ip_address: controls.ip_address
        }

        PlasmaComponents.Switch {
            id: onSwitch
            text: settings.ip_address
            checked: settings.on === 1 ? 1 : 0
            onClicked: {
                settings.setLight("on", checked ? 1 : 0)
            }
        }

        PlasmaComponents.Slider {
            id: brightnessSlider
            Layout.fillWidth: true
            value: settings.brightness
            from: 0
            to: 100
            stepSize: 1
            onMoved: {
                settings.setLight("brightness", value)
            }
        }


        PlasmaComponents.Slider {
            id: temperatureSlider
            Layout.fillWidth: true
            value: settings.temperature
            from: 143
            to: 344
            stepSize: 1
            onMoved: {
                settings.setLight("temperature", value)
            }
        }
}
