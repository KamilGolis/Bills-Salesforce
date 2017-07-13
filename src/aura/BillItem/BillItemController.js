/**
 * Created by Trot on 2017-07-04.
 */
({
    //navigate to record - old method based on SF api
    navToRecord: function (component, event, helper) {
        var navEvent = $A.get("e.force:navigateToSObject");
        navEvent.setParams({
            "recordId": component.get("v.billId")
        });
        navEvent.fire();
    },

    //Edit record method, geting Id and setting modal flag to show window
    editRecord: function (component, event, helper) {
        var recId = component.get("v.billId");
        component.set("v.remoteRecordId", recId);
        component.set("v.showDialog", "true");
    }
})