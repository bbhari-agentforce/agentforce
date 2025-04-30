public class RequestInputParams {
    @InvocableVariable
	public  String customerId;
    @InvocableVariable
    public  String searchTerm;
    @InvocableVariable
    public  String user_session_id;
    @InvocableVariable
    public  String isLoggedIn;
    @InvocableVariable
    public  String cartUrl;
     @InvocableVariable
    public String productId;
    @InvocableVariable
    public String accessToken;
    @InvocableVariable
    public String url;
    @InvocableVariable
    public String customerEmail;
    @InvocableVariable
    public String customerDetail;
    public RequestInputParams(String searchTerm, String customerId, String user_session_id, String cartUrl, String productId, String accessToken, String isLoggedIn, String customerEmail, String customerDetail) {
        this.searchTerm = searchTerm;
        this.customerId = customerId;
        this.user_session_id = user_session_id;
        this.cartUrl = cartUrl;
        this.productId = productId;
        this.accessToken=accessToken;
        this.isLoggedIn = isLoggedIn;
        this.customerEmail = customerEmail;
        this.customerDetail = customerDetail;
    }
    
   
    @InvocableMethod(label='Request Params' description='Request Params')
    public static void processRequest(List<RequestInputParams> requestParamsList) {
        for (RequestInputParams requestParams : requestParamsList) {
            //this.user_session_id = requestParams.user_session_id;
        }
    }
    public RequestInputParams() {
        
    }
}