import QtQuick 2.0
import QtQuick.Controls 2.5

import "Constants.js" as Constants;

Page{
    function testServer() {
        refreshButton.enabled = false;
        indicator.text = qsTr("Testing server for availability");
        indicator.running = true;
        var httpRequest = new XMLHttpRequest();
        httpRequest.open('GET', Constants.HOST_ADDRESS + '/test');
        httpRequest.send();
        httpRequest.onreadystatechange = function() {
            if (httpRequest.readyState == 4) {
                if (httpRequest.status == 200) {
                    indicator.text = qsTr("Connected");
                    indicator.running = false;
                    switchTimer.interval = 1000;
                    switchTimer.running = true;
                }
                else {
                    refreshButton.enabled = true;
                    indicator.text = qsTr("Connection failed");
                    indicator.running = false;
                }
            }
        }
    }

    header: ToolBar {
        ToolButton {
            id: refreshButton
            icon.source: "qrc:/icons/resources/icons/refresh.svg"
            enabled: false
            onClicked: testServer()
        }

        ToolButton {
            anchors.right: parent.right
            icon.source: "qrc:/icons/resources/icons/power.svg"
        }
    }

    contentItem: LoadIndicator{
        id: indicator
        Component.onCompleted: testServer();
    }

    Timer{
        id: switchTimer
        repeat: false
        running: false
        onTriggered: {
            stackView.push(Qt.createComponent("qrc:/AuthorizePage.qml"));
        }
    }

    footer: Label{
        padding: 5
        text: qsTr("Dmitry Plotnikov, build Qt 5.12 (QtQuick 2.12)")
    }
}
