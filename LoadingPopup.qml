import QtQuick 2.0
import QtQuick.Controls 2.5

Popup {
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent
    modal: true
    focus: true
    width: 150
    height: 150
    BusyIndicator {
        rotation: 180
        anchors.fill: parent
    }
}
