@isTest
public  class ExchangeOrderHandlerTest {
   
    @TestSetup
    static void makeData(){
        //Create Security
        List<Security__c> securitiesToInsert = new List<Security__c>();
        securitiesToInsert.add(new Security__c(Symbol__c='TSLA'));
        securitiesToInsert.add(new Security__c(Symbol__c='AMZN'));
        insert securitiesToInsert;

        List<Exchange_Order__c> testOrders = new List<Exchange_Order__c>();
        testOrders.add(new Exchange_Order__c(Order_Side__c = 'Buy',  Quantity__c = 10, Price__c = 10, Security__c = securitiesToInsert[0].Id, Status__c = 'Open', Order_Type__c = 'Market'));
        testOrders.add(new Exchange_Order__c(Order_Side__c = 'Sell',  Quantity__c = 10, Price__c = 9, Security__c =  securitiesToInsert[0].Id, Status__c = 'Open', Order_Type__c = 'Limit'));
        testOrders.add(new Exchange_Order__c(Order_Side__c = 'Buy',  Quantity__c = 10, Price__c = 15, Security__c =  securitiesToInsert[1].Id, Status__c = 'Open', Order_Type__c = 'Market'));
        testOrders.add(new Exchange_Order__c(Order_Side__c = 'Sell',  Quantity__c = 10, Price__c = 8, Security__c =  securitiesToInsert[1].Id, Status__c = 'Open', Order_Type__c = 'Limit'));
        insert testOrders;


    }

    @isTest
    private static void testOrderMatching() {
       
        Test.startTest();
            ExchangeOrderHandler.manageOrder();
        Test.stopTest();

         // Verify that the matched orders have been created
         List<Exchange_Order_Match__c> matchedOrders = [SELECT Id,Quantity__c,Price__c FROM Exchange_Order_Match__c];
         System.assertEquals(2, matchedOrders.size());
 
         // Verify that the matched order has the correct values
         Exchange_Order_Match__c matchedOrder = matchedOrders[0];
         System.assertEquals(10, matchedOrder.Quantity__c);
         System.assertEquals(9, matchedOrder.Price__c);
 
         // Verify that the matched orders have been updated to 'Completed'
         List<Exchange_Order__c> completedOrders = [SELECT Id, Status__c FROM Exchange_Order__c WHERE Status__c = 'Filled'];
         System.assertEquals(4, completedOrders.size());
        
    }
    
}