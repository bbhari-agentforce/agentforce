public class GetProductWithSCAPI {
    @InvocableMethod(label='Get Product Data With SCAPI' description='Get Products Data')
    public static List<String> getProductWithSCAPI(List<RequestInputParams> requestInputParamListD) {
        //RequestInputParams reqParamList = new RequestInputParams();
       /* String verifier = GetTokenThroughSCAPI.base64URL(GetTokenThroughSCAPI.generateCodeVerifier());
        String challenge = GetTokenThroughSCAPI.generateCodeChallenge(verifier);
         Map<String, String> oAuthCode = GetTokenThroughSCAPI.OAuthLogin(challenge);*/
        List<MessagingSession> mesgSessions = [SELECT Id, Session_Bridge_Token__c FROM MessagingSession WHERE User_Session_ID__c =:requestInputParamListD[0].user_session_id];
        String sessionBridgeToken;
        for ( MessagingSession msgSession: mesgSessions) {
            sessionBridgeToken = msgSession.Session_Bridge_Token__c;
            break;
        }
        System.debug(sessionBridgeToken);
        System.debug(requestInputParamListD[0].user_session_id);
        List<String> productDetal = new List<String>();
        System.debug(requestInputParamListD[0].productId);
        if (sessionBridgeToken != null) {
            productDetal = GetTokenThroughSCAPI.getProductData(requestInputParamListD[0].productId, sessionBridgeToken); 
        } else {
            String verifier = GetTokenThroughSCAPI.base64URL(GetTokenThroughSCAPI.generateCodeVerifier());
            String challenge = GetTokenThroughSCAPI.generateCodeChallenge(verifier);
            Map<String, String> oAuthCode = GetTokenThroughSCAPI.OAuthLogin(challenge,requestInputParamListD[0].isLoggedIn);
            TokenResponse tokenRes = GetTokenThroughSCAPI.getGuestoAuthToken(oAuthCode.get('code'),oAuthCode.get('usid'), verifier, requestInputParamListD[0]);
            productDetal = GetTokenThroughSCAPI.getProductData(requestInputParamListD[0].productId, tokenRes.access_token);
            for (MessagingSession msgSession : mesgSessions) {
                //msgSession.Session_Bridge_Token__c = tokenRes.access_token;
                msgSession.customer_id__c = tokenRes.customer_id;
            }
            
            Update mesgSessions;
        }
        return productDetal;
    } 

}