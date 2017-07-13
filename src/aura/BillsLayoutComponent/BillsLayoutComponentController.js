({
    //Method for activating spinner on screen
    showSpinner: function (component, event, helper) {
        console.log('SPINNER EVENT SHOW.')
        // make Spinner attribute true for display loading spinner
        component.set("v.Spinner", true);
    },

    //Method for hiding spinner
    hideSpinner: function (component, event, helper) {
        console.log('SPINNER EVENT HIDE.')
        // make Spinner attribute to false for hide loading spinner
        component.set("v.Spinner", false);
    }
})