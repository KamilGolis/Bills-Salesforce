/**
 * Created by trot on 01.07.17.
 */
public with sharing class BillController {

	@AuraEnabled
	public static Decimal getSummary() {
		return CountingService.getSummary();
	}

	@AuraEnabled
	public static BillDetailWrapper getBillDetail(Id billId) {
		BillDetailwrapper obj = new BillDetailWrapper();
		obj.statuses = getStatuses();
		obj.loanHolders = getLoanHolders();
		Bill__c bill = getBillById(billId);
		if (bill != null) {
			obj.currentStatus = bill.Status__c;
			obj.currentLoanHolder = bill.Loan_Holder__r;
		} else {
			if (obj.statuses.size() > 0) {
				obj.currentStatus = obj.statuses[0];
			}
			if (obj.loanHolders.size() > 0) {
				obj.currentLoanHolder = obj.loanHolders[0];
			}
		}
		return obj;
	}

	@AuraEnabled
	public static Bill__c getBillById(Id id) {
		
		List<Bill__c> bills = [
				SELECT Id, Name, Category__c, Status__c, Pay_Date__c, Price__c, Description__c, Loan_Holder__r.Name
				FROM Bill__c
				WHERE Id = :id
		];
		if (bills.size() > 0) {
			if (BillsCalendarController.isAccessible('Bill__c')) {
				return bills[0];
			}
		}
		return null;
	}

	public class BillDetailWrapper {
		@AuraEnabled public List<String> statuses {
			get; set;
		}
		@AuraEnabled public List<Loan_Holder__c> loanHolders {
			get; set;
		}
		@AuraEnabled public String currentStatus {
			get; set;
		}
		@AuraEnabled public Loan_Holder__c currentLoanHolder {
			get; set;
		}
	}

	private static List<String> getStatuses() {
		List<String> pickListValuesList = new List<String>();
		Schema.DescribeFieldResult fieldResult = Bill__c.Status__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for (Schema.PicklistEntry pickListVal : ple) {
			pickListValuesList.add(pickListVal.getLabel());
		}
		return pickListValuesList;
	}

	private static List<Loan_Holder__c> getLoanHolders() {
		return [SELECT Id, Name, Address__c, Bank_Account_Number__c, Description__c FROM Loan_Holder__c];
	}
}