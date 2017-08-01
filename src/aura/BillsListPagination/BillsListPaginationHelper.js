({
    getBills: function (component, page, recordToDisply) {
        component.getEvent("showSpinner").fire();
        var bills = component.get("v.allBills");
        var length = bills.length;
        var pages = Math.ceil(length / recordToDisply);
        var first = Math.ceil(page * recordToDisply - recordToDisply);
        var last = Math.ceil(page * recordToDisply);
        if (last > length) {
            last === length;
        }
        var result = bills.slice(first, last);

        component.set("v.bills", result);
        component.set("v.page", page);
        component.set("v.total", length);
        component.set("v.pages", pages);

    },
    checkButtonsState: function (component, page, pages) {
        if (pages < 1) {
            component.set("v.nextButton", true);
            component.set("v.prevButton", true);
            component.set("v.page", 0);
        } else {

            if (pages === 1) {
                component.set("v.nextButton", true);
                component.set("v.prevButton", true);
            } else if (page === 1) {
                component.set("v.prevButton", true);
                component.set("v.nextButton", false);
            } else if (page === pages) {
                component.set("v.nextButton", true);
                component.set("v.prevButton", false);
            } else {
                component.set("v.nextButton", false);
                component.set("v.prevButton", false);
            }
        }
    }
})