({
    //This function is similar to BillEditRecord component Controller method
    //TODO : DRY !!
	doInit: function (component, event, helper) {
        var stats = component.get("c.getBillDetail");
        
        stats.setCallback(this, function (res) {
            var result = res.getReturnValue();
            component.set("v.avaibleStatuses", result.statuses);
        });
        $A.enqueueAction(stats);       
	}
})