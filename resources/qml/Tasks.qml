import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

import "qrc:/js/resources/js/Constants.js" as Constants
import "qrc:/js/resources/js/Utils.js" as Utils

Page {
    header: ToolBar{
        RowLayout {
            anchors.fill: parent
            visible: true
            ToolButton{
                icon.source: 'qrc:/icons/resources/icons/left-arrow.svg'
                onClicked: {
                    stackView.pop();
                    drawer.position = (!page.inPortrait && swipeView.currentIndex === 0) ? 1 : 0
                }
            }
            Label {
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: qsTr('Issues')
                elide: Label.ElideRight
            }
            ToolButton {
                icon.source: 'qrc:/icons/resources/icons/add-circle.svg'
                onClicked: createIssuePopup.open()
            }
        }
    }
    contentItem: Item {
        ColumnLayout {
            anchors.fill: parent
            RowLayout {
                Layout.fillWidth: true
                TextField {
                    Layout.leftMargin: 10
                    Layout.fillWidth: true
                }
                Button {
                    highlighted: true
                    text: qsTr('Search')
                }
                Button {
                    text: qsTr('Filter')
                    Layout.rightMargin: 10
                }
            }
            ListView {
                clip: true
                model: issuesModel
                Layout.fillHeight: true
                Layout.fillWidth: true
                delegate: ItemDelegate {
                    width: parent.width
                    text: name
                    icon.source: ico
                    ProgressBar {
                        value: 0.6
                        width: parent.width
                        indeterminate: true
                    }
                }
            }
        }
    }
    ListModel {
        id: issuesModel
        ListElement {
            name: '<b>This is the name of the issue</b><br><br>Created: <font color="brown">Fred Pirs</font><br>Assignee: <font color="brown">Dimon Mobile</font>'
            ico: 'qrc:/icons/resources/icons/error.svg'
        }
        ListElement {
            name: '<b>This is the name of the issue</b><br><br>Created: <font color="brown">Fred Pirs</font><br>Assignee: <font color="brown">Dimon Mobile</font>'
            ico: 'qrc:/icons/resources/icons/lens.svg'
        }
    }
    ListModel {
        id: projectsModel
    }

    Popup {
        id: createIssuePopup
        anchors.centerIn: parent
        modal: true
        width: 500

        ColumnLayout {
            anchors.fill: parent
            RowLayout{
                Label {
                    text: qsTr('New issue')
                    font.capitalization: Font.AllUppercase
                    font.bold: true
                    font.pointSize: 22
                }
                BusyIndicator {
                    id: projectsLoadIndicator
                    visible: false
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: qsTr('Issue name')
                    Layout.fillWidth: true
                }
                TextField {
                    Layout.preferredWidth: 300
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    text: qsTr('Description')
                }
                TextArea {
                    Layout.preferredWidth: 300
                }
            }

            RowLayout {
                Layout.fillWidth: true
                ColumnLayout {
                    Layout.fillWidth: true
                    Label {
                        text: qsTr('Estimate(in hours)')
                        Layout.fillWidth: true
                    }
                    Label {
                        text: qsTr('Zero for infinity')
                        color: "grey"
                        font.pointSize: 6
                    }
                }

                SpinBox{
                    value: 0
                    Layout.preferredWidth: 300
                }
            }

            RowLayout {
                Label {
                    text: qsTr('Project')
                    Layout.fillWidth: true
                }
                ComboBox {
                    id: projectsComboBox
                    editable: true
                    model: projectsModel
                    Layout.preferredWidth: 300
                    onFocusChanged: {
                        if (focus == true) {
                            Utils.loadProjectsToModel(projectsModel, projectsComboBox, projectsLoadIndicator, false);
                        }
                    }
                }
            }
            Button {
                highlighted: true
                text: qsTr('Create issue')
            }
        }
    }
}
