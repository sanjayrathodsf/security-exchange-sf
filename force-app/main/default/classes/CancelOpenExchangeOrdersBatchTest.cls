/*Batch apex to cancel all existing open orders of type Day*/
@isTest
private class CancelOpenExchangeOrdersBatchTest {

    @TestSetup
    static void makeData(){
        // Create test data
        List<Exchange_Order__c> orders = new List<Exchange_Order__c>();
        for (Integer i = 0; i < 200; i++) {
        Exchange_Order__c order = new Exchange_Order__c(
        Status__c = 'Open',
        Time_in_Force__c = 'Day'
        );
        orders.add(order);
        }
        insert orders;
    }
    static testMethod void testBatch() {
        // Start the batch
        Test.startTest();
        CancelOpenExchangeOrdersBatch batch = new CancelOpenExchangeOrdersBatch();
        ID batchId = Database.executeBatch(batch);
        Test.stopTest();

        // Verify that the batch was executed correctly
        List<Exchange_Order__c> updatedOrders = [        SELECT Id, Status__c, Time_in_Force__c FROM Exchange_Order__c WHERE Status__c = 'Cancelled' AND Time_in_Force__c = 'Day'    ];
        System.assertEquals(200, updatedOrders.size());
    }
}



