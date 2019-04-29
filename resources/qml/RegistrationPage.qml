import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

import "qrc:/js/resources/js/Constants.js" as Constants;

Page {
    Menu{
        id: languageMenu
        MenuItem {
            text: qsTr('English')
            onClicked: {
                Translator.translateTo(0)
                languageButton.text = this.text
            }
        }

        MenuItem {
            text: qsTr('Russian')
            onClicked: {
                Translator.translateTo(1)
                languageButton.text = this.text
            }
        }
    }

    header: ToolBar{
        RowLayout {
            anchors.fill: parent
            spacing: 30

            ToolButton{
                icon.source: "qrc:/icons/resources/icons/left-arrow.svg"
                onClicked: stackView.pop()
            }


        }
    }
    contentItem: Item{
        Column{
            anchors.centerIn: parent
            spacing: 25

            TextField {
                id: nameTextField
                placeholderText: qsTr("Your name")
                width: 320
                ToolTip {
                    id: nameToolTip
                    anchors.centerIn: parent
                    timeout: 1000
                }
            }

            TextField {
                id: emailTextField
                placeholderText: qsTr("Email")
                width: 320
                ToolTip {
                    id: emailToolTip
                    anchors.centerIn: parent
                    timeout: 1000
                }
            }

            TextField {
                id: passwordTextField
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password
                width: 320
                ToolTip {
                    id: passwordToolTip
                    anchors.centerIn: parent
                    timeout: 1000
                }
            }

            TextField {
                id: repeatPasswordTextField
                placeholderText: qsTr("Repeat password")
                echoMode: TextInput.Password
                width: 320
            }

            RowLayout {
                width: parent.width
                Button {
                    highlighted: true
                    text: qsTr("Register")
                    onClicked: {
                        popup.open();
                        var hr = new XMLHttpRequest();
                        hr.open("POST", Constants.HOST_ADDRESS + "/register");
                        hr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');

                        var name = encodeURIComponent(nameTextField.text);
                        var email = encodeURIComponent(emailTextField.text);
                        var password = encodeURIComponent(passwordTextField.text);
                        var repeatPassword = encodeURIComponent(repeatPasswordTextField.text);

                        if (password === repeatPassword) {
                            hr.send("name=" + name + "&password=" + password + "&email=" + email + "&language=" + languageButton.text);
                            hr.onreadystatechange = function() {
                                if (hr.readyState == 4) {
                                    popup.close();
                                    if (hr.status == 200) {
                                        var response = JSON.parse(hr.responseText);
                                        if (response.result === "error") {
                                            popupMessageText.text = '';
                                            for(var i = 0 ; i < response.items.length; ++i){
                                                var currentErrorString = Constants.getErrorString(response.items[i]);
                                                if (response.items[i] === 0){
                                                    nameToolTip.show(currentErrorString);
                                                } if (response.items[i] === 1) {
                                                    passwordToolTip .show(currentErrorString);
                                                } if (response.items[i] === 2) {
                                                    emailToolTip.show(currentErrorString);
                                                }
                                                if (response.items[i] === 3) {
                                                    popupMessageText.text = currentErrorString;
                                                    popupMessage.open();
                                                }
                                            }
                                        } else if (response.result === "success") {
                                            popupMessageText.text = qsTr('You successfully registered! Sign in using you email and password data');
                                            popupMessage.popOnSuccess = true;
                                            popupMessage.open();
                                        }
                                    } else {
                                        popupMessageText.text = hr.status + ' ' + hr.statusText;
                                        popupMessage.open();
                                    }
                                }
                            }
                        } else {
                            popupMessageText.text = Constants.errorCodes[4];
                            popupMessage.open();
                            popup.close();
                        }
                    }
                }
                Item {
                    Layout.fillWidth: true
                }

                Button {
                    id: languageButton
                    icon.source: 'qrc:/icons/resources/icons/language.svg'
                    text: qsTr('English')
                    onClicked: languageMenu.popup()
                    Layout.alignment: Qt.AlignRight
                    Layout.rightMargin: 10
                }
            }
        }
    }

    Popup {
        property bool popOnSuccess: false
        modal: true
        id: popupMessage
        anchors.centerIn: parent
        Label {
            padding: 15
            id: popupMessageText
            font.pixelSize: 22
        }
        onClosed: {
            if (popOnSuccess) {
                stackView.pop();
            }
        }
    }

    LoadingPopup {
        id: popup
    }
}
