import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0


import 'qrc:/js/resources/js/Utils.js' as Utils;
import 'qrc:/js/resources/js/Constants.js' as Constants;

Item {
    Popup {
        id: projectCreatorPopup
        focus: true
        modal: true
        anchors.centerIn: parent
        ColumnLayout {
            RowLayout {
                Label {
                    Layout.fillWidth: true
                    text: qsTr('Name')
                }
                TextField {
                    id: popupProjectName
                    Layout.preferredWidth: 300
                    Layout.alignment: Qt.AlignRight
                }
            }
            RowLayout {
                Label {
                    text: qsTr('Description')
                    Layout.fillWidth: true
                }
                TextArea {
                    id: popupProjectDescription
                    Layout.preferredWidth: 300
                    Layout.alignment: Qt.AlignRight
                }
            }
            RowLayout {
                Button{
                    id: popupAddProjectButton
                    highlighted: true
                    text: qsTr('Create')
                    icon.source: 'qrc:/icons/resources/icons/add-note.svg'
                    enabled: true
                    onClicked: {
                        var hr = new XMLHttpRequest();
                        hr.open("POST", Constants.HOST_ADDRESS + "/add_project");
                        hr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                        hr.onreadystatechange = function() {
                            if (hr.readyState === 4) {
                                var obj = JSON.parse(hr.responseText);
                                if (obj.result === "success") {
                                    popupCreateProjectLabel.color = "green";
                                    popupCreateProjectLabel.text = "Created";
                                } else if (obj.result === "error") {
                                    popupCreateProjectLabel.color = "red";
                                    popupCreateProjectLabel.text = Constants.getErrorString(obj.error_code);
                                }
                                popupCreateProjectLabel.visible = true;
                                popupProjectIndicator.running = false;
                                popupAddProjectButton.enabled = true;
                                Utils.loadProjectsToModel(model, projectListDashboard, projectListDashboardIndicator);
                            }
                        }

                        hr.send("token=" + encodeURIComponent(Settings.token()) +
                                "&name=" + encodeURIComponent(popupProjectName.text) +
                                "&description=" + encodeURIComponent(popupProjectDescription.text));

                        popupProjectIndicator.running = true;
                        popupCreateProjectLabel.visible = false;

                        enabled = false;
                    }
                }
                BusyIndicator{
                    id: popupProjectIndicator
                    running: false
                    Layout.fillWidth: true
                }
                Label {
                    id: popupCreateProjectLabel
                    visible: false
                }
            }
        }
    }

    LoadingPopup {
        id: loadingPopup
    }

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

                                BusyIndicator {
                                    Layout.fillHeight: true
                                    Layout.alignment: Qt.AlignCenter
                                }

                                ListView{
                                    visible: false
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
                        contentWidth: myFlow.childrenRect.width
                        ScrollIndicator.vertical: ScrollIndicator{}
                        Flow {
                            flow: Flow.TopToBottom
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
                                            icon.source: 'qrc:/icons/resources/icons/add-note.svg'
                                            Layout.alignment: Qt.AlignRight
                                            onClicked: projectCreatorPopup.open();
                                        }
                                    }
                                    Rectangle {
                                        height: 2
                                        Layout.fillWidth: true
                                    }
                                    BusyIndicator {
                                        id: projectListDashboardIndicator
                                        Layout.fillHeight: true
                                        Layout.alignment: Qt.AlignCenter
                                    }
                                    ListView {
                                        id: projectListDashboard
                                        visible: false
                                        clip: true
                                        model: model
                                        ScrollIndicator.vertical: ScrollIndicator {}
                                        height: 400
                                        Layout.fillWidth: true
                                        Component.onCompleted: {
                                            Utils.loadProjectsToModel(model, projectListDashboard, projectListDashboardIndicator);
                                        }
                                        delegate: ItemDelegate {
                                            onPressAndHold: {
                                                projectListDashboard.currentIndex = index;
                                                projectListContextMenu.popup();
                                            }
                                            width: parent.width
                                            text: name
                                        }
                                    }
                                    Menu {
                                        id: projectListContextMenu
                                        MenuItem {
                                            text: qsTr("Remove")
                                            onClicked: {
                                                //projectListDashboard.currentItem.text
                                                loadingPopup.open();
                                                var hr = new XMLHttpRequest();
                                                hr.open("POST", Constants.HOST_ADDRESS + "/remove_project");
                                                hr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                                                hr.onreadystatechange = function() {
                                                    if (hr.readyState === 4) {
                                                        loadingPopup.close();
                                                        var obj = JSON.parse(hr.responseText);
                                                        if (obj.result === "success") {

                                                        }
                                                        Utils.loadProjectsToModel(model, projectListDashboard, projectListDashboardIndicator);
                                                    }
                                                }
                                                hr.send("token=" + encodeURIComponent(Settings.token()) +
                                                        "&project_name=" + encodeURIComponent(projectListDashboard.currentItem.text));
                                            }
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
                                color: "#99EE88"; width: 300; height: childrenRect.height; radius: 10;
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
                                color: "#BBDDAA"; width: 300; height: childrenRect.height; radius: 10;
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
                                            text: "Assigned to me"
                                            Layout.fillWidth: true
                                        }
                                    }
                                    Rectangle {
                                        height: 2
                                        Layout.fillWidth: true
                                    }

                                    BusyIndicator {
                                        Layout.fillHeight: true
                                        Layout.alignment: Qt.AlignCenter
                                    }

                                    ListView {
                                        visible: false
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
                        text: qsTr('Dashboard')
                        icon.source: 'qrc:/icons/resources/icons/list.svg';
                    }
                }
            }
        }
    }
}
