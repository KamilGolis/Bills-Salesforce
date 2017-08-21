@IsTest
private class CountingServiceTest {

	@TestSetup
	static void testsetup() {
		// Insert dummy records
		Loan_Holder__c loan = new Loan_Holder__c();
		loan.Name = 'Test loan';
		insert loan;

        List<Bill__c> bills = new List<Bill__c> ();
        for (Integer i = 0; i< 10; i++) {
            Bill__c bill = new Bill__c();
			bill.Name = 'Test bill ' + i;
			bill.Price__c = 10;
			bill.Pay_Date__c = Date.today();
            bill.Status__c = 'Inne';
            bill.Loan_Holder__c = loan.Id;
			bills.add(bill);
		}
		insert bills;
	}

	@IsTest static void testGetSummary() {
		System.assertEquals(100, CountingService.getSummary());
	}

	@IsTest static void testGetPricesForMonth() {
		System.assertEquals(100, CountingService.getMonthSummary(Date.today().month()));
	}
}