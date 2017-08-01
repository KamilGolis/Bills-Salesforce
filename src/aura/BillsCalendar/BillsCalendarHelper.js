/**
 * Created by trot on 26.07.17.
 */
({
    getBills: function (component) {
        var month = component.get("v.month");
        component.set("v.bills", component.get("v.allBills"));
    }

})