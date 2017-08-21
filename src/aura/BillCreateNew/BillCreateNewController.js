({
    doInit: function (component, event, helper) {
        var stats = component.get("c.getBillDetail");
                stats.setCallback(this, function (res) {
                    var state = res.getState();

                    if (state === "SUCCESS") {
                        var result = res.getReturnValue();
                        component.set("v.avaibleStatuses", result.statuses);
                        component.set("v.loanHolders", result.loanHolders);
                        component.set("v.currentLoanHolder", result.currentLoanHolder);
                        component.set("v.billsFields.Loan_Holder__c", result.currentLoanHolder.Id);
                        component.set("v.billsFields.Status__c", result.currentStatus);
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

        var tempRec = component.find("editRecord");
        tempRec.getNewRecord(
        "Bill__c",
        null,
        false,
        $A.getCallback(function() {
            var rec = component.get("v.selectedBill");
            var error = component.get("v.error");
            if (error || (rec === null)) {
                console.log("Error initializing record template : " + error);
                return;
            }
            console.log("Record template initialized : "+ rec.sobjectType);
            })
        );


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