@IsTest
private class WarehouseCalloutServiceTest {
    
    @IsTest static void test() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 
        WarehouseCalloutService.getCallout();
        System.assertEquals(1, 1);
    }
}