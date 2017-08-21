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

	@IsTest static void TestGetBillByIdNull() {
		Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
		User u2 = new User(Alias = 'newUser', Email = 'newtestuser@testorg.com',
				EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
				LocaleSidKey = 'en_US', ProfileId = p.Id,
				TimeZoneSidKey = 'America/Los_Angeles', UserName = 'newtestuser@testorg.com');

		System.runAs(u2) {
			List<Bill__c> bills = createTestRecords();
			System.assertEquals(null, BillController.getBillById('000000000000000000'));
			System.assertEquals(false, BillController.isAccessible('Bill__c', 'Name'));
			System.assertEquals(false, BillController.isAccessible('Bill__c', 'Status__c'));
			System.assertEquals(false, BillController.isAccessible('Bill__c', 'Description__c'));
			System.assertEquals(false, BillController.isAccessible('Bill__c', 'Pay_Date__c'));
		}
	}

	@IsTest static void TestGetDetailOnly() {
		List<Bill__c> bills = createTestRecords();
		List<BillController.BillDetailWrapper> billsDetail = new List<BillController.BillDetailWrapper>();
		for (Bill__c bill : bills) {
			billsDetail.add(BillController.getDetailOnly());
		}

		System.assertEquals(bills.size(), billsDetail.size());

		Schema.DescribeFieldResult fieldResult = Bill__c.Status__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

		Integer loanHoldersCount = [SELECT Id, Name FROM Loan_Holder__c].size();

		for (BillController.BillDetailWrapper bill : billsDetail) {
			System.assertEquals(ple.size(), bill.statuses.size());
			System.assertEquals(loanHoldersCount, bill.loanHolders.size());
			System.assertEquals(billsDetail[0].currentStatus, bill.currentStatus);
			System.assertEquals(billsDetail[0].currentLoanHolder.Name, bill.currentLoanHolder.Name);
		}
	}

	@IsTest static void TestGetAllBills() {
		List<Bill__c> bills = createTestRecords();
		System.assertEquals(bills.size(), BillController.getAllBills().size());
	}

	@IsTest static void TestGetBillsByMonth() {
		List<Bill__c> bills = createTestRecords();
		Integer month = Date.today().month();
		List<BillController.BillsWrapper> dbBills = BillController.getBillsByMonth(month);

		System.assertEquals(bills.size(), dbBills.size());
		for (BillController.BillsWrapper b : dbBills) {
			System.assertEquals(Date.today(), b.startDateTime);
			System.assertEquals(Date.today(), b.endDateTime);
		}
	}

	@IsTest static void TestGetBillByIdWrapper() {
		List<Bill__c> bills = createTestRecords();
		for (Bill__c b : bills) {
			BillController.BillsWrapper billsWrapper = BillController.getBillByIdWrapper(b.Id);
			System.assertEquals(b.Id, billsWrapper.Id);
			System.assertEquals('(' + b.Status__c + ') ' + b.Name, billsWrapper.title);
			System.assertEquals(b.Description__c, billsWrapper.description);
			System.assertEquals(b.Pay_Date__c, billsWrapper.startDateTime);
			System.assertEquals(b.Pay_Date__c, billsWrapper.endDateTime);
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