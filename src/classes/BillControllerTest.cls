@IsTest
private class BillControllerTest {

	@IsTest static void TestGetSummary() {
		List<Bill__c> bills = createTestRecords();

		bills = [SELECT Id, Name, Loan_Holder__c, Price__c FROM Bill__c];
		Decimal sumOfBills = 0;
		for (Bill__c b : bills) {
			sumOfBills += b.Price__c;
		}
		Decimal summary = BillController.getSummary();
		System.debug('CS =' + summary);
		System.debug('SEL =' + sumOfBills);

		System.assertEquals(300, summary);
		System.assertEquals(sumOfBills, summary);
		System.assertEquals(300, sumOfBills);

	}

	@IsTest static void TestGetBillDetail() {
		List<Bill__c> bills = createTestRecords();
		List<BillController.BillDetailWrapper> billsDetail = new List<BillController.BillDetailWrapper>();
		for (Bill__c bill : bills) {
			billsDetail.add(BillController.getBillDetail(bill.Id));
		}

		System.assertEquals(bills.size(), billsDetail.size());

		Schema.DescribeFieldResult fieldResult = Bill__c.Status__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

		Integer loanHoldersCount = [SELECT Id, Name FROM Loan_Holder__c].size();
		for (BillController.BillDetailWrapper bill : billsDetail) {
			System.assertEquals(ple.size(), bill.statuses.size());
			System.assertEquals(loanHoldersCount, bill.loanHolders.size());
			System.assertEquals('Inne', bill.currentStatus);
			System.assertEquals('Test Loan', bill.currentLoanHolder.Name);
		}

	}

	@IsTest static void TestGetBillByIdWithoutId() {
		List<Bill__c> bills = createTestRecords();
		BillController.BillDetailWrapper billsDetail = BillController.getBillDetail('000000000000000000');
		System.assertEquals('Test Loan', billsDetail.currentLoanHolder.Name);

		Integer loanHoldersCount = [SELECT Id, Name FROM Loan_Holder__c].size();
		System.assertEquals(loanHoldersCount, billsDetail.loanHolders.size());
		System.assertEquals('Do zapłaty', billsDetail.currentStatus);
	}

	@IsTest static void TestGetBillById() {
		List<Bill__c> bills = createTestRecords();

		for (Bill__c bill : bills) {
			System.assertEquals(bill.Id, BillController.getBillById(bill.Id).Id);
			System.assertEquals(bill.Name, BillController.getBillById(bill.Id).Name);
			System.assertEquals(bill.Loan_Holder__c, BillController.getBillById(bill.Id).Loan_Holder__c);
			System.assertEquals(bill.Price__c, BillController.getBillById(bill.Id).Price__c);
			System.assertEquals(bill.Status__c, BillController.getBillById(bill.Id).Status__c);
		}
	}

	//Helper method for creating dummy records
	static List<Bill__c> createTestRecords() {
		Bill__c bill = new Bill__c();
		List<Bill__c> bills = new List<Bill__c>();
		Loan_Holder__c loanHolder = new Loan_Holder__c();

		loanHolder.Name = 'Test Loan';
		insert loanHolder;

		bill.Name = 'Test bill 1';
		bill.Loan_Holder__c = loanHolder.Id;
		bill.Price__c = 100;
		bill.Pay_Date__c = Date.today();
		bill.Status__c = 'Inne';
		bills.add(bill);

		bill = new Bill__c();
		bill.Name = 'Test bill 2';
		bill.Loan_Holder__c = loanHolder.Id;
		bill.Price__c = 200;
		bill.Pay_Date__c = Date.today();
		bill.Status__c = 'Inne';
		bills.add(bill);

		insert bills;
		return bills;
	}
}