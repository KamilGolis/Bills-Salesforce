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
        List<Bill__c> bills = [
                SELECT Id, Name, Category__c, Status__c, Pay_Date__c, Price__c, Description__c, Loan_Holder__r.Name
                FROM Bill__c
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
        List<Bill__c> bills = [
                SELECT Id, Name, Category__c, Status__c, Pay_Date__c, Price__c, Description__c, Loan_Holder__r.Name
                FROM Bill__c
                WHERE Id = :id
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
        List<Bill__c> bills = [
                SELECT Id, Name, Category__c, Status__c, Pay_Date__c, Price__c, Description__c, Loan_Holder__r.Name
                FROM Bill__c
                WHERE CALENDAR_MONTH(Pay_Date__c) = :m
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