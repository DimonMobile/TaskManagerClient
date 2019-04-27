import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    Page {
        readonly property bool inPortrait: this.width < this.height

        id: page
        anchors.fill: parent

        header: ToolBar {
            id: toolBar
            RowLayout {
                anchors.fill: parent
                ToolButton {
                    icon.source: 'qrc:/icons/resources/icons/message.svg';
                    visible: {
                        if (page.inPortrait && swipeView.currentIndex == 0)
                            return true;
                        else
                            return false;
                    }
                    onClicked: drawer.open()
                }
            }
        }

        contentItem: Item {
            ColumnLayout {
                anchors.fill: parent
                SwipeView {
                    id: swipeView
                    currentIndex: tabBar.currentIndex
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Item {
                        ListModel {
                            id: model
                            ListElement {
                                name: 'CAD'
                            }
                            ListElement {
                                name: 'Unknown squad'
                            }
                            ListElement {
                                name: 'Kabani 5'
                            }
                            ListElement {
                                name: 'Slish ueba gde mobila'
                            }
                            ListElement {
                                name: 'kek'
                            }
                            ListElement {
                                name: 'kek'
                            }
                        }
                        Drawer {
                            id: drawer
                            width: page.inPortrait ? parent.width : 500
                            y: toolBar.height
                            height: swipeView.height
                            visible: (!page.inPortrait && swipeView.currentIndex == 0) ? true : false
                            modal: (page.inPortrait && swipeView.currentIndex == 0) ? true : false
                            interactive: (page.inPortrait && swipeView.currentIndex == 0) ? true : false
                            position: page.inPortrait ? 0 : 1
                            ColumnLayout {
                                anchors.fill: parent
                                RowLayout{
                                    Layout.fillWidth: true
                                    TextField {
                                        Layout.margins: 5
                                        Layout.fillWidth: true
                                        placeholderText: qsTr('Username/email')
                                    }
                                    Button {
                                        Layout.margins: 5
                                        highlighted: true
                                        text: qsTr('Search')
                                        icon.source: 'qrc:/icons/resources/icons/search.svg';
                                    }
                                }

                                ListView{
                                    clip: true
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    model: model
                                    highlight: Rectangle{
                                        color: "lightblue"
                                    }

                                    delegate: ItemDelegate {
                                        width: parent.width
                                        text: "<b>" + name + "</b><br>Text message"
                                    }
                                }
                            }
                        }
                        Flickable {
                            anchors.fill: parent
                            anchors.leftMargin: page.inPortrait ? undefined : drawer.width
                            Label {
                                anchors.fill: parent
                                text: qsTr('No messages yet')
                                horizontalAlignment: Qt.AlignHCenter
                                verticalAlignment: Qt.AlignVCenter
                            }
                        }
                    }
                    Flickable {
                        clip: true
                        contentHeight: myFlow.childrenRect.height
                        ScrollIndicator.vertical: ScrollIndicator{}
                        Flow {
                            anchors.fill: parent
                            spacing: 25
                            anchors.margins: 10
                            id: myFlow

                            Rectangle {
                                color: "#99EEAA"; width: 300; height: childrenRect.height; radius: 10;
                                border {
                                    width: 2;
                                    color: "white";
                                }

                                ColumnLayout {
                                    width: parent.width
                                    RowLayout{
                                        Layout.fillWidth: true
                                        Label {
                                            Layout.margins: 10
                                            text: "My projects"
                                            Layout.fillWidth: true
                                        }
                                        ToolButton{
                                            text: '+'
                                            Layout.alignment: Qt.AlignRight
                                        }
                                    }
                                    Rectangle {
                                        height: 2
                                        Layout.fillWidth: true
                                    }

                                    ListView {
                                        clip: true
                                        ScrollIndicator.vertical: ScrollIndicator {}
                                        model: model
                                        height: 400
                                        Layout.fillWidth: true
                                        delegate: ItemDelegate {
                                            width: parent.width
                                            text: name
                                        }
                                    }
                                }

                                layer.enabled: true
                                layer.effect: DropShadow {
                                    transparentBorder: true
                                    horizontalOffset: 3
                                    verticalOffset: 4
                                    radius: 5
                                }
                            }

                            Rectangle {
                                color: "#99EEAA"; width: 300; height: childrenRect.height; radius: 10;
                                border {
                                    width: 2;
                                    color: "white";
                                }

                                ColumnLayout {
                                    width: parent.width
                                    Label {
                                        Layout.margins: 10
                                        text: "My activity"
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Rectangle {
                                        height: 2
                                        Layout.fillWidth: true
                                    }
                                    Label {
                                        Layout.margins: 10
                                        text: "Assigned to me: 10"
                                    }
                                    Label {
                                        Layout.margins: 10
                                        text: "Active projects: 5"
                                    }
                                }
                                layer.enabled: true
                                layer.effect: DropShadow {
                                    transparentBorder: true
                                    horizontalOffset: 3
                                    verticalOffset: 4
                                    radius: 5
                                }
                            }

                            Rectangle {
                                color: "#EEAA99"; width: 300; height: childrenRect.height; radius: 10;
                                border {
                                    width: 2;
                                    color: "white";
                                }

                                ColumnLayout {
                                    width: parent.width
                                    Label {
                                        Layout.margins: 10
                                        text: "Bug: program crashes"
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Rectangle {
                                        height: 2
                                        Layout.fillWidth: true
                                    }
                                    Label {
                                        Layout.margins: 10
                                        text: "Short descriptions"
                                    }
                                }
                                layer.enabled: true
                                layer.effect: DropShadow {
                                    transparentBorder: true
                                    horizontalOffset: 3
                                    verticalOffset: 4
                                    radius: 5
                                }
                            }

                            Rectangle {
                                color: "#EEAA99"; width: 300; height: childrenRect.height; radius: 10;
                                border {
                                    width: 2;
                                    color: "white";
                                }

                                ColumnLayout {
                                    width: parent.width
                                    Label {
                                        Layout.margins: 10
                                        text: "Bug: manager die"
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Rectangle {
                                        height: 2
                                        Layout.fillWidth: true
                                    }
                                    Label {
                                        Layout.margins: 10
                                        text: "This is a more complex description"
                                    }
                                }
                                layer.enabled: true
                                layer.effect: DropShadow {
                                    transparentBorder: true
                                    horizontalOffset: 3
                                    verticalOffset: 4
                                    radius: 5
                                }
                            }

                            Rectangle {
                                color: "#99AAEE"; width: 300; height: childrenRect.height; radius: 10;
                                border {
                                    width: 2;
                                    color: "white";
                                }

                                ColumnLayout {
                                    width: parent.width
                                    Label {
                                        Layout.margins: 10
                                        text: "New feature: put me"
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    Rectangle {
                                        height: 2
                                        Layout.fillWidth: true
                                    }
                                    Label {
                                        Layout.margins: 10
                                        wrapMode: Label.WordWrap
                                        Layout.fillWidth: true
                                        text: "AAAA AA long words and many too AAAA AA long words and many too AAAA AA long words and many too AAAA AA long words and many too AAAA AA long words and many too AAAA AA long words and many too"
                                    }
                                }
                                layer.enabled: true
                                layer.effect: DropShadow {
                                    transparentBorder: true
                                    horizontalOffset: 3
                                    verticalOffset: 4
                                    radius: 5
                                }
                            }
                        }
                    }
                }
                TabBar{
                    id: tabBar
                    currentIndex: swipeView.currentIndex
                    Layout.preferredHeight: 50
                    Layout.fillWidth: true
                    position: TabBar.Footer
                    TabButton {
                        width: 200
                        text: qsTr('Conversations')
                        icon.source: 'qrc:/icons/resources/icons/message.svg';
                    }
                    TabButton {
                        width: 200
                        text: qsTr('My tasks')
                        icon.source: 'qrc:/icons/resources/icons/list.svg';
                    }
                }
            }
        }
    }
}
