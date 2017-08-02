({
    //Get all bills
    getBills: function (component, month) {
        if (!month) {
            month = new Date().getMonth() + 1;
            component.set("v.month", month);
        }
        var action = component.get("c.getBillsByMonth");
        action.setParams({"month": month});
        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                //For debug
                component.set("v.bills", response.getReturnValue());
                component.set("v.gotBills", true);

            } else if (state === "INCOMPLETE") {
                // do something
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})