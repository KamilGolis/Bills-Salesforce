({
    doInit: function (component, event, helper) {
        component.set("v.total", 0);
        component.set("v.pages", 0);
        component.set("v.page", 0);
        // this function call on the component load first time
        // get the page Number if it's not define, take 1 as default
        var page = component.get("v.page") || 1;
        // get the select option (drop-down) values.
        var recordToDisply = component.find("recordSize").get("v.value");
        // call the helper function
        helper.getBills(component, page, recordToDisply);
        var pages = component.get("v.pages");
        helper.checkButtonsState(component, page, pages);
    },

    changePage: function (component, event, helper) {
        var buttonPressed = event.getSource().getLocalId();
        var page;
        var recordToDisplay;
        if (buttonPressed === "prevbtn" || buttonPressed === "nextbtn") {
            page = component.get("v.page") || 1;
            page = buttonPressed === "prevbtn" ? (page - 1) : (page + 1);
        } else if (buttonPressed === "lastbtn") {
            page = component.get("v.pages");
        } else {
            page = 1;
        }
        recordToDisplay = component.find("recordSize").get("v.value");
        helper.getBills(component, page, recordToDisplay);
        var pages = component.get("v.pages");
        helper.checkButtonsState(component, page, pages);

        $(document).ready(function () {
            component.getEvent("hideSpinner").fire();
        });
    },

    newRecord: function (component, event, helper) {
        component.set("v.toggleNewRecordModal", true);
    }
})