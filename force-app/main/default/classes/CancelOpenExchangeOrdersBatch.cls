global class CancelOpenExchangeOrdersBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Status__c,Time_in_Force__c FROM Exchange_Order__c WHERE Status__c = 'Open' AND Time_in_Force__c = 'Day'
        ]);
    }

    global void execute(Database.BatchableContext bc, List<Exchange_Order__c> scope) {
        for (Exchange_Order__c order : scope) {
            order.Status__c = 'Cancelled';
        }
        update scope;
    }

    global void finish(Database.BatchableContext bc) {
       
       
    }
}