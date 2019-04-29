import QtQuick 2.0
import QtQuick.Controls 2.5


Item{
    property alias text: label.text
    property bool running: true

    BusyIndicator {
        rotation: 180
        anchors.centerIn: parent
        id: indicator
        width: 100
        height: 100
    }

    Label {
        id: label
        topPadding: 15
        anchors.top: indicator.bottom
        anchors.horizontalCenter: indicator.horizontalCenter
        text: qsTr("Loading...")
    }

    states: [
        State{
            when: running;
            PropertyChanges{
                target: indicator
                height: 100
                running: true
            }
            PropertyChanges {
                target: label
                font.pointSize: 14
            }
        },
        State{
            when: !running;
            PropertyChanges {
                target: indicator
                height: 0
                running: false
            }
            PropertyChanges {
                target: label
                font.pointSize: 30
            }
        }
    ]

    transitions: Transition {
        NumberAnimation {
            target: indicator
            property: "height"
            duration: 500
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: label
            property: "font.pixelSize"
            duration: 500
            easing.type: Easing.OutCubic
        }
    }
}
