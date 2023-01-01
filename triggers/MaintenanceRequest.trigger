trigger MaintenanceRequest on Case (after update) {
    if(trigger.new.size() > 1){
        List<Case> newTriggers = new List<Case>();
        for(Case newTrigger : trigger.new){
            if(newTrigger.Status == 'Closed' && (newTrigger.Type == 'Repair' || newTrigger.Type == 'Routine Maintenance')){
                newTriggers.add(newTrigger);
            }
        }
        MaintenanceRequestHelper.updateWorkOrders(newTriggers);
    }
    else{
        if(trigger.new[0].Status == 'Closed' && (trigger.new[0].Type == 'Repair' || trigger.new[0].Type == 'Routine Maintenance')){
            MaintenanceRequestHelper.updateWorkOrders(trigger.new);
        }
        
    }
}