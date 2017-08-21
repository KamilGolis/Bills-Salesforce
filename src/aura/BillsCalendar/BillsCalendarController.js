/**
 * Created by trot on 26.07.17.
 */
({
    scriptsLoaded: function (component, event, helper) {
        helper.getBills(component);
    },
    renderCalendar: function (component, event, helper) {
        var bills = component.get("v.bills");
        $(document).ready(function () {
            var billsArray = [];
            $.each(bills, function (index, value) {
                var newBill = {
                    id: value.Id,
                    title: value.title,
                    start: moment(value.startDateTime),
                    end: moment(value.endDateTime),
                    description: value.description,
                    owner: value.owner
                }
                // console.log(newBill);
                billsArray.push(newBill);
            });
            var calendarButtons = component.get('v.calendarButtons');
            $('#calendar').fullCalendar({
                header: {
                    left: 'today prev,next',
                    center: 'title',
                    right: calendarButtons
                },
                defaultDate: moment().format("YYYY-MM-DD"),
                navLinks: false, // can click day/week names to navigate views
                editable: true,
                eventLimit: true, // allow "more" link when too many events
                weekends: component.get('v.weekends'),
                eventBackgroundColor: component.get('v.billsBackgroundColor'),
                eventBorderColor: component.get('v.billsBorderColor'),
                eventTextColor: component.get('v.billsTextColor'),
                events: billsArray,
                eventClick: function (calEvent, jsEvent, view) {
                    component.set("v.remoteRecordId", calEvent.id);
                    component.set("v.editRecord", true);
                },
                eventDrop: function (event, delta, revertFunc) {
                   //TODO
                },
                viewRender: function (view, element) {
                    component.getEvent("showSpinner").fire();
                    var month = $('#calendar').fullCalendar('getDate').format("M");
                    var year = $('#calendar').fullCalendar('getDate').format("Y");
                    component.set("v.month", month);
                    component.set("v.year", year);
                    var compEvent = component.getEvent("monthChanged");
                    compEvent.setParams({"month": month, "year": year});
                    compEvent.fire();
                }
            });
        });
    },
    collectionChanged: function (component, event, helper) {
        $('#calendar').fullCalendar('removeEvents');
        helper.getBills(component);
        var billsArray = [];
        $.each(component.get("v.bills"), function (index, value) {
            var newBill = {
                id: value.Id,
                title: value.title,
                start: moment(value.startDateTime),
                end: moment(value.endDateTime),
                description: value.description,
                owner: value.owner
            }
            billsArray.push(newBill);
        });
        $('#calendar').fullCalendar('addEventSource', billsArray);
        $('#calendar').fullCalendar('rerenderEvents');
        component.getEvent("hideSpinner").fire();
    }

})