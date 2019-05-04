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

            GroupBox {
                Layout.fillWidth: true
                Layout.margins: 15
                label: Label {
                    text: qsTr('Filter')
                }

                Flow {
                    spacing: 15
                    anchors.fill: parent
                    flow: Flow.LeftToRight
                    ColumnLayout {
                        Label {
                            text: qsTr('Status')
                        }
                        ComboBox {
                            model: ['<All>', 'Open', 'Resolved']
                        }
                    }
                    ColumnLayout {
                        Label {
                            text: qsTr('Assignee/Creator')
                        }
                        ComboBox {
                            model: ['<All>', 'Assigned to me', 'Created by me']
                            Layout.preferredWidth: 200
                        }
                    }
                    ColumnLayout {
                        Label {
                            text: qsTr('Type')
                        }
                        ComboBox {
                            model: ['<All>', 'Feature', 'Bug']
                        }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        Label {
                            text: qsTr('Search')
                        }
                        TextField {
                            placeholderText: qsTr('Part of name')
                            Layout.preferredWidth: 300
                            Layout.minimumWidth: 100
                            Layout.fillWidth: true
                        }
                    }
                    Button {
                        Layout.alignment: Qt.AlignRight
                        highlighted: true
                        text: qsTr('Filter')
                        icon.source: 'qrc:/icons/resources/icons/search.svg'
                    }
                }
            }

            ListView {
                clip: true
                model: issuesModel
                Layout.fillHeight: true
                Layout.fillWidth: true
                header: BusyIndicator {
                    width: parent.width
                }
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
                    id: issueNameTextEdit
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
                    id: issueDescriptionTextArea
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
                    id: issueEstimateSpinBox
                    value: 0
                    Layout.preferredWidth: 300
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Label {
                    text: qsTr('Type')
                    Layout.fillWidth: true
                }

                RowLayout{
                    Layout.fillWidth: true
                    RadioButton {
                        id: createIssueFeatureRadioButton
                        checked: true
                        text: qsTr('New feature')
                    }
                    RadioButton {
                        id: createIssueBugRadioButton
                        text: qsTr('Bug')
                    }
                }
            }

            RowLayout {
                Label {
                    text: qsTr('Project')
                    Layout.fillWidth: true
                }
                ComboBox {
                    id: projectNameComboBox
                    editable: true
                    model: projectsModel
                    Layout.preferredWidth: 300
                    onFocusChanged: {
                        if (focus == true) {
                            Utils.loadProjectsToModel(projectsModel, projectNameComboBox, projectsLoadIndicator, false);
                        }
                    }
                }
            }

            RowLayout {
                Button {
                    id: createIssueButton
                    highlighted: true
                    text: qsTr('Create issue')
                    onClicked: {
                        let issueType;
                        if (createIssueFeatureRadioButton.checked) {
                            issueType = 0;
                        } else if (createIssueBugRadioButton.checked) {
                            issueType = 1;
                        }
                        console.log(projectNameComboBox.currentText);
                        Utils.createIssue(issueNameTextEdit.text, issueDescriptionTextArea.text
                                          , issueEstimateSpinBox.value, projectNameComboBox.currentText, issueType
                                          , createIssueButton, projectsLoadIndicator, createIssueErrorLabel);
                    }
                }
                Label {
                    id: createIssueErrorLabel
                    Layout.fillWidth: true
                    horizontalAlignment: Qt.AlignHCenter
                }
            }
        }
    }
    Popup {
        id: filterPopup
    }
}
