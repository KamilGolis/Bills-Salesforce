public class CountingService {

	public static Decimal getSummary() {
		return getAllPrices();
	}

	public static Decimal getMonthSummary(Integer month, Integer year) {
		return getAllPricesForMonth(month, year);
	}

	private static Decimal getAllPrices() {
		Decimal summary = 0;
		Id userId = UserInfo.getUserId();
		for (AggregateResult ar :[select SUM(Price__c) sum from Bill__c WHERE OwnerId = :userId]) {
			Decimal sum = (Decimal) ar.get('sum');
			summary += sum;
		}
		return summary;
	}

	private static Decimal getAllPricesForMonth(Integer month, Integer year) {
		Decimal summary = 0;
		List<Bill__c> bills = BillController.convertFromWrapper(BillController.getBillsByMonth(month, year));
		List<Id> billsId = new List<Id>();
		for (Bill__c b : bills) {
			billsId.add(b.Id);
		}
		Id userId = UserInfo.getUserId();

		for (AggregateResult ar :[select SUM(Price__c) sum from Bill__c WHERE OwnerId = :userId AND Id IN :billsId]) {
			Decimal sum = (Decimal) ar.get('sum');
			summary += sum;
		}
		return summary;
	}

}