function loadProjectsToModel(model, listView, indicator) {
    var hr = new XMLHttpRequest();
    hr.open("POST", Constants.HOST_ADDRESS + "/projects");
    hr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    hr.onreadystatechange = function() {
        if (hr.readyState == 4) {
            var responseObject = JSON.parse(hr.responseText);
            var items = responseObject.items;
            model.clear();
            for(var i = 0 ; i < items.length; ++i) {
                model.append({'name': items[i]});
            }
            indicator.visible = false;
            listView.visible = true;
        }
    }
    indicator.visible = true;
    listView.visible = false;
    hr.send("token=" + encodeURIComponent(Settings.token()));
}
