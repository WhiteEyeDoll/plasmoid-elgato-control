import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import "utils.js" as Utils

Item {

    id: settings

    property string ip_address

    property int on
    property int brightness
    property int temperature

    property string productName

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
                print('HEADERS_RECEIVED');
            } else if (xhr.readyState === XMLHttpRequest.DONE) {
                var jsonResponse = JSON.parse(xhr.responseText);
                var lights = jsonResponse.lights[0];

                settings.on = lights.on;
                settings.brightness = lights.brightness;
                settings.temperature = Utils.kelvinValueFromApi(lights.temperature);
            }
        }

        xhr.open("GET", `http://${this.ip_address}:9123/elgato/lights`);
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
                    print('HEADERS_RECEIVED');
                } else if (xhr.readyState === XMLHttpRequest.DONE) {
                    var jsonResponse = JSON.parse(xhr.responseText);
                }
         }

            xhr.open("PUT", `http://${this.ip_address}:9123/elgato/lights`);
            xhr.send(JSON.stringify(json));
        }
    }

    function identify() {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                print('HEADERS_RECEIVED');
            } else if (xhr.readyState === XMLHttpRequest.DONE) {
                print('DONE')
            }
        }

        xhr.open("POST", `http://${this.ip_address}:9123/elgato/identify`);
        xhr.send();
    }

    function getAccessoryInfo() {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                print('HEADERS_RECEIVED');
            } else if (xhr.readyState === XMLHttpRequest.DONE) {
                var jsonResponse = JSON.parse(xhr.responseText);

                settings.productName = jsonResponse.displayName;
            }
        }

        xhr.open("GET", `http://${this.ip_address}:9123/elgato/accessory-info`);
        xhr.send();
    }

    function setAccessoryInfo({displayName}) {

        var xhr = new XMLHttpRequest();

        var json = {
                "displayName": displayName
            }

        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                print('HEADERS_RECEIVED');
            } else if (xhr.readyState === XMLHttpRequest.DONE) {
                var jsonResponse = JSON.parse(xhr.responseText);
            }
        }

        xhr.open("PUT", `http://${this.ip_address}:9123/elgato/accessory-info`);
        xhr.send(JSON.stringify(json));
    }

    Component.onCompleted: {
        getAccessoryInfo();
        getLights();
    }
}
