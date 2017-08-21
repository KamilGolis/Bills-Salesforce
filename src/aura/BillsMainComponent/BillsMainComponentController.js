({
    //Initialize component - get all records
    doInit: function (component, event, helper) {
        helper.getBills(component);
    },
    
    //Update content of v.bills when event from other components fire
    updateContent: function (component, event, helper) {
        var month = component.get("v.month");
        var year = component.get("v.year");
        helper.getBills(component, month, year);
    },
    
	//Method for activating spinner on screen
    showSpinner: function (component, event, helper) {
        // make Spinner attribute true for display loading spinner
        component.set("v.spinner", true);
    },

    //Method for hiding spinner
    hideSpinner: function (component, event, helper) {
        // make Spinner attribute to false for hide loading spinner
        component.set("v.spinner", false);
    },

    monthChanged: function (component, event, helper) {
        var month = event.getParam("month");
        var year = event.getParam("year");
        helper.getBills(component, month, year);
    }
})