({
    //Initialize component - get all records
    doInit: function (component, event, helper) {
        helper.getBills(component);
    },
    
    //Update content of v.bills when event from other components fire
    updateContent: function (component, event, helper) {
        var id = event.getParam("Id");
        //TODO implement getting only one bill and check if v.bills has this bill, if not add it.
        helper.getBills(component);
    },
    
	//Method for activating spinner on screen
    showSpinner: function (component, event, helper) {
        console.log('SPINNER EVENT SHOW.')
        // make Spinner attribute true for display loading spinner
        component.set("v.spinner", true);
    },

    //Method for hiding spinner
    hideSpinner: function (component, event, helper) {
        console.log('SPINNER EVENT HIDE.')
        // make Spinner attribute to false for hide loading spinner
        component.set("v.spinner", false);
    },

    monthChanged: function (component, event, helper) {
        var month = event.getParam("month");
        console.log("Recived month = " + month);
        helper.getBills(component, month);
    }
})