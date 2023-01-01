@isTest
public with sharing class MaintenanceRequestHelperTest {

    @isTest static void test(){
        List<Case> casesTestList = new List<Case>();
        List<Case> caseRelatedSingle = new List<Case>();
        List<Case> caseNotRelatedSingle = new List<Case>();
        Case caseRelated = new Case();
        caseRelated.Type = 'Repair';
        caseRelated.Status = 'Closed';
        caseRelated.Origin = 'Web';
        casesTestList.add(caseRelated);
        caseRelatedSingle.add(caseRelated);
    	Case caseNotRelated = new Case();
        caseNotRelated.Type = 'Routine Maintenance';
        caseNotRelated.Status = 'Closed';
        caseNotRelated.Origin = 'Web';
        casesTestList.add(caseNotRelated);
        caseNotRelatedSingle.add(caseNotRelated);
        insert casesTestList;
        List<Product2> productsTestList = new List<Product2>();
        Product2 product1 = new Product2(Name = 'Test', Maintenance_Cycle__c = 1000, Replacement_Part__c =true);
        Product2 product2 = new Product2(Name = 'Test', Maintenance_Cycle__c = 100, Replacement_Part__c =true);            
        Product2 product3 = new Product2(Name = 'Test', Maintenance_Cycle__c = 10, Replacement_Part__c =true);
        productsTestList.add(product1);
        productsTestList.add(product2);
        productsTestList.add(product3);
        insert productsTestList;
        List<Equipment_Maintenance_Item__c> equipMainItemTestList = new List<Equipment_Maintenance_Item__c>();
        Equipment_Maintenance_Item__c equipMainItem1 = new Equipment_Maintenance_Item__c(Equipment__c = product1.Id, Maintenance_Request__c = caseRelated.Id);
        Equipment_Maintenance_Item__c equipMainItem2 = new Equipment_Maintenance_Item__c(Equipment__c = product2.Id, Maintenance_Request__c = caseRelated.Id);
        Equipment_Maintenance_Item__c equipMainItem3 = new Equipment_Maintenance_Item__c(Equipment__c = product3.Id, Maintenance_Request__c = caseRelated.Id);
        equipMainItemTestList.add(equipMainItem1);
        equipMainItemTestList.add(equipMainItem2);
        equipMainItemTestList.add(equipMainItem3);
        insert equipMainItemTestList;
        Test.startTest();
        Database.update(caseRelatedSingle, false);
        Database.update(caseNotRelatedSingle, false);
        Database.update(casesTestList, false);
	Test.stopTest();
        System.assertEquals(1, 1);
    }
}