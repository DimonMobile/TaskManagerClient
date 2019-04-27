import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

import "Constants.js" as Constants

Item {
    LoadingPopup {
        id: popup
    }

    Popup {
        id: popupMessage
        anchors.centerIn: parent
        modal: true
        Label {
            id: popupMessageLabel
        }
    }

    Page {
        anchors.fill: parent
        contentItem: Item{
            anchors.fill: parent
            Column{
                anchors.centerIn: parent
                spacing: 25

                TextField {
                    id: emailTextField
                    placeholderText: qsTr("Email")
                    width: 320
                }

                TextField {
                    id: passwordTextField
                    placeholderText: qsTr("Password")
                    echoMode: TextInput.Password
                    width: 320
                }

                Row {
                    spacing: 30
                    Button {
                        highlighted: true
                        text: qsTr("Sign in")
                        onClicked: {
                            popup.open();
                            var xr = new XMLHttpRequest();
                            xr.open("POST", Constants.HOST_ADDRESS + '/user_data');
                            xr.onreadystatechange = function() {
                                if (xr.readyState == 4) {
                                    popup.close();
                                    var responseObject = JSON.parse(xr.responseText);
                                    if (responseObject.result === 'success') {
                                        popupMessageLabel.text = responseObject.user.name + "\r\n" + responseObject.user.language;
                                        //popupMessage.open();
                                        stackView.push(Qt.createComponent("qrc:/MainPage.qml"));
                                    } else { // handling error
                                    }
                                }
                            }
                            xr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');

                            var password = encodeURIComponent(passwordTextField.text);
                            var email = encodeURIComponent(emailTextField.text);

                            xr.send('email=' + email + '&password=' + password);
                        }
                    }
                    Button {
                        text: qsTr("Sign up")
                        onClicked: stackView.push(Qt.createComponent("qrc:/RegistrationPage.qml"))
                    }
                }
            }
        }

    }
}
