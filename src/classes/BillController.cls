/**
 * Created by trot on 01.07.17.
 */
public with sharing class BillController {

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

	public class BillsWrapper {
		@AuraEnabled public String Id {
			get; set;
		}
		@AuraEnabled public String title {
			get; set;
		}
		@AuraEnabled public DateTime startDateTime {
			get; set;
		}
		@AuraEnabled public DateTime endDateTime {
			get; set;
		}
		@AuraEnabled public String description {
			get; set;
		}
		@AuraEnabled public String owner {
			get; set;
		}

//		public BillsWrapper(String i, String t, DateTime s, DateTime e, String d, String o) {
//			this.Id = i;
//			this.title = t;
//			this.startDateTime = s;
//			this.endDateTime = e;
//			this.description = d;
//			this.owner = o;
//		}

		public BillsWrapper() {

		}
	}

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
	public static BillDetailWrapper getDetailOnly() {
		BillDetailwrapper obj = new BillDetailWrapper();
		obj.statuses = getStatuses();
		obj.loanHolders = getLoanHolders();
		obj.currentStatus = obj.statuses[0];
		obj.currentLoanHolder = obj.loanHolders[0];
		return obj;
	}

	@AuraEnabled
	public static Bill__c getBillById(Id id) {
		Bill__c bill = getDataById(id);
		if (isAccessible('Bill__c')) {
			return bill;
		}
		return null;
	}

	@AuraEnabled
	public static BillsWrapper getBillByIdWrapper(Id id) {
		return mapValues(getBillById(id));
	}

	@AuraEnabled
	public static List<BillsWrapper> getBillsByMonth(Integer month) {
		List<BillsWrapper> outputBills = new List<BillsWrapper>();
		List<Bill__c> bills = getDataByMonth(Integer.valueOf(month));
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
	public static List<BillsWrapper> getAllBills() {
		List<BillsWrapper> outputBills = new List<BillsWrapper>();
		List<Bill__c> bills = getData();

		if (isAccessible('Bill__c')) {
			for (Bill__c obj : bills) {
				BillsWrapper bill = new BillsWrapper();
				bill = mapValues(obj);
				outputBills.add(bill);
			}
		}
		return outputBills;
	}

	private static List<Bill__c> getData() {
		Id ownerId = UserInfo.getUserId();
		List<Bill__c> bills = [
				SELECT Id, Name, Category__c, Status__c, Pay_Date__c, Price__c, Description__c, Loan_Holder__r.Name
				FROM Bill__c
				WHERE OwnerId = :ownerId
		ORDER BY Name
		];
		return bills;
	}

	private static Bill__c getDataById(Id id) {
		Id ownerId = UserInfo.getUserId();
		List<Bill__c> bills = [
				SELECT Id, Name, Category__c, Status__c, Pay_Date__c, Price__c, Description__c, Loan_Holder__r.Name
				FROM Bill__c
				WHERE Id = :id AND OwnerId = :ownerId
		];
		if (bills.size() > 0) {
			return bills[0];
		}
		return null;
	}

	private static List<Bill__c> getDataByMonth(Integer month) {
		Id ownerId = UserInfo.getUserId();
		List<Bill__c> bills = [
				SELECT Id, Name, Category__c, Status__c, Pay_Date__c, Price__c, Description__c, Loan_Holder__r.Name, OwnerId
				FROM Bill__c
				WHERE CALENDAR_MONTH(Pay_Date__c) = :month AND OwnerId = :ownerId
		ORDER BY Name
		];
		return bills;
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