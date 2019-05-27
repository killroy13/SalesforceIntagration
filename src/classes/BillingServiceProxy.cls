public class BillingServiceProxy {
    public class billProjectRequest_element {
        public BillingServiceProxy.project project;
    }
    public class project {
        public String username;
        public String password;
        public String projectRef;
        public Double billAmount;
    }
    public class billProjectResponse_element {
        public String status;
    }
    public class InvoicesPortSoap11 {
        public String endpoint_x = 'http://sb-integration-bs.herokuapp.com:80/ws';
        public String billProject(BillingServiceProxy.project project) {
            BillingServiceProxy.billProjectRequest_element request_x = new BillingServiceProxy.billProjectRequest_element();
            request_x.project = project;
            BillingServiceProxy.billProjectResponse_element response_x;
            Map<String, BillingServiceProxy.billProjectResponse_element> response_map_x = new Map<String, BillingServiceProxy.billProjectResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                            '',
                            'http://salesforce.com/th/invoice-web-service',
                            'billProjectRequest',
                            'http://salesforce.com/th/invoice-web-service',
                            'billProjectResponse',
                            'BillingServiceProxy.billProjectResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.status;
        }
    }
}