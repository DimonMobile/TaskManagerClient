import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

import 'qrc:/js/resources/js/Constants.js' as Constants
import 'qrc:/js/resources/js/Utils.js' as Utils

Page {
    id: page

    property int currentIssueState: 0

    function switchIssueState(state) {
        if (state === 0) {
            issueNameLabel.color = "black";
            issueResolveButton.text = qsTr('Resolve issue');
            currentIssueState = 0;
        } else if (state === 1) {
            issueNameLabel.color = "green";
            issueResolveButton.text = qsTr('Open issue');
            currentIssueState = 1;
        }
    }

    property int issueIndex: 0

    Component.onCompleted: {
        let hr = new XMLHttpRequest();
        hr.open("POST", Constants.HOST_ADDRESS + "/get_issue");
        hr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        hr.onreadystatechange = function() {
            if (hr.readyState === 4) {
                let resultObject = JSON.parse(hr.responseText);
                if (resultObject.result === "success") {
                    let resultItem = resultObject.issue;
                    issueNameLabel.text = resultItem.name;
                    estimateProgressBar.to = resultItem.estimate;
                    estimateProgressBar.value = resultItem.progress;
                    issueDescriptionLabel.text = resultItem.description;
                    issueProgressLabel.text = resultItem.progress;
                    issueEstimateLabel.text = resultItem.estimate;
                    issueProjectNameLabel.text = resultItem.project_name
                    issueCreatorLabel.text = resultItem.creator.email + '[' + resultItem.creator.name + ']';
                    issueCreatedLabel.text = resultItem.created;
                    issueAssigneeButton.enabled = resultItem.can_edit;
                    issueLogWorkButton.enabled = resultItem.can_log;
                    issueResolveButton.enabled = resultItem.can_edit || resultItem.can_log;
                    issueReestimateButton.enabled = resultItem.can_edit;
                    switchIssueState(resultItem.status);
                    if (resultItem.issue_type === 0) {
                        issueTypeImage.source = 'qrc:/icons/resources/icons/lens.svg'
                    } else if (resultItem.issue_type === 1) {
                        issueTypeImage.source = 'qrc:/icons/resources/icons/error.svg'
                    }

                    if (resultItem.assignee !== null) {
                        issueAssigneeButton.text = resultItem.assignee.email;
                    }
                }
            }
        }
        hr.send("token=" + encodeURIComponent(Settings.token()) +
                "&id=" + encodeURIComponent(issueIndex));
    }

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                icon.source: 'qrc:/icons/resources/icons/left-arrow.svg'
                onClicked: stackView.pop()
            }
            Label {
                Layout.fillWidth: true
                horizontalAlignment: Qt.AlignHCenter
                text: qsTr('Issue deatils')
            }
        }
    }

    contentItem: Item {
        ColumnLayout {
            anchors.fill: parent
            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.margins: 10
                    id: issueIndexLabel
                    text: issueIndex
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    color: "grey"
                }

                Label {
                    id: issueNameLabel
                    font.capitalization: Font.AllUppercase
                    font.pointSize: 26
                    Layout.fillWidth: true
                    horizontalAlignment: Qt.AlignHCenter
                }

                Row {
                    Layout.margins: 10
                    Label {
                        id: issueProgressLabel
                        text: '6'
                        color: "grey"
                        horizontalAlignment: Qt.AlignHCenter
                    }
                    Label {
                        color: 'grey'
                        text: ' of '
                    }
                    Label {
                        id: issueEstimateLabel
                        color: 'grey'
                        text: '12'
                    }
                    Label {
                        color: 'grey'
                        text: qsTr(' hours')
                    }
                }

            }
            ProgressBar {
                id: estimateProgressBar
                Layout.fillWidth: true
                from: 0
                value: 0
                indeterminate: to == 0 ? true : false
            }
            Row {
                Button {
                    id: issueResolveButton

                    onClicked: {
                        resolveIssueBusyIndicator.running = true;
                        let hr = new XMLHttpRequest();
                        hr.open("POST", Constants.HOST_ADDRESS + "/switch_status");
                        hr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                        hr.onreadystatechange = function() {
                            if (hr.readyState === 4) {
                                resolveIssueBusyIndicator.running = false;
                                let resultObject = JSON.parse(hr.responseText);
                                if (resultObject.result === "success") {
                                    switchIssueState(resultObject.status);
                                }
                            }
                        }
                        hr.send("token=" + encodeURIComponent(Settings.token()) +
                                "&id=" + encodeURIComponent(issueIndex) +
                                "&status=" + encodeURIComponent( currentIssueState == 0 ? 1 : 0));
                        logWorkPopup.close();
                    }
                }
                Button {
                    id: issueLogWorkButton
                    text: qsTr('Log work')
                    onClicked: logWorkPopup.open()
                }
                Button {
                    id: issueReestimateButton
                    text: qsTr('Re-estimate')
                    onClicked: {
                        reestimateSpinBox.value = estimateProgressBar.to;
                        reestimatePopup.open();
                    }
                }
                BusyIndicator {
                    id: resolveIssueBusyIndicator
                    running: false
                }
            }
            Row {
                Label {
                    text: '<b>' + qsTr('Project') + ': </b>'
                }
                Label {
                    id: issueProjectNameLabel
                    text: ''
                }
            }
            Row {
                Label {
                    text: '<b>' + qsTr('Created') + ': </b>'
                }
                Label {
                    id: issueCreatedLabel
                }
            }
            Row {
                Label {
                    text: '<b>' + qsTr('Creator') + ': </b>'
                }
                Label {
                    id: issueCreatorLabel
                }
            }
            Row {
                Label {
                    text: '<b>' + qsTr('Type') + ': </b>'
                }
                Image {
                    id: issueTypeImage
                }
            }

            RowLayout {
                Label {
                    text: '<b>' + qsTr('Assignee') + ': </b>'
                }
                Button {
                    id: issueAssigneeButton
                    text: qsTr('<empty>')
                    highlighted: true
                    flat: true
                    onClicked: {
                        visible = false;
                        issueAssigneeTextField.visible = true;
                        issueAssigneeTextField.focus = true;
                    }
                }
                TextField {
                    id: issueAssigneeTextField
                    visible: false
                    placeholderText: qsTr('Email')
                    onFocusChanged: {
                        if (!focus) {
                            issueAssigneeButton.visible = true;
                            issueAssigneeTextField.visible = false;
                        }
                    }
                    onAccepted: {
                        issueAssigneeIndicator.running = true;

                        let hr = new XMLHttpRequest();
                        hr.open("POST", Constants.HOST_ADDRESS + "/assign_issue");
                        hr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                        hr.onreadystatechange = function() {
                            if (hr.readyState === 4) {
                                issueAssigneeIndicator.running = false;
                                let resultObject = JSON.parse(hr.responseText);
                                if (resultObject.result === "success") {
                                    issueAssigneeErrorLabel.color = "green";
                                    issueAssigneeErrorLabel.text = qsTr('Assigned successfully')
                                    text = '';
                                    issueAssigneeTextField.visible = false;
                                    issueAssigneeButton.visible = true;
                                    issueAssigneeButton.text = resultObject.user_email;

                                    issueAssigneeButton.enabled = resultObject.can_edit;
                                    issueLogWorkButton.enabled = resultObject.can_log;
                                    issueResolveButton.enabled = resultObject.can_edit || resultItem.can_log;
                                    issueReestimateButton.enabled = resultObject.can_edit;
                                } else if (resultObject.result === "error"){
                                    issueAssigneeErrorLabel.color = "red";
                                    issueAssigneeErrorLabel.text = Constants.getErrorString(resultObject.error_code);
                                }
                                issueAssigneeErrorLabel.visible = true;
                            }
                        }
                        hr.send("token=" + encodeURIComponent(Settings.token()) +
                                "&id=" + encodeURIComponent(issueIndex) +
                                "&assignee=" + encodeURIComponent(text));
                    }
                }
                BusyIndicator {
                    id: issueAssigneeIndicator
                    running: false
                }
                Label {
                    id: issueAssigneeErrorLabel
                }
            }

            Label {
                id: issueDescriptionLabel
                Layout.fillHeight: true
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: '...'
            }
        }
    }
    Popup {
        id: reestimatePopup
        anchors.centerIn: parent
        modal: true
        Column {
            SpinBox {
                id: reestimateSpinBox
            }
            Button {
                text: qsTr('Estimate')
                highlighted: true
                onClicked: {
                    let hr = new XMLHttpRequest();
                    hr.open("POST", Constants.HOST_ADDRESS + "/re_estimate");
                    hr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                    hr.onreadystatechange = function() {
                        if (hr.readyState === 4) {
                            let resultObject = JSON.parse(hr.responseText);
                            if (resultObject.result === "success") {
                                estimateProgressBar.to = resultObject.summary;
                                issueEstimateLabel.text = resultObject.summary;
                            }
                        }
                    }
                    hr.send("token=" + encodeURIComponent(Settings.token()) +
                            "&id=" + encodeURIComponent(issueIndex) +
                            "&time=" + encodeURIComponent(reestimateSpinBox.value));
                    reestimatePopup.close();
                }
            }
        }
    }

    Popup {
        id: logWorkPopup
        anchors.centerIn: parent
        modal: true
        Column {
            SpinBox {
                id: logWorkSpinBox
            }
            Button {
                text: qsTr('Log')
                highlighted: true
                onClicked: {
                    let hr = new XMLHttpRequest();
                    hr.open("POST", Constants.HOST_ADDRESS + "/log_work");
                    hr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                    hr.onreadystatechange = function() {
                        if (hr.readyState === 4) {
                            let resultObject = JSON.parse(hr.responseText);
                            if (resultObject.result === "success") {
                                estimateProgressBar.value = resultObject.summary;
                                issueProgressLabel.text = resultObject.summary;
                            }
                        }
                    }
                    hr.send("token=" + encodeURIComponent(Settings.token()) +
                            "&id=" + encodeURIComponent(issueIndex) +
                            "&time=" + encodeURIComponent(logWorkSpinBox.value));
                    logWorkPopup.close();
                }
            }
        }
    }
}
