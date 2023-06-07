@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        if(req.getEndpoint().contains('autocomplete')){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"predictions":[{"description":"New York, NY, USA","matched_substrings":[{"length":8,"offset":0}],"place_id":"ChIJOwg_06VPwokRYv534QaPC8g","reference":"ChIJOwg_06VPwokRYv534QaPC8g","structured_formatting":{"main_text":"New York","main_text_matched_substrings":[{"length":8,"offset":0}],"secondary_text":"NY, USA"},"terms":[{"offset":0,"value":"New York"},{"offset":10,"value":"NY"},{"offset":14,"value":"USA"}],"types":["locality","political","geocode"]},{"description":"New York State, USA","matched_substrings":[{"length":8,"offset":0}],"place_id":"ChIJqaUj8fBLzEwRZ5UY3sHGz90","reference":"ChIJqaUj8fBLzEwRZ5UY3sHGz90","structured_formatting":{"main_text":"New York State","main_text_matched_substrings":[{"length":8,"offset":0}],"secondary_text":"USA"},"terms":[{"offset":0,"value":"New York State"},{"offset":16,"value":"USA"}],"types":["administrative_area_level_1","political","geocode"]},{"description":"New York University, New York, NY, USA","matched_substrings":[{"length":8,"offset":0}],"place_id":"ChIJwZVT9ZpZwokRBfO1cTF0MNo","reference":"ChIJwZVT9ZpZwokRBfO1cTF0MNo","structured_formatting":{"main_text":"New York University","main_text_matched_substrings":[{"length":8,"offset":0}],"secondary_text":"New York, NY, USA"},"terms":[{"offset":0,"value":"New York University"},{"offset":21,"value":"New York"},{"offset":31,"value":"NY"},{"offset":35,"value":"USA"}],"types":["university","university","point_of_interest","establishment"]},{"description":"New York Marriott Marquis, Broadway, New York, NY, USA","matched_substrings":[{"length":8,"offset":0}],"place_id":"ChIJiVXoAFVYwokREqPijh-d8xg","reference":"ChIJiVXoAFVYwokREqPijh-d8xg","structured_formatting":{"main_text":"New York Marriott Marquis","main_text_matched_substrings":[{"length":8,"offset":0}],"secondary_text":"Broadway, New York, NY, USA"},"terms":[{"offset":0,"value":"New York Marriott Marquis"},{"offset":27,"value":"Broadway"},{"offset":37,"value":"New York"},{"offset":47,"value":"NY"},{"offset":51,"value":"USA"}],"types":["lodging","point_of_interest","establishment"]},{"description":"New Yorker Pizza, South King Street, Leesburg, VA, USA","matched_substrings":[{"length":8,"offset":0}],"place_id":"ChIJPcCA5JAXtokRPVABCNYsJF4","reference":"ChIJPcCA5JAXtokRPVABCNYsJF4","structured_formatting":{"main_text":"New Yorker Pizza","main_text_matched_substrings":[{"length":8,"offset":0}],"secondary_text":"South King Street, Leesburg, VA, USA"},"terms":[{"offset":0,"value":"New Yorker Pizza"},{"offset":18,"value":"South King Street"},{"offset":37,"value":"Leesburg"},{"offset":47,"value":"VA"},{"offset":51,"value":"USA"}],"types":["meal_takeaway","restaurant","food","point_of_interest","establishment"]}],"status":"OK"}');
            res.setStatusCode(200);
            return res;
        }
        else{
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "destination_addresses" : [ "dd" ], "origin_addresses" : [ "rrrrr" ], "rows" : [ { "elements" : [ { "distance" : { "text" : "55,3 km", "value" : 55262 }, "duration" : { "text" : "11 heures 22 minutes", "value" : 40899 }, "status" : "OK" } ] } ], "status" : "OK" }');
            res.setStatusCode(200);
            return res;
        }
        // Create a fake response
    }
}