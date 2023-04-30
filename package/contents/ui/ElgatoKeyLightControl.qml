import QtQuick 2.15
import QtQuick.Layouts 1.14
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import "utils.js" as Utils


ColumnLayout {
    id: settings

    Layout.fillWidth: true

    required property string ip_address
    readonly property string baseUrl: `http://${settings.ip_address}:9123`

    property int on
    property int brightness
    property int temperature

    property string displayName

    Timer {
        id: refresh
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            getAccessoryInfo();
            getLights();
        }
    }

    function getLights() {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                console.log('HEADERS_RECEIVED');
            } else if (xhr.readyState === XMLHttpRequest.DONE) {
                var jsonResponse = JSON.parse(xhr.responseText);
                var lights = jsonResponse.lights[0];

                settings.on = lights.on;
                settings.brightness = lights.brightness;
                settings.temperature = Utils.kelvinValueFromApi(lights.temperature);
            }
        }

        xhr.open("GET", `${settings.baseUrl}/elgato/lights`);
        xhr.send();
    }

    property var setLightsLimit: new Date()

    function setLights({on, brightness, temperature} = {}) {

        var now = new Date();

        if (now - setLightsLimit >= 50) {

            if (temperature !== undefined) {
                temperature = Utils.apiValueFromKelvin(temperature);
            }

            var xhr = new XMLHttpRequest();

            setLightsLimit = now;

            // Undefined values are not included by JSON.stringify()
            var json = {
                "numberOfLights": 1,
                "lights": [{
                    "on": on,
                    "brightness": brightness,
                    "temperature": temperature
                }]
            }

            xhr.onreadystatechange = function () {
                if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                    console.log('HEADERS_RECEIVED');
                } else if (xhr.readyState === XMLHttpRequest.DONE) {
                    var jsonResponse = JSON.parse(xhr.responseText);
                }
         }

            xhr.open("PUT", `${settings.baseUrl}/elgato/lights`);
            xhr.send(JSON.stringify(json));
        }
    }

    function identify() {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                console.log('HEADERS_RECEIVED');
            } else if (xhr.readyState === XMLHttpRequest.DONE) {
                console.log('DONE')
            }
        }

        xhr.open("POST", `${settings.baseUrl}/elgato/identify`);
        xhr.send();
    }

    function getAccessoryInfo() {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                console.log('HEADERS_RECEIVED');
            } else if (xhr.readyState === XMLHttpRequest.DONE) {
                var jsonResponse = JSON.parse(xhr.responseText);

                settings.displayName = jsonResponse.displayName;
            }
        }

        xhr.open("GET", `${settings.baseUrl}/elgato/accessory-info`);
        xhr.send();
    }

    function setAccessoryInfo({displayName} = {}) {

        var xhr = new XMLHttpRequest();

        var json = {
                "displayName": displayName
            }

        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                console.log('HEADERS_RECEIVED');
            } else if (xhr.readyState === XMLHttpRequest.DONE) {
                var jsonResponse = JSON.parse(xhr.responseText);
            }
        }

        xhr.open("PUT", `${settings.baseUrl}/elgato/accessory-info`);
        xhr.send(JSON.stringify(json));
    }

    PlasmaComponents.Label {
        id: productName
        text: settings.displayName
    }

    RowLayout {

        PlasmaComponents.Switch {
            id: onSwitch
            text: settings.ip_address
            checked: settings.on
            onCheckedChanged: settings.setLights({
                    "on": checked
                })
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
            onMoved: settings.setLights({
                    "temperature": value
                })
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
            onMoved: settings.setLights({
                    "brightness": value
                })
        }

        PlasmaComponents.Label {
            id: brightnessValue
            text: brightnessSlider.value + "%"
        }
    }

    Component.onCompleted: {
        getAccessoryInfo();
        getLights();
    }
}
