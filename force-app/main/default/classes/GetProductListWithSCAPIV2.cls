public class GetProductListWithSCAPIV2 {
    
    // Define the customerNo as an InvocableVariable to receive it from Flow
    // Main function to generate the verifier and challenge 
    @InvocableMethod(label='Get Product Search With SCAPI V2' description='Get Products List')
    public static List<String> getProductSearchResult(List<RequestInputParams> requestInputParamList) {
        // List to store the results
        List<String> result = new List<String>();
        String verifier = GetTokenThroughSCAPI.base64URL(GetTokenThroughSCAPI.generateCodeVerifier());
        String challenge = GetTokenThroughSCAPI.generateCodeChallenge(verifier);
        Map<String, String> oAuthCode = GetTokenThroughSCAPI.OAuthLogin(challenge, requestInputParamList[0].isLoggedIn);
        List<String> psr;
        if (requestInputParamList[0].isLoggedIn == 'true') {
            TokenResponse tokenRes = GetTokenThroughSCAPI.getGuestoAuthToken('', '', '', requestInputParamList[0]);
            psr = GetTokenThroughSCAPI.getProductResults(requestInputParamList[0].searchTerm, tokenRes, requestInputParamList[0]);
        } else {
            TokenResponse tokenRes = GetTokenThroughSCAPI.getGuestoAuthToken(oAuthCode.get('code'),oAuthCode.get('usid'), verifier, requestInputParamList[0]);
			System.debug('tokenRes' + tokenRes);
            if (tokenRes.status_code == '401 UNAUTHORIZED') {
                result.add('Please close the chat window and open freshly');
                return result;
            }
           	
            // Fetch product results based on search terms and token
            psr = GetTokenThroughSCAPI.getProductResults(requestInputParamList[0].searchTerm, tokenRes, requestInputParamList[0]);
        }
                        
            // Add the results to the final result list
            result.addAll(psr);
        //}
        return result;
    }
}