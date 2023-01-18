trigger ExchagneOrderPETrigger on Exchange_Order_PE__e (after insert) {
    ExchangeOrderHandler.manageOrder();

}