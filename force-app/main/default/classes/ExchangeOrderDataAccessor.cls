public class ExchangeOrderDataAccessor {
    
	 public static List<Security__c> getSecurity() {
        return [SELECT ID,Symbol__c FROM Security__c];
    }

    public static Security getSecurityBySymbol(String Symbol){
        return [Select Id,Symbol__c from Security__c where Symbol__c=:Symbol];
    }

    public static List<Exchange_Order__c> getOder(String orderId) {
        return [SELECT Id,Order_Side__c,Order_Total__c , Quantity__c, Price__c, Security__c ,Status__c, Order_Type__c  FROM Exchange_Order__c WHERE Id =: orderId];
    }
}