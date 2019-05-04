function loadProjectsToModel(model, listView, indicator, disableView = true) {
    var hr = new XMLHttpRequest();
    hr.open("POST", Constants.HOST_ADDRESS + "/projects");
    hr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    hr.onreadystatechange = function() {
        if (hr.readyState === 4) {
            var responseObject = JSON.parse(hr.responseText);
            var items = responseObject.items;
            model.clear();
            for(var i = 0 ; i < items.length; ++i) {
                model.append({'name': items[i]});
            }
            indicator.visible = false;
            if (disableView){
                listView.visible = true;
            }
        }
    }

    indicator.visible = true;
    if (disableView) {
        listView.visible = false;
    }
    hr.send("token=" + encodeURIComponent(Settings.token()));
}


function createIssue(name, description, estimate, project, type, button, indicator, errorLabel) {
    var hr = new XMLHttpRequest();
    hr.open("POST", Constants.HOST_ADDRESS + "/create_issue");
    hr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    hr.onreadystatechange = function() {
        if (hr.readyState === 4) {
            // return ui controls
            indicator.visible = false;
            button.enabled = true;
            console.log(hr.responseText);
            // json processing
            var responseObject = JSON.parse(hr.responseText);
            if (responseObject.result === 'success') {
                errorLabel.color = "green";
                errorLabel.text = qsTr('Issue created');
            } else {
                errorLabel.text = Constants.getErrorString(responseObject.error_code);
                errorLabel.color = "red";
            }
            errorLabel.visible = true;
        }
    }
    indicator.visible = true;
    button.enabled = false;
    errorLabel.visible = false;
    hr.send("token=" + encodeURIComponent(Settings.token()) +
            "&name=" + encodeURIComponent(name) +
            "&description=" + encodeURIComponent(description) +
            "&project=" + encodeURIComponent(project) +
            "&type=" + encodeURIComponent(type) +
            "&estimate=" + encodeURIComponent(estimate));
}
