/**
 * Created by Trot on 2017-07-05.
 */
({
    //Helper method for manipilation of modal window showing and hiding
     showHideModal : function(component) {
        var modal = component.find("editDialog");
        $A.util.toggleClass(modal, 'slds-fade-in-open');
        var overlay = component.find("overlay");
        $A.util.toggleClass(overlay, 'slds-backdrop--open');
        component.set("v.showDialog", "false");
     },

    //Info window - toast - on top of page when record is saved
    showInfo : function (component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Sukces!",
            "message": 'Zaktualizowaliśmy rachunek : ' + component.get('v.selectedBill.fields.Name.value')
            + '\r\n Kwota : ' + component.get('v.selectedBill.fields.Price__c.value')
            + '\r\n Status płatności : ' + component.get('v.selectedBill.fields.Status__c.value'),
            "type": "success"
        });
        toastEvent.fire();
    }
})