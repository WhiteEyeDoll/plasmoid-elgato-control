
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
            onClicked: {
                var ip = input.text
                input.text = ""
                app.createControl(ip)
            }
        }
    }

    function createControl(ip) {
        var component = Qt.createComponent("ElgatoKeyLightControl.qml");
        if (component.status == Component.Ready) {
            var controlGroup = component.createObject(app);
            controlGroup.ip_address = ip;
        }
        if (controls == null) {
            // Error Handling
            console.log("Error creating object");
        }
    }
}
