import QtQuick 2.15
import QtQuick.Layouts 1.14
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

        PlasmaComponents.Label {
            id: productName
            text: settings.productName
        }

        RowLayout {

            PlasmaComponents.Switch {
                id: onSwitch
                text: settings.ip_address
                checked: settings.on
                onCheckedChanged: settings.setLights({on: checked})
            }

            PlasmaComponents.Button {
                id: identifyButton
                text: "Identify"
                onClicked: settings.identify()
            }
        }

        RowLayout {

            PlasmaComponents.Slider {
                id: temperatureSlider
                Layout.fillWidth: true
                value: settings.temperature
                from: 2900
                to: 7000
                stepSize: 50
                onMoved: settings.setLights({temperature: value})
            }

            PlasmaComponents.Label {
                id: temperatureValue
                text: temperatureSlider.value + "K"
            }

        }

        RowLayout {

            PlasmaComponents.Slider {
                id: brightnessSlider
                Layout.fillWidth: true
                value: settings.brightness
                from: 0
                to: 100
                stepSize: 1
                onMoved: settings.setLights({brightness: value})
            }

            PlasmaComponents.Label {
                id: brightnessValue
                text: brightnessSlider.value + "%"
            }

        }

}
