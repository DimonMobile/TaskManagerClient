import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Page {
    id: page

    property int issueIndex: 0

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
            Label {
                text: page.issueIndex + '. issue name'
                font.capitalization: Font.AllUppercase
                font.pointSize: 26
                Layout.fillWidth: true
                horizontalAlignment: Qt.AlignHCenter
            }

            ProgressBar {
                Layout.fillWidth: true
                value: 0.6
            }
            Row {
                Button {
                    text: qsTr('Resolve issue')
                }
                Button {
                    text: qsTr('Log work')
                }
                Button {
                    text: qsTr('Re-estimate')
                }
            }
            Label {
                text: '<b>Project:</b> Some projectname'
            }
            RowLayout {
                Label {
                    text: '<b>Created:</b> Creatorname (05.07.1998)'
                }
                Label {
                    text: '<b>Assignee: </b>'
                }
                Button {
                    text: qsTr('<empty>')
                    highlighted: true
                    flat: true
                }
            }
            Label {
                text: '<b>Logged:</b> 6h of 10h'
            }

            Label {
                Layout.fillHeight: true
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: '
Constant
Description
Qt.MouseFocusReason
A mouse action occurred.
Qt.TabFocusReason
The Tab key was pressed.
Qt.BacktabFocusReason
A Backtab occurred. The input for this may include the Shift or Control keys; e.g. Shift+Tab.
Qt.ActiveWindowFocusReason
The window system made this window either active or inactive.
Qt.PopupFocusReason
The application opened/closed a pop-up that grabbed/released the keyboard focus.
Qt.ShortcutFocusReason
The user typed a labels buddy shortcut
Qt.MenuBarFocusReason
The menu bar took focus.
Qt.OtherFocusReason
Another reason, usually application-specific.

See also Item::activeFocus.'
            }
        }
    }
}
