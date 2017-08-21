({
    doInit: function (component, event) {
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

                    var stats = component.get("c.getDetailOnly");
                                        stats.setCallback(this, function (res) {
                                            var state = res.getState();

                                            if (state === "SUCCESS") {
                                                var result = res.getReturnValue();
                                                var statuses = result.statuses;
                                                var loanHolders = result.loanHolders;
                                                var currentLoanHolder = result.currentLoanHolder;
                                                var currentStatus = result.currentStatus;
                                                component.set("v.avaibleStatuses", statuses);
                                                component.set("v.loanHolders", loanHolders);
//                                                component.set("v.billsFields.Loan_Holder__c", currentLoanHolder);
//                                                component.set("v.billsFields.Status__c", currentStatus);
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
                    })
                );


    },
	showHideModal: function (component) {
            var modal = component.find("editDialog");
            $A.util.toggleClass(modal, 'slds-fade-in-open');
            var overlay = component.find("overlay");
            $A.util.toggleClass(overlay, 'slds-backdrop--open');
            component.set("v.showDialog", "false");
    }
})