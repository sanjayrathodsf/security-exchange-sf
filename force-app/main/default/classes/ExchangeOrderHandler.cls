public class ExchangeOrderHandler {
   
    
    public static void manageOrder(){
     
        List<Exchange_Order__c> updateOrders = new List<Exchange_Order__c>();
        Map<Id,List<ExchangeOrderHandler.orderWrapper>> tempSecurityToOpenBuyOrderMap = new Map<Id,List<ExchangeOrderHandler.orderWrapper>>();
        Map<Id,List<ExchangeOrderHandler.orderWrapper>> tempSecurityToOpenSellOrderMap = new Map<Id,List<ExchangeOrderHandler.orderWrapper>>();
        Map<Id,List<ExchangeOrderHandler.orderWrapper>> securityToOpenBuyOrderMap = new Map<Id,List<ExchangeOrderHandler.orderWrapper>>();
        Map<Id,List<ExchangeOrderHandler.orderWrapper>> securityToOpenSellOrderMap = new Map<Id,List<ExchangeOrderHandler.orderWrapper>>();
        List<Exchange_Order_Match__c> matchOrderToInsert = new List<Exchange_Order_Match__c>();
        
        for(Exchange_Order__c eo : [SELECT Id,Order_Side__c ,Order_Total__c , Quantity__c, Price__c, Security__c ,Status__c, Order_Type__c  FROM Exchange_Order__c WHERE Status__c = 'Open']){
            if(eo.Order_Side__c == 'Buy'){
                if(!tempSecurityToOpenBuyOrderMap.containsKey(eo.Security__c)){
                    tempSecurityToOpenBuyOrderMap.put(eo.Security__c,new List<ExchangeOrderHandler.orderWrapper>());
                }
                tempSecurityToOpenBuyOrderMap.get(eo.Security__c).add(new ExchangeOrderHandler.orderWrapper(eo));

            }else{
                if(!tempSecurityToOpenSellOrderMap.containsKey(eo.Security__c)){
                    tempSecurityToOpenSellOrderMap.put(eo.Security__c,new List<ExchangeOrderHandler.orderWrapper>());
                }
                tempSecurityToOpenSellOrderMap.get(eo.Security__c).add(new ExchangeOrderHandler.orderWrapper(eo));
            }
        }
       
       //Sort buy orders in decending price order
        for(Id key : tempSecurityToOpenBuyOrderMap.keySet()){
            List<ExchangeOrderHandler.orderWrapper> tempBuyOrderList = tempSecurityToOpenBuyOrderMap.get(key);
            tempBuyOrderList.sort();

            if(!securityToOpenBuyOrderMap.containsKey(key)){
                securityToOpenBuyOrderMap.put(key,tempBuyOrderList);
            }
        }

        //sort sell orders in ascending price order
        for(Id key : tempSecurityToOpenSellOrderMap.keySet()){
            List<ExchangeOrderHandler.orderWrapper> tempSellOrderList = tempSecurityToOpenSellOrderMap.get(key);
            tempSellOrderList.sort();
            if(!securityToOpenSellOrderMap.containsKey(key)){
                securityToOpenSellOrderMap.put(key,tempSellOrderList);
            }
        }

        for(Id security : securityToOpenBuyOrderMap.KeySet()){
            if(securityToOpenSellOrderMap.get(security).size()>0){
                for(ExchangeOrderHandler.orderWrapper buyOrder : securityToOpenBuyOrderMap.get(security)) {
                    for(ExchangeOrderHandler.orderWrapper sellOrder : securityToOpenSellOrderMap.get(security)){
                        if(buyOrder.Price >= sellOrder.Price && buyOrder.Quantity == sellOrder.Quantity) {
                              // Create a matched order
                            Exchange_Order_Match__c  matchedOrder = new Exchange_Order_Match__c ();
                            matchedOrder.Quantity__c  = buyOrder.quantity;
                            matchedOrder.Price__c = sellOrder.price;
                            matchedOrder.Buy_Order__c = buyOrder.orderId;
                            matchedOrder.Sell_Order__c = sellOrder.orderId;
                            matchOrderToInsert.add(matchedOrder);

                            Exchange_Order__c sellOrderUpdate = new Exchange_Order__c(Id = sellOrder.orderId,Status__c='Filled');
                            Exchange_Order__c BuyOrderUpdate = new Exchange_Order__c(Id = buyOrder.orderId,Status__c='Filled');

                            updateOrders.add(sellOrderUpdate);
                            updateOrders.add(BuyOrderUpdate);
                        }
                    }
                }
            }
        }
        
        if(matchOrderToInsert.size()>0){
            try{
                insert matchOrderToInsert;
                if(updateOrders.size()>0){
                    update updateOrders;
                }
            }catch(Exception e){
                //log an error
            }
        }
    }

    public class orderWrapper implements Comparable{
        public string orderId{get;set;}
        public string orderSide{get;set;}
        public decimal orderTotal{get;set;}
        public decimal quantity{get;set;}
        public decimal price{get;set;}
        public string securityId{get;set;}
        public string status{get;set;}
        public string orderType{get;set;}

        public orderWrapper(Exchange_Order__c order){
            this.orderId = order.Id;
            this.orderSide = order.Order_Side__c;
            this.orderTotal = order.Order_Total__c;
            this.quantity = order.Quantity__c;
            this.price = order.Price__c;
            this.securityId = order.Security__c;
            this.status = order.Status__c;
            this.orderType = order.Order_Type__c;
        }

        public Integer compareTo(Object compareTo) {
            Integer comparison = 0; //orders are equal
            orderWrapper toCompare = (orderWrapper) compareTo;
            if(orderSide == 'Buy'){
                if(price >  toCompare.price){
                    comparison = 1;
                }else{
                    comparison = -1;
                }

            }else if(orderSide =='Sell'){
                if(price <  toCompare.price){
                    comparison = 1;
                }else{
                    comparison = -1;
                }
            }

            return comparison;

        }
    }
}