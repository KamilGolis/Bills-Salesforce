({
    showModal: function (component) {
        component.set("v.ShowModal", true);
        var IPlocation = component.get("v.IPlocation");
        component.set("v.IPlocationTemp", IPlocation);
        //If chceckbox not chcecked then show city select
        if (IPlocation) {
            this.showSelectBox(component);
        } else {
            this.hideSelectBox(component);
        }
    },
    hideModal: function (component) {
        component.set("v.ShowModal", false);
    },
    showInfo: function (title, text, type) {
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.setParams({
                "title": title,
                "message": text,
                "type": type
            });
            toastEvent.fire();
        } else {
            alert(text);
        }
    },
    reloadData: function (component, event, helper) {
        //check if option IP is checked
        var optionIP = component.get("v.IPlocation");
        //fetch data from browser if checked
        if (optionIP) {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function (position) {
                    var lat = position.coords.latitude;
                    var lon = position.coords.longitude;
                    component.set("v.Lat", lat);
                    component.set("v.Lon", lon);
                    console.log("Lat=" + lat + " | Lon=" + lon);
                    var action = component.get("c.getWeatherForLocation");
                    action.setParams({"lat": lat, "lon": lon});
                    helper.fetchData(component, action);
                });
            }
        } else {
            //If user does not want to track his location
            this.showInfo("Info.", "Lokalizacja na podstawie IP wyłączona", "info");

            var city = component.find("selectCity").get("v.value");

            var action = component.get("c.getWeatherForCity");
            action.setParams({"city": city, "country": "Poland"});
            helper.fetchData(component, action);
        }
    },
    fetchData: function (component, action) {
        action.setCallback(this, function (res) {
            var result = res.getReturnValue();
            component.set("v.Weather", result);
            console.log(result);
        });
        $A.enqueueAction(action);
    },
    showSelectBox: function (component) {
        var selectBox = component.find("selectCity");
        $A.util.addClass(selectBox, "slds-hide");
        $A.util.addClass(selectBox, "slds-modal_large");
    },
    hideSelectBox: function (component) {
        var selectBox = component.find("selectCity");
        $A.util.removeClass(selectBox, "slds-hide");
        $A.util.removeClass(selectBox, "slds-modal_large");
    }
})