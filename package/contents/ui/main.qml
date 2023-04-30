import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

ColumnLayout {
    id: app

    RowLayout {
        PlasmaComponents.TextField {
            id: input
        }

        PlasmaComponents.Button {
            id: add
            text: "Add"
            onClicked: {
                var ip_address = input.text;
                input.text = "";
                app.createControl(ip_address);
            }
        }
    }

    function createControl(ip_address) {
        var component = Qt.createComponent("ElgatoKeyLightControl.qml");
        if (component.status == Component.Ready) {
            var controlGroup = component.createObject(app, {
                    "ip_address": ip_address
                });
        }
        if (controlGroup == null) {
            // Error Handling
            console.log("Error creating object");
        }
    }
}
