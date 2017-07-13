({
    getBills: function (component, page, recordToDisply) {

        // create a server side action.
        var action = component.get("c.getAllBills");
        // set the parameters to method
        action.setParams({
            "pageNumber": page,
            "recordToDisply": recordToDisply
        });
        // set a call back
        action.setCallback(this, function (a) {
            // store the response return value (wrapper class insatance)
            var result = a.getReturnValue();
            console.log(result);
            // set the component attributes value with wrapper class properties.

            component.set("v.Bills", result.bills);
            component.set("v.page", result.page);
            component.set("v.total", result.total);
            component.set("v.pages", Math.ceil(result.total / recordToDisply));

            component.getEvent("hideSpinner").fire();
        });
        // enqueue the action
        $A.enqueueAction(action);
    },
    changePage: function (component, event) {
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
        this.getBills(component, page, recordToDisplay);
        var pages = component.get("v.pages");
        this.checkButtonsState(component, page, pages);
    },
    checkButtonsState: function (component, page, pages) {
        if (pages === 1) {
            component.set("v.nextButton", true);
            component.set("v.prevButton", true);
        } else if (page === 1) {
            component.set("v.prevButton", true);
            component.set("v.nextButton", false);
        } else if (page === pages) {
            component.set("v.nextButton", true);
            component.set("v.prevButton", false);
        } else {
            component.set("v.nextButton", false);
            component.set("v.prevButton", false);
        }
    }
})