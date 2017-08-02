/**
 * Created by Trot on 2017-07-05.
 */
({
    //Get record from apex controller when modal window is shown
    //Also recive all statuses for this bill record
    getRecord: function (component, event, helper) {
        var tempRec = component.find("editRecord");
        var cmpId = component.get("v.remoteRecordId");
        tempRec.set("v.recordId", cmpId);
        tempRec.reloadRecord();

        //TODO : DRY!! with BillCreateRecord controller method
        var stats = component.get("c.getBillDetail");
        stats.setParams({
            billId: cmpId
        });
        stats.setCallback(this, function (res) {
            var result = res.getReturnValue();
            component.set("v.avaibleStatuses", result.statuses);
        });
        $A.enqueueAction(stats);
    },
    //Toggle dialog modal window
    toggleDialog: function (component, event, helper) {
        helper.showHideModal(component);
    },
    //Save record method
    saveRecord: function (component, event, helper) {
        var propName = component.find("billName").get("v.value");
        var propPrice = parseFloat(component.find("billPrice").get("v.value"));
        var propStatus = component.find("billStatus").get("v.value");
        var propDesc = component.find("billDescription").get("v.value");

        component.set("v.selectedBill.fields.Name.value", propName);
        component.set("v.selectedBill.fields.Price__c.value", propPrice);
        component.set("v.selectedBill.fields.Status__c.value", propStatus);
        component.set("v.selectedBill.fields.Description__c.value", propDesc);

        var tempRec = component.find("editRecord");
        tempRec.saveRecord($A.getCallback(function (result) {
            if (result.state === "SUCCESS" || result.state === "DRAFT") {
                var event = $A.get("e.c:recordUpdated");
                // event.setParams({"Id": component.get("v.selectedBill.fields.Id.value")});
                event.setParams({"Bill": component.get("v.selectedBill")});
                event.fire();
            } else if (result.state === "ERROR") {
                console.log("ERROR: " + JSON.stringify(result.error));
            } else {
                console.log("Unknown problem, state: " + result.state + " error: " + JSON.stringify(result.error));
            }
        }));
        helper.showInfo(component);
        helper.showHideModal(component);
    }
})