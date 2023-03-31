import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

Item {

    id: api

    property string ip_address
    property int on
    property int brightness
    property int temperature

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            getLight()
            console.log("TEMP: ", temperature)
        }
    }

    Component.onCompleted: {
            getLight()
    }

    function getLight() {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                print('HEADERS_RECEIVED');
            } else if (xhr.readyState === XMLHttpRequest.DONE) {
                var jsonResponse = JSON.parse(xhr.responseText);
                var settings = jsonResponse.lights[0];

                api.on = settings.on
                api.brightness = settings.brightness
                api.temperature = settings.temperature
            }
        }

        xhr.open("GET", `http://${this.ip_address}:9123/elgato/lights`);
        xhr.send();
    }

    function setLight(key, value) {
        var xhr = new XMLHttpRequest();

        var json = {
            "numberOfLights": 1,
            "lights": [{}]
        }

        json["lights"][0][key] = value

        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
                print('HEADERS_RECEIVED');
            } else if (xhr.readyState === XMLHttpRequest.DONE) {
                var jsonResponse = JSON.parse(xhr.responseText);
                var settings = jsonResponse.lights[0];

                this.on = settings.on
                this.brightness = settings.brightness
                this.temperature = settings.temperature
            }
        }

        xhr.open("PUT", `http://${this.ip_address}:9123/elgato/lights`);
        xhr.send(JSON.stringify(json));
    }
}