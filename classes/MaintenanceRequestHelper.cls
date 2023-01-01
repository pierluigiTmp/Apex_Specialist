public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> updatedRequests){
        List<Case> newRequests = new List<Case>();
        Map<ID, Integer> lowestMaintenanceCycleOf = lowestMaintenanceCycleMap();
        for(Case updatedRequest : updatedRequests){
            Date newDateDue = System.today() + lowestMaintenanceCycleOf.get(updatedRequest.Id); 	
            Case newRequest = new Case();
            newRequest.Parent_Id__c = updatedRequest.Id; //Parent_Id__c non dal pacchetto trailhead
            newRequest.Vehicle__c = updatedRequest.Vehicle__c;
            newRequest.Status = 'New';
            newRequest.Origin = 'Web';
            newRequest.Subject = 'Subject';
            newRequest.Type = 'Routine Maintenance';
            newRequest.Date_Due__c = newDateDue;
            newRequests.add(newRequest);
            
        }
        insert newRequests;
        
        List<Equipment_Maintenance_Item__c> newEquipmentMaintenanceItems = new List<Equipment_Maintenance_Item__c>();
        Map<ID, List<Product2>> productsListOf = product2Map();
        for(Case newRequest : newRequests){
            if(productsListOf.get(newRequest.Parent_Id__c) != NULL){
                for(Product2 product : productsListOf.get(newRequest.Parent_Id__c)){
                    Equipment_Maintenance_Item__c newEquipmentMaintenanceItem = new Equipment_Maintenance_Item__c();
                    newEquipmentMaintenanceItem.Equipment__c = product.Id;
                    newEquipmentMaintenanceItem.Maintenance_Request__c = newRequest.Id;
                    newEquipmentMaintenanceItems.add(newEquipmentMaintenanceItem);
                }
            }
        }
        insert newEquipmentMaintenanceItems;
    }
    
    //retun mappa lowest maintenance cycle di tutte le requests
    private static Map<ID, Integer> lowestMaintenanceCycleMap(){
        List<Product2> allProduct2 = [SELECT Id, Maintenance_Cycle__c FROM Product2 WHERE Maintenance_Cycle__c != NULL];
        Map<ID, Product2> Product2Map = new Map<ID, Product2>();
        Product2Map.putAll(allProduct2);
        Map<ID, Integer> MaintenanceCycles = new Map<ID, Integer>();
        List<Case> allRequests = [SELECT Id, Type, (SELECT Id, Equipment__c FROM Equipment_Maintenance_Items__r) FROM Case WHERE Type = 'Repair' OR Type = 'Routine Maintenance'];
        for(Case request : allRequests){
            List<Integer> tempMaintenanceCycles = new List<Integer>();
            for(Equipment_Maintenance_Item__c tempEquipMainItem : request.Equipment_Maintenance_Items__r){
                tempMaintenanceCycles.add(Integer.ValueOf(Product2Map.get(tempEquipMainItem.Equipment__c).Maintenance_Cycle__c));
                if(!tempMaintenanceCycles.isEmpty()){
                    tempMaintenanceCycles.sort();
                }
            }
            if(!tempMaintenanceCycles.isEmpty()){
                MaintenanceCycles.put(request.id, tempMaintenanceCycles[0]);
            }
            else{
                MaintenanceCycles.put(request.id, 0);
            }
        }
        return MaintenanceCycles;
    }
    
    //retun mappa prodotti di tutte le request
    private static Map<ID, List<Product2>> product2Map(){
        Map<ID, List<Product2>> returnMap = new Map<ID, List<Product2>>();
        List<Product2> allProduct2 = [SELECT Id, Maintenance_Cycle__c FROM Product2 WHERE Maintenance_Cycle__c != NULL];
        Map<ID, Product2> Product2Map = new Map<ID, Product2>();
        Product2Map.putAll(allProduct2);
        List<Case> allRequests = [SELECT Id, Type, (SELECT Id, Equipment__c FROM Equipment_Maintenance_Items__r) FROM Case WHERE Type = 'Repair' OR Type = 'Routine Maintenance'];
        for(Case request : allRequests){
            if(!request.Equipment_Maintenance_Items__r.isEmpty()){
                List<Product2> tempProduct2 = new List<Product2>();
                for(Equipment_Maintenance_Item__c tempEquipMainItem : request.Equipment_Maintenance_Items__r){
                    for(Product2 product2 : allProduct2){
                        if(product2.Id == tempEquipMainItem.Equipment__c){
                            tempProduct2.add(product2);
                        }
                    }
                }
                returnMap.put(request.Id, tempProduct2);
            }            
        }
        return returnMap;         
    }    
}