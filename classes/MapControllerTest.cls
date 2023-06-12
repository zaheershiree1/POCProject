@IsTest
public class MapControllerTest {
    @isTest 
    Static void getDistanceCostTest(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        MapController.getDistanceCost('place_id1','place_id2','modeTrans');
        Test.stopTest();
    }
    
    
     @isTest 
    Static void getPlaceDetailsTest(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        MapController.getPlaceDetails('placeId');
        Test.stopTest();
    }
    
        @isTest 
    Static void getAddressTest(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        MapController.getAddress('placeId');
        Test.stopTest();
    }
    
    
}