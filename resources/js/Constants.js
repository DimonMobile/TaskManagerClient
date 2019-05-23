var HOST_ADDRESS = "http://192.168.100.21:8000";

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
    case 6:
        return qsTr('This projectname already used!');
    case 7:
        return qsTr('Project name must have at least 3 and below 30 symbols');
    case 8:
        return qsTr('Invalid issue name length');
    case 9:
        return qsTr('Invalid issue description length');
    case 10:
        return qsTr('Estimate must have positive length')
    case 11:
        return qsTr('Project doesn\'t exists')
    case 12:
        return qsTr('Save error(try again latter)')
    case 13:
        return qsTr('Access denied')
    case 14:
        return qsTr('No such users')
    case 15:
        return qsTr('Too many variants')
    default:
        return qsTr('Unexpected error')
    }
}
