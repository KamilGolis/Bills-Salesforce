({
    doInit: function (component, event, helper) {
        component.getEvent("showSpinner").fire();
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
        helper.changePage(component, event);
    },

    newRecord: function (component, event, helper) {
        component.set("v.toggleNewRecordModal", true);
    }
})