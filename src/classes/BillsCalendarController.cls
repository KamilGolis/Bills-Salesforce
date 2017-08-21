/**
 * Created by trot on 26.07.17.
 */

public with sharing class BillsCalendarController {

    public class BillsWrapper {
        @AuraEnabled public String Id { get; set; }
        @AuraEnabled public String title { get; set; }
        @AuraEnabled public DateTime startDateTime { get; set; }
        @AuraEnabled public DateTime endDateTime { get; set; }
        @AuraEnabled public String description { get; set; }
        @AuraEnabled public String owner { get; set; }

        public BillsWrapper(String i, String t, DateTime s, DateTime e, String d, String o) {
            this.Id = i;
            this.title = t;
            this.startDateTime = s;
            this.endDateTime = e;
            this.description = d;
            this.owner = o;
        }

        public BillsWrapper() {

        }
    }

    @AuraEnabled
    public static List<BillsWrapper> getAllBills() {
        List<BillsWrapper> outputBills = new List<BillsWrapper>();
        Id ownerId = UserInfo.getUserId();
        List<Bill__c> bills = [
                SELECT Id, Name, Category__c, Status__c, Pay_Date__c, Price__c, Description__c, Loan_Holder__r.Name
                FROM Bill__c
                WHERE OwnerId = :ownerId
                ORDER BY Name
        ];

        if (isAccessible('Bill__c')) {
            for (Bill__c obj : bills) {
                BillsWrapper bill = new BillsWrapper();
                bill = mapValues(obj);
                outputBills.add(bill);
            }
        }
        return outputBills;
    }

    @AuraEnabled
    public static BillsWrapper getBillById(Id id) {
        Id ownerId = UserInfo.getUserId();
        List<Bill__c> bills = [
                SELECT Id, Name, Category__c, Status__c, Pay_Date__c, Price__c, Description__c, Loan_Holder__r.Name, OwnerId
                FROM Bill__c
                WHERE Id = :id AND OwnerId = :ownerId
        ];
        BillsWrapper bill = new BillsWrapper();
        if (isAccessible('Bill__c')) {
            if (!bills.isEmpty()) {
                bill = mapValues(bills[0]);
            }
        }
        return bill;
    }

    @AuraEnabled
    public static List<BillsWrapper> getBillsByMonth(Integer month) {
        List<BillsWrapper> outputBills = new List<BillsWrapper>();
        Integer m = Integer.valueOf(month);
        Id ownerId = UserInfo.getUserId();
        List<Bill__c> bills = [
                SELECT Id, Name, Category__c, Status__c, Pay_Date__c, Price__c, Description__c, Loan_Holder__r.Name, OwnerId
                FROM Bill__c
                WHERE CALENDAR_MONTH(Pay_Date__c) = :m AND OwnerId = :ownerId
                ORDER BY Name
        ];

        if (isAccessible('Bill__c')) {
            for (Bill__c obj : bills) {
                BillsWrapper bill = new BillsWrapper();
                bill = mapValues(obj);
                outputBills.add(bill);
            }
        }
        return outputBills;
    }

    @AuraEnabled
    public static BillsWrapper updateBill(String jsonObject) {
        BillsWrapper bill = (BillsWrapper) JSON.deserialize(jsonObject, BillsWrapper.class);
        Bill__c newBill = new Bill__c();

        if (bill.Id != null && isAccessible('Bill__c', 'Id')) {
            newBill.Id = bill.Id;
        }
        if (isAccessible('Bill__c', 'Category__c')) {
            //TODO Not implemented yet on client side
            newBill.Category__c = 'Inne';
        }
        if (isAccessible('Bill__c', 'Description__c')) {
            newBill.Description__c = bill.description;
        }
        if (isAccessible('Bill__c', 'Name')) {
            newBill.Name = bill.title;
        }
        if (isAccessible('Bill__c', 'Loan_Holder__c')) {
            //TODO Not implemented yet on client side
            newBill.Loan_Holder__c = 'a0J0Y0000023X5PUAU';
        }
        if (isAccessible('Bill__c', 'Pay_Date__c')) {
            newBill.Pay_Date__c = Date.valueOf(bill.startDateTime);
        }
        if (isAccessible('Bill__c', 'Price__c')) {
            //TODO Not implemented yet on client side
            newBill.Price__c = 100;
        }
        if (isAccessible('Bill__c', 'Status__c')) {
            //TODO Not implemented yet on client side
            newBill.Status__c = 'Zapłacone';
        }
        try {
            upsert newBill;
            BillsWrapper bw = new BillsWrapper(newBill.Id,
                    newBill.Name,
                    Date.valueOf(newBill.Pay_Date__c),
                    Date.valueOf(newBill.Pay_Date__c),
                    newBill.Description__c,
                    UserInfo.getName()
            );
            return bw;
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }
    }

    private static BillsWrapper mapValues(Bill__c obj) {
        BillsWrapper bill = new BillsWrapper();
        Datetime dt;
        bill.Id = obj.Id;
        bill.title = '(' + obj.Status__c + ') ' + obj.Name;
        bill.startDateTime = obj.Pay_Date__c;
        bill.endDateTime = obj.Pay_Date__c;
        bill.description = obj.Description__c;
        bill.owner = UserInfo.getName();
        return bill;
    }

    public static Boolean isAccessible(String sObjectType, String fieldName) {
        SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);
        Map<String, SObjectField> fields = schemaType.getDescribe().fields.getMap();
        DescribeFieldResult fieldDescribe = fields.get(fieldName).getDescribe();
        return fieldDescribe.isAccessible();
    }
    public static Boolean isAccessible(String sObjectType) {
        SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);
        return schemaType.getDescribe().isAccessible();
    }

}