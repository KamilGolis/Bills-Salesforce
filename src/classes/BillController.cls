/**
 * Created by trot on 01.07.17.
 */
public with sharing class BillController {

    @AuraEnabled
    public static String getName() {
        return UserInfo.getName();
    }

    @AuraEnabled
    public static Decimal getSummary() {
        return CountingService.getSummary();
    }

    // Get all bills for pagination
    @AuraEnabled
    public static BillsPageWrapper getAllBills(Decimal pageNumber, Integer recordToDisply) {
        Integer pageSize = recordToDisply;
        Integer offset = ((Integer) pageNumber - 1) * pageSize;

        // create a instance of wrapper class.
        BillsPageWrapper obj = new BillsPageWrapper();
        // set the pageSize,Page(Number), total records and accounts List(using OFFSET)
        obj.pageSize = pageSize;
        obj.page = (Integer) pageNumber;
        obj.total = [SELECT count() FROM Bill__c];
        obj.bills = [
                SELECT Id, Name, Category__c, Status__c, Pay_Date__c, Price__c, Description__c, Loan_Holder__r.Name
                FROM Bill__c
                ORDER BY Name
                LIMIT :recordToDisply
                OFFSET :offset
        ];
        // return the wrapper class instance .
        return obj;
    }

    public class BillsPageWrapper {
        @AuraEnabled public Integer pageSize { get; set; }
        @AuraEnabled public Integer page { get; set; }
        @AuraEnabled public Integer total { get; set; }
        @AuraEnabled public List<Bill__c> bills { get; set; }
    }

    // Get additional data like statuses and loan holders
    @AuraEnabled
    public static BillDetailWrapper getBillDetail(Id billId) {
        BillDetailwrapper obj = new BillDetailWrapper();
        obj.statuses = getStatuses(billId);
        Bill__c bill = getBillById(billId);
        obj.currentStatus = bill.Status__c;
        obj.currentLoanHolderName = bill.Loan_Holder__r.Name;
        return obj;
    }

    @AuraEnabled
    public static Bill__c getBillById(Id id) {
        List<Bill__c> bills = [
                SELECT Id, Name, Category__c, Status__c, Pay_Date__c, Price__c, Description__c, Loan_Holder__r.Name
                FROM Bill__c
                WHERE Id = :id
        ];
        Bill__c bill = new Bill__c();
        if (BillsCalendarController.isAccessible('Bill__c')) {
            if (!bills.isEmpty()) {
                return bills[0];
            }
        }
        return null;
    }

    public class BillDetailWrapper {
        @AuraEnabled public List<String> statuses { get; set; }
        @AuraEnabled public List<String> loanHolderName { get; set; }
        @AuraEnabled public String currentStatus { get; set; }
        @AuraEnabled public String currentLoanHolderName { get; set; }
    }

    private static List<String> getStatuses(Id billId) {
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = Bill__c.Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry pickListVal : ple) {
            pickListValuesList.add(pickListVal.getLabel());
        }
        return pickListValuesList;
    }
}