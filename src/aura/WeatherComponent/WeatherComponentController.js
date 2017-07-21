/**
 * Created by trot on 17.07.17.
 */
({
    doInit: function (component, event, helper) {
        helper.reloadData(component, event, helper);
    },

    editSettings: function (component, event, helper) {
        var modalWindow = component.get("v.ShowModal");
        if (modalWindow === false) {
            helper.showModal(component);
        } else {
            helper.hideModal(component);
        }

    },

    okClick: function (component, event, helper) {
        var IPlocationTemp = component.get("v.IPlocationTemp");
        component.set("v.IPlocation", component.get("v.IPlocationTemp"));
        //helper.showInfo("Uwaga!", "Jeszcze nie zaimplementowano.", "warning");
        helper.hideModal(component);
        helper.reloadData(component, event, helper);
    },

    selectBoxVisibility: function (component, event, helper) {
        var ipCheckBoxState = component.get("v.IPlocationTemp");
        if (ipCheckBoxState) {
            helper.showSelectBox(component);
        } else {
            helper.hideSelectBox(component);
        }
    }

})