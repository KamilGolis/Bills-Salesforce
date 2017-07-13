public class CountingService {

	//Class for counting summaries
	public static Decimal getSummary() {
		return getAllPrices(Date.today());
	}

	public static Decimal getSummary(Date dateFilter) {
		return getAllPrices(dateFilter);
	}

	private static Decimal getAllPrices(Date dateFilter) {
		Decimal summary = 0;
		for (AggregateResult ar :[select SUM(Price__c) sum from Bill__c]) {
			Decimal sum = (Decimal) ar.get('sum');
			summary += sum;
		}
		return summary;
	}
}