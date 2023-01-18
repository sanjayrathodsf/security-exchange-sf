@RestResource(urlMapping='/order/*')
Global class ExchangeOrderService {
	
        @HttpGet
        global static void doGet() {
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            String requestType = req.params.get('requestType');
            res.headers.put('Content-Type','application/json');

            switch on requestType{
                when 'securities'{
                    res.responseBody = Blob.valueOf(JSON.serialize(ExchangeOrderDataAccessor.getSecurity())); 
                }
                when 'order' {
                    String orderId = req.params.get('orderId');
                    res.responseBody = Blob.valueOf(JSON.serialize(ExchangeOrderDataAccessor.getOder(orderId)));
                }
            }

            if(res.responseBody!=null){
                res.statusCode = 200;
            }else{
                res.statusCode = 500;
                res.responseBody = Blob.valueOf('Could not find any records matching the criteria.');
            }
        }
    
        @HttpPost
        global static void createOrUpdateOrder() {
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            res.headers.put('Content-Type','application/json');
            Blob body = req.requestBody;
            String bodyStr = body.toString();
            OrderWrapper order = (OrderWrapper)JSON.deserialize(bodyStr, OrderWrapper.class);
            
            try{
                upsert constructOrder(order);
                res.statusCode = 200;
            }catch(Exception e){
                res.statusCode = 500;
            }
        }

      
        public static Exchange_Order__c constructOrder(OrderWrapper orderWrapper){
            Exchange_Order__c order = new Exchange_Order__c(
                Order_Side__c = orderWrapper.orderSide,  
                Quantity__c = orderWrapper.quantity, 
                Price__c = orderWrapper.price, 
                Security__c = ExchangeOrderDataAccessor.getSecurityBySymbol(orderWrapper.symbol).Id, 
                Order_Type__c = orderWrapper.orderType
            );

            if(orderWrapper.orderId!=null){
                order.Id = orderWrapper.orderId;
            }

            if(orderWrapper.orderStatus!=null){
                order.Status__c = orderWrapper.orderStatus;
            }
            return order;
        }
    
}