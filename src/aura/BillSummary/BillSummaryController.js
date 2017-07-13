/**
 * Created by Trot on 2017-07-03.
 */
({ doInit : function (component, event, helper) {
    var summary = component.get("c.getSummary");
    summary.setCallback(this, function (res) {
        component.set("v.summary", res.getReturnValue());
    });

    $A.enqueueAction(summary);
}})