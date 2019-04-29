import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3


Window {
    id: root
    visible: true
    width: 1280
    height: 620

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: ServerCheckingPage{}
    }
}
