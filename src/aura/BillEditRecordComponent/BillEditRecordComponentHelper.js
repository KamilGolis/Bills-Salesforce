/**
 * Created by Trot on 2017-07-05.
 */
({
    //Helper method for manipilation of modal window showing and hiding
    showHideModal: function (component) {
        var modal = component.find("editDialog");
        $A.util.toggleClass(modal, 'slds-fade-in-open');
        var overlay = component.find("overlay");
        $A.util.toggleClass(overlay, 'slds-backdrop--open');
        component.set("v.showDialog", "false");
    },
    getRecord: function (component, event) {
        var tempRec = component.find("editRecord");
        var cmpId = component.get("v.remoteRecordId");
        tempRec.set("v.recordId", cmpId);
        tempRec.reloadRecord();
        var stats = component.get("c.getBillDetail");
        stats.setParams({
            billId: cmpId
        });
        stats.setCallback(this, function (res) {
            var state = res.getState();

            if (state === "SUCCESS") {
                var result = res.getReturnValue();
                component.set("v.avaibleStatuses", result.statuses);
                component.set("v.loanHolders", result.loanHolders);
                component.set("v.currentLoanHolder", result.currentLoanHolder);
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
        $A.enqueueAction(stats);
    },
    saveRecord: function (component, event) {
        var tempRec = component.find("editRecord");
        tempRec.saveRecord($A.getCallback(function (result) {
            if (result.state === "SUCCESS" || result.state === "DRAFT") {
                var event = $A.get("e.c:recordUpdated");
                event.setParams({"Bill": component.get("v.selectedBill")});
                event.fire();
            } else if (result.state === "ERROR") {
                console.log("ERROR: " + JSON.stringify(result.error));
            } else {
                console.log("Unknown problem, state: " + result.state + " error: " + JSON.stringify(result.error));
            }
        }));
    },
    deleteRecord: function(component, event, helper) {
        var tempRec = component.find("editRecord");
        tempRec.deleteRecord($A.getCallback(function(deleteResult) {
            if (deleteResult.state === "SUCCESS" || deleteResult.state === "DRAFT") {
                console.log("Record deleted.");
                 var event = $A.get("e.c:recordUpdated");
                 event.setParams({"Bill": component.get("v.selectedBill")});
                 event.fire();
            } else if (deleteResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (deleteResult.state === "ERROR") {
                console.log('Problem deleting record, error: ' + JSON.stringify(deleteResult.error));
            } else {
                console.log('Unknown problem, state: ' + deleteResult.state + ', error: ' + JSON.stringify(deleteResult.error));
            }
        }));
    },
    showToast:function (component, event) {
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.setParams({
                "title": "Sukces!",
                "message": 'Zaktualizowaliśmy rachunek : ' + component.get('v.selectedBill.fields.Name.value')
                + '\r\n Kwota : ' + component.get('v.selectedBill.fields.Price__c.value')
                + '\r\n Status płatności : ' + component.get('v.selectedBill.fields.Status__c.value'),
                "type": "success"
            });
            toastEvent.fire();
        } else {
            alert('Zaktualizowaliśmy rachunek : ' + component.get('v.selectedBill.fields.Name.value')
                + '\r\n Kwota : ' + component.get('v.selectedBill.fields.Price__c.value')
                + '\r\n Status płatności : ' + component.get('v.selectedBill.fields.Status__c.value'));
        }
    }
})