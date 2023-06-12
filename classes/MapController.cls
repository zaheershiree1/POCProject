/*******************************************************************************************
* @Name        MapController 
* @Author      Shireen
* @Date         
* @Description  This is created to get the Google Map Results.
*******************************************************************************************/


public class MapController {
    
    
 /**************************************************************************************
* @Description  This method provide the Distance between two place id
* @Param		String - place_id1,place_id2,modeTrans
* @Author      Shireen
* @Return       MapController 
**************************************************************************************/ 
    
    @AuraEnabled
    public static MapController getDistanceCost(String place_id1,string place_id2,string modeTrans) {
        
        system.debug('modeTrans'+modeTrans);
        
        String strURL =  'https://maps.googleapis.com/maps/api/distancematrix/json?origins=place_id:'+place_id1+'&destinations=place_id:'+place_id2+'&mode='+modeTrans+'&key='+Label.APIKey;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setMethod('GET');
        req.setEndpoint(strURL);
        req.setTimeout(120000);
        res = h.send(req); 
        String responseBody = res.getBody(); 
        MapController obj = MapController.parse(responseBody);
        system.debug('SearchApiAddressCtrl'+obj);
        
        Map<string,Calculator__mdt> costCalMap=new Map<string,Calculator__mdt>();
        for(Calculator__mdt cost :[select Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName, Cost__c from Calculator__mdt]){
            costCalMap.put(cost.MasterLabel,cost);
        }
        
        system.debug('costCalMap'+costCalMap);
        for(Rows r:obj.rows){
            
            for(Elements e:r.elements){
                
                system.debug(e.distance.text);
                
                string kmText=  e.distance.text.replace(',','.');
                decimal km=Decimal.valueof(kmText.replace(' km',''));
                e.Amount=km*costCalMap.get(modeTrans.toUPPERcase()).Cost__C;
                
                system.debug('e.Amount'+e.Amount);
            }
        }
        return obj;
        
        
        
    }
    
    
    /**************************************************************************************
* @Description  This method is to get the Map Search results
* @Param		String -searchString
* @Author      Shireen
* @Return       list<SuggestionWrapper>  
**************************************************************************************/ 
    
    @AuraEnabled
    Public Static list<SuggestionWrapper> getAddress(String searchString){
        string vHash=userinfo.getName();
        String result = EncodingUtil.Base64Encode( Blob.valueOf( vHash ) );
        
        if(String.isNotBlank(searchString)){
            List<SuggestionWrapper> suggestions=new List<SuggestionWrapper>();
            searchString = EncodingUtil.urlEncode(searchString, 'UTF-8');
            Http http = new Http();
            HttpRequest Request = new HttpRequest();
            Request.setMethod('GET');
            Request.setEndPoint('https://maps.googleapis.com/maps/api/place/autocomplete/json?input='+searchString+'&key='+Label.APIKey);
            HttpResponse Response = http.send(Request);
            if(Response.getStatusCode()==200){
                
                JSON2ApexSuggestion Json2Apex= parseSuggestion(Response.getbody());
                string CompleteAddress = '';
                List<String> completeaddressList = new List<String>();
                if(Json2Apex.Predictions != null){
                    for(JSON2ApexSuggestion.Predictions Prediction : Json2Apex.Predictions){
                        if(string.isNotBlank(Prediction.description)){
                            CompleteAddress = Prediction.description;
                            CompleteAddress = CompleteAddress.replaceAll(',', ' ');
                            suggestions.add(new SuggestionWrapper(CompleteAddress,Prediction.place_id));
                        }
                    }
                }
                return suggestions;  
            }
            system.debug('Response.getbody()'+Response.getbody());
        }
        return null;
    }
    
    
    /**************************************************************************************
* @Description  This method is to get the Place details
* @Param		String -placeId
* @Return       map<string,object> 
**************************************************************************************/ 
    
    @AuraEnabled
    public static map<string,object> getPlaceDetails(String placeId) {
        map<string,object> mapReturn=new  map<string,object>();
        
        if(String.isNotBlank(placeId)){
            String strURL = 'https://maps.googleapis.com/maps/api/place/details/json?'
                + 'placeid=' + EncodingUtil.urlEncode(placeId, 'UTF-8')
                + '&key=AIzaSyCdRW5PsuKoEtsM1KkFjR87aRWUGg56vK0'; 
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            req.setMethod('GET');
            req.setEndpoint(strURL);
            req.setTimeout(120000);
            res = h.send(req); 
            String responseBody = res.getBody(); 
            
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);   
            System.debug('responseMap'+responseMap.keyset());
            Map<String, Object> responseMapresult = (Map<String, Object>)responseMap.get('result');
            System.debug('responseMapresult'+responseMapresult.keyset());
            
            Map<String, Object> responseMapgeometry = (Map<String, Object>)responseMapresult.get('geometry');
            System.debug('responseMap'+responseMapgeometry.keyset());
            
            Map<String, Object> responseMapLocation= (Map<String, Object>)responseMapgeometry.get('location');
            
            System.debug('responseMapGeometry'+responseMapLocation);
            
            string  lat=string.valueof( responseMapLocation.get('lat'));
            string  lng=string.valueof( responseMapLocation.get('lng'));
            
            mapReturn.put('responseBody',responseBody);
            mapReturn.put('latlng',lat+','+lng);
            
            return mapReturn; 
        }else{
            return null;
        }
        
    }
    
    
    public class SuggestionWrapper{
        @AuraEnabled
        public String AddComplete{get;set;}
        @AuraEnabled
        public String placeId{get;set;}
        
        public SuggestionWrapper(string AddComplete,String placeId){
            this.AddComplete = AddComplete;
            this.placeId = placeId;
        }
    }        
    
    public static JSON2ApexSuggestion parseSuggestion(String json) {
        return (JSON2ApexSuggestion) System.JSON.deserialize(json, JSON2ApexSuggestion.class);
    }
    
    public class Elements {
        public @auraEnabled Distance distance;
        public @auraEnabled Distance duration;
        public @auraEnabled Decimal Amount;
        public  @auraEnabled String status;
    }
    public class Distance {
        public  @auraEnabled String text;
        public @auraEnabled Integer value;
        
    }
    public @auraEnabled List<String> destination_addresses;
    public @auraEnabled List<String> origin_addresses;
    public @auraEnabled List<Rows> rows;
    public @auraEnabled String status;
    public class Rows {
        public  @auraEnabled List<Elements> elements;
    }
    public static MapController parse(String json) {
        return (MapController) System.JSON.deserialize(json, MapController.class);
    }
    
    
}