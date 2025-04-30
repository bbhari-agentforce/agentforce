public class AddProductToCart {
    @InvocableMethod(label='Add To Cart' description='Add product to the basket')
    public static List<String> addProductToCart(List<RequestInputParams> requestInputParamList) {
        List<String> res = new List<String>();
        //RequestInputParams requestInputParamList = new RequestInputParams();
        
        /*String verifier = GetTokenThroughSCAPI.base64URL(GetTokenThroughSCAPI.generateCodeVerifier());
        String challenge = GetTokenThroughSCAPI.generateCodeChallenge(verifier);
         Map<String, String> oAuthCode = GetTokenThroughSCAPI.OAuthLogin(challenge);
        System.debug('coode'+oAuthCode.get('code'));
        System.debug('usid'+oAuthCode.get('usid'));
        TokenResponse tokenRes = GetTokenThroughSCAPI.getGuestoAuthToken(oAuthCode.get('code'),oAuthCode.get('usid'), verifier, requestInputParamList[0]);*/
        List<MessagingSession> mesgSessions = [SELECT Id, Session_Bridge_Token__c, Customer_id__c FROM MessagingSession WHERE User_Session_ID__c =:requestInputParamList[0].user_session_id];
        MessagingSession mesgSession;
        for ( MessagingSession msgSession: mesgSessions) {
            mesgSession = msgSession;
            break;
        }
        Boolean isProductAddedToCart = false;
        if (MessagingSession.Session_Bridge_Token__c != null) {
            isProductAddedToCart = GetTokenThroughSCAPI.addProductToCart(requestInputParamList[0], mesgSession);
        } /*else {
            String verifier = GetTokenThroughSCAPI.base64URL(GetTokenThroughSCAPI.generateCodeVerifier());
            String challenge = GetTokenThroughSCAPI.generateCodeChallenge(verifier);
            Map<String, String> oAuthCode = GetTokenThroughSCAPI.OAuthLogin(challenge);
            System.debug('coode'+oAuthCode.get('code'));
            System.debug('usid'+oAuthCode.get('usid'));
            TokenResponse tokenRes = GetTokenThroughSCAPI.getGuestoAuthToken(oAuthCode.get('code'),oAuthCode.get('usid'), verifier, requestInputParamList[0]);
            for (MessagingSession msgSession : mesgSessions) {
                msgSession.Session_Bridge_Token__c = tokenRes.access_token;
                msgSession.customer_id__c = tokenRes.customer_id;
            }
            
            Update mesgSessions;
            isProductAddedToCart = GetTokenThroughSCAPI.addProductToCart(requestInputParamList[0], mesgSession);
        }*/
        //Boolean isProductAddedToCart = GetTokenThroughSCAPI.addProductToCart(requestInputParamList[0].productId, tokenRes); 
        if (isProductAddedToCart) {
            //<a href="https://zzkt-008.dx.commercecloud.salesforce.com/s/RefArch/e/cart"> Cart Page</a>
           // res.add('<a href="https://zzkt-008.dx.commercecloud.salesforce.com/s/RefArch/e/cart"> Cart Page</a>');
            //res.add(requestInputParamList[0].user_session_id);
            res.add(requestInputParamList[0].cartUrl);
        } else {
            res.add('facing the issue with adding the product to basket');
        }
        System.debug(isProductAddedToCart);
        return  res;
    }
}