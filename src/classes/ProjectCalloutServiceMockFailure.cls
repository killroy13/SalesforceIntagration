@IsTest
global class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
   //Implement http mock callout here
   global HttpResponse respond(HttpRequest request) {
      // Create a fake response
      HttpResponse response = new HttpResponse();
      response.setStatusCode(400);
      response.setStatus('Bad Request');
      return response;
   }
}