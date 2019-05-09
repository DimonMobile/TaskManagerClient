import QtQuick 2.12
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
                            id: statusComboBox
                            model: [qsTr('<All>'), qsTr('Open'), qsTr('Resolved')]
                        }
                    }
                    ColumnLayout {
                        Label {
                            text: qsTr('Assignee/Creator')
                        }
                        ComboBox {
                            id: variantComboBox
                            model: [qsTr('<All>'), qsTr('Assigned to me'), qsTr('Created by me')]
                            Layout.preferredWidth: 200
                        }
                    }
                    ColumnLayout {
                        Label {
                            text: qsTr('Type')
                        }
                        ComboBox {
                            id: typeComboBox
                            model: [qsTr('<All>'), qsTr('Feature'), qsTr('Bug')]
                        }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        Label {
                            text: qsTr('Search')
                        }
                        TextField {
                            id: searchTextField
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
                        onClicked: {
                            let hr = new XMLHttpRequest();
                            hr.open("POST", Constants.HOST_ADDRESS + "/get_issues");
                            hr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                            hr.onreadystatechange = function() {
                                if (hr.readyState === 4) {
                                    issuesListView.footerItem.visible = false;
                                    let resultObject = JSON.parse(hr.responseText);
                                    if (resultObject.result === "success") {
                                        let items = resultObject.items;
                                        for(var i = 0 ; i < items.length; ++i) {
                                            var resultItem = {}
                                            resultItem['name'] = items[i].name;
                                            resultItem['issue_id'] = items[i].id;
                                            resultItem['project'] = items[i].project_name;
                                            resultItem['status'] = items[i].status;
                                            resultItem['estimate'] = items[i].estimate;
                                            resultItem['progress'] = items[i].progress;
                                            if (items[i].issue_type === 0) {
                                                resultItem['ico'] = 'qrc:/icons/resources/icons/lens.svg';
                                            } else if (items[i].issue_type === 1) {
                                                resultItem['ico'] = 'qrc:/icons/resources/icons/error.svg';
                                            }

                                            issuesModel.append(resultItem);
                                        }
                                    }
                                }
                            }
                            issuesModel.clear();
                            issuesListView.footerItem.visible = true;
                            hr.send("token=" + encodeURIComponent(Settings.token()) +
                                    "&status=" + encodeURIComponent(statusComboBox.currentIndex) +
                                    "&variant=" + encodeURIComponent(variantComboBox.currentIndex) +
                                    "&type=" + encodeURIComponent(typeComboBox.currentIndex) +
                                    "&s=" + encodeURIComponent(searchTextField.text));
                        }
                    }
                }
            }

            ListView {
                id: issuesListView
                clip: true
                model: issuesModel
                Layout.fillHeight: true
                Layout.fillWidth: true

                footer: BusyIndicator {
                    width: parent.width
                    visible: false
                }


                add: Transition {
                    NumberAnimation { property: "x"; from: width; to: x; duration: 1000; easing.type: Easing.OutCubic }
                }

                remove: Transition {
                    NumberAnimation { property: "x"; from: 0; to: -width; duration: 1000; easing.type: Easing.InCubic }
                }

                delegate: ItemDelegate {
                    width: parent.width
                    text: issue_id + '. ' + '<b>' + project + '</b> ' + ( (status === 1) ? '<font color="green">' + qsTr('[resolved]') + '</font>' : '' ) + '<br>' + name
                    icon.source: ico

                    onClicked: {
                        stackView.push(Qt.createComponent('qrc:/qml/resources/qml/IssuePage.qml').createObject(null, {issueIndex: parseInt(issue_id)}));
                    }

                    ProgressBar {
                        height: 5
                        from: 0
                        to: estimate
                        width: parent.width
                        indeterminate: estimate == 0 ? true : false
                        NumberAnimation on value {
                            to: progress
                            duration: 8000
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }
            ListModel {
                id: issuesModel
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
}
