/**
 * Created by Trot on 2017-07-05.
 */
({
    //Get record from apex controller when modal window is shown
    //Also recive all statuses for this bill record
    getRecord: function (component, event, helper) {
        helper.getRecord(component, event);
    },
    //Toggle dialog modal window
    toggleDialog: function (component, event, helper) {
        // helper.getRecord(component, event);
        helper.showHideModal(component);
    },
    //Save record method
    saveRecord: function (component, event, helper) {
        helper.saveRecord(component, event);
        // helper.showInfo(component);
        helper.showHideModal(component);
        helper.showToast(component, event);
    },
    saveDate: function (component, event, helper) {
        var params = event.getParam("arguments");
        if (params) {
            //TODO This is not working. Component fields are not visible. I don't know why.
            component.find("editRecord").set("v.billsFields.Pay_Date__c", params.newDate);
            helper.saveRecord(component, event);
        }
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

    }
})