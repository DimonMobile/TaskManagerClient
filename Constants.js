var HOST_ADDRESS = "http://127.0.0.1:8000";

function getErrorString(index) {
    switch(index) {
    case 0:
        return qsTr('Username length must be at least 3 symbols and below 20');
    case 1:
        return qsTr('Password length must be at least 8 symbols and below 64')
    case 2:
        return qsTr('Invalid email');
    case 3:
        return qsTr('This email address already used. Try sign in using your creditionals.');
    case 4:
        return qsTr('Passwords are not similar!');
    case 5:
        return qsTr('Invalid email or password.');
    default:
        return qsTr('Unexpected error')
    }
}
