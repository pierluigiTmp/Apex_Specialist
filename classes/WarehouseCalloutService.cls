public with sharing class WarehouseCalloutService implements Queueable, Database.AllowsCallouts {
    
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    public void execute(QueueableContext context) {
        getCallout();
    }
    
    public static void getCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
        List<Product2> upsertListOfProducts = new List<Product2>();
        for(Object obj : results){
            Map<String,Object> objMap = (Map<String,Object>) obj;
            Product2 newUpdatedProduct = new Product2();
            newUpdatedProduct.Replacement_Part__c = True;
            newUpdatedProduct.Name = (String) objMap.get('name');
            newUpdatedProduct.Cost__c = (Decimal) objMap.get('cost'); 
            newUpdatedProduct.Current_Inventory__c = (Decimal) objMap.get('quantity');     
            newUpdatedProduct.Lifespan_Months__c = (Decimal) objMap.get('lifespan'); 
            newUpdatedProduct.Maintenance_Cycle__c = (Decimal) objMap.get('maintenanceperiod'); 
            newUpdatedProduct.Warehouse_SKU__c = (String) objMap.get('_id');
            upsertListOfProducts.add(newUpdatedProduct);
        }
        List<Product2> allProducts = [SELECT Id, Warehouse_SKU__c FROM Product2 WHERE Warehouse_SKU__c != NULL];
        for(Product2 newProduct : upsertListOfProducts){
            for(Product2 oldProduct : allProducts){
                if(oldProduct.Warehouse_SKU__c == newProduct.Warehouse_SKU__c){
                    newProduct.Id = oldProduct.Id;                       
                }
            }
        }
        upsert upsertListOfProducts;
    }
}