({
    doInit: function (component, event, helper) {
        helper.doInit(component, event);
    },
    recordUpdated: function (component, event, helper) {
            var eventParams = event.getParams();
            if (eventParams.changeType === "CHANGED") {
                // get the fields that are changed for this record
                var changedFields = eventParams.changedFields;
            } else if (eventParams.changeType === "LOADED") {
                // record is loaded in the cache
            } else if (eventParams.changeType === "REMOVED") {
                // record is deleted and removed from the cache
            } else if (eventParams.changeType === "ERROR") {
                console.log('Error: ' + component.get("v.error"));
            }

    },
    toggleDialog: function (component, event, helper) {
            helper.showHideModal(component);
            helper.doInit(component,event);
    },
    saveRecord: function (component, event, helper) {
            helper.showHideModal(component);
            var tempRec = component.find("editRecord");
            tempRec.saveRecord($A.getCallback(function (result) {
                if (result.state === "SUCCESS" || result.state === "DRAFT") {
                    var event = $A.get("e.c:recordUpdated");
                    event.setParams({"Bill": component.get("v.selectedBill")});
                    event.fire();
                } else if (result.state === "ERROR") {
                    console.log("ERROR: ");
                     console.log(result.error);
                } else {
                    console.log("Unknown problem, state: " + result.state + " error: " + JSON.stringify(result.error));
                }
            }));
    },
})