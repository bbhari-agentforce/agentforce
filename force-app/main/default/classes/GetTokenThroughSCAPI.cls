public class GetTokenThroughSCAPI {
        /*public static String getCustomerProfileDetails(String accessToken, String customerId) {
            String endpoint = 'https://zzkt-008.dx.commercecloud.salesforce.com/s/RefArch/dw/shop/v20_10/customers/'+customerId;
            endpoint += '?siteId=RefArch' +
                        //'&expand=(availability,prices)' +
                        '&ids='+EncodingUtil.urlEncode(searchTerm[0], 'UTF-8');
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
        	req.setEndpoint(endpoint);
        	req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + accessToken);
            HttpResponse response = http.send(req);
            return 'asdf';
        }*/
        // Function to generate a random string of a given length
        public static String generateRandomString(Integer length) {
            String possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
            String text = '';
            
            for (Integer i = 0; i < length; i++) {
                /*Integer randomIndex = Math.floor(Math.random() * possible.length);//Math.mod(Crypto.getRandomInteger(), possible.length());
                 if (randomIndex < 0 || randomIndex >= possible.length()) {
                    randomIndex = 0; // Fallback in case the generated index is invalid
                }
            	text += possible.charAt(randomIndex);*/
                //Integer randomIndex = Integer.valueOf(Math.round(Math.random() * (possible.length()-1)));
                Integer randomIndex = Math.round(Math.random() * (possible.length()));
            	 text += possible.mid(randomIndex,1);//possible.charAt(randomIndex);
               // System.debug('text' + text);
                //System.debug('text1' + text);
               // System.debug('text' + text);
            }
            //System.debug('text' + text);
            return text;
        }

        // Function to generate a code verifier
        public static String generateCodeVerifier() {
            return generateRandomString(96);
        }

        // Function to generate a code challenge based on the code verifier
        public static String generateCodeChallenge(String codeVerifier) {
            Blob codeVerifierBlob = Blob.valueOf(codeVerifier);
            Blob hashed = Crypto.generateDigest('SHA-256', codeVerifierBlob);
            //return EncodingUtil.urlEncode(EncodingUtil.base64Encode(hashed), 'UTF-8').replace('=', '').replace('+', '-').replace('/', '_');
            String base64Encoded = EncodingUtil.base64Encode(hashed);
            String base64URL = base64Encoded.replace('=', '').replace('+', '-').replace('/', '_'); // Replace '/' with '_
        	return base64URL;
        }

        // Function to encode a string to Base64 URL safe format
        public static String base64URL(String inputString) {
            String base64 = EncodingUtil.base64Encode(Blob.valueOf(inputString));
            //return base64.replace('=', '').replace('+', '-').replace('/', '_');
            return inputString.replace('=', '').replace('+', '-').replace('/', '_');
        }

        // Main function to generate the verifier and challenge
        //@InvocableMethod(label='Get Products List With SCAPI' description='Get Products List')
        /*public static List<String> generateCodeVerifierAndChallenge(List<String> searchTerm) {
            String verifier = base64URL(generateCodeVerifier());
            String challenge = generateCodeChallenge(verifier);
			String oAuthCode = OAuthLogin(challenge);
            String accessToken = oAuthToken(oAuthCode, verifier);
            List<String> psr = getProductResults(searchTerm, accessToken);
            //System.debug('Verifier: ' + verifier);
            //System.debug('accessToken: ' + accessToken);
            return psr;
        }*/
    
        public static List<String> getProductData(String searchTerm, String accessToken) {
            List<String> productDetail = new List<String>();
            String endpoint = 'https://kv7kzm78.api.commercecloud.salesforce.com/product/shopper-products/v1/organizations/f_ecom_zzkt_008/products';
            endpoint += '?siteId=RefArch' +
                        '&expand=promotions' +
                        '&ids='+EncodingUtil.urlEncode(searchTerm, 'UTF-8');
            Http http = new Http();
            HttpRequest req = new HttpRequest();
        	req.setEndpoint(endpoint);
        	req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + accessToken);
            HttpResponse response = http.send(req);
            System.debug(response.getBody());
            System.debug('req'+req);
            productDetail.add(response.getBody());
            return productDetail;
        }
    	public static List<String> getPromoCallouts(MessagingSession mesgSession, TokenResponse tokenRes) {
        	List<String> promos = new List<String>();
            String endPoint = 'https://kv7kzm78.api.commercecloud.salesforce.com/custom/promotion-search/v1/organizations/f_ecom_zzkt_008/get-customer-promotions?siteId=RefArch';
            String accessToken = mesgSession.Session_Bridge_Token__c != null ? mesgSession.Session_Bridge_Token__c :tokenRes.access_token; 
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + accessToken );
            HttpResponse response = http.send(req);
            promos.add(response.getBody());
            return promos;
    	}
    	public static Boolean addProductToCart(RequestInputParams inputRequestParamList, MessagingSession mesgSession) {
            List<Object> productObj = new List<Object>();
            String basketId;
            //System.debug(tokenRes.customer_id);
            //https://{shortCode}.api.commercecloud.salesforce.com/customer/shopper-customers/v1/organizations/{organizationId}/customers/{customerId}/baskets
            String endpoint = 'https://kv7kzm78.api.commercecloud.salesforce.com/customer/shopper-customers/v1/organizations/f_ecom_zzkt_008/customers/'+mesgSession.Customer_id__c+'/baskets';
            endpoint += '?siteId=RefArch';
            Http http = new Http();
            HttpRequest req = new HttpRequest();
        	req.setEndpoint(endpoint);
        	req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + mesgSession.Session_Bridge_Token__c);
            HttpResponse response = http.send(req);
            BasketData.BasketResponse customerbaskets = (BasketData.BasketResponse)JSON.deserialize(response.getBody(), BasketData.BasketResponse.class);
            System.debug(customerbaskets);
            if (customerbaskets != null && customerbaskets.baskets != null) {
             	for (BasketData.Basket basket : customerbaskets.baskets) {
                	basketId =  basket.basketId;
            	}   
            }
            if (basketId ==null) {
                endpoint = 'https://kv7kzm78.api.commercecloud.salesforce.com/checkout/shopper-baskets/v2/organizations/f_ecom_zzkt_008/baskets?siteId=RefArch';
            	Http http1 = new Http();
            	HttpRequest request1 = new HttpRequest();
                request1.setEndpoint(endpoint);
                request1.setMethod('POST');
                request1.setHeader('Content-Type', 'application/json');
                request1.setHeader('Authorization', 'Bearer ' + mesgSession.Session_Bridge_Token__c);
                System.debug('tokenRes.access_token'+mesgSession.Session_Bridge_Token__c);
                response = http.send(request1);
                BasketData.Basket basket = (BasketData.Basket)JSON.deserialize(response.getBody(), BasketData.Basket.class);
            	basketId = basket.basketId;
            }
            Http http1 = new Http();
            HttpRequest request = new HttpRequest();
            endpoint = 'https://kv7kzm78.api.commercecloud.salesforce.com/checkout/shopper-baskets/v2/organizations/f_ecom_zzkt_008/baskets/'+ basketId +'/items';
            endpoint += '?siteId=RefArch';
            request.setEndpoint(endpoint);
        	request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', 'Bearer ' + mesgSession.Session_Bridge_Token__c);
            Product newProduct = new Product(inputRequestParamList.productId, 1);
            //System.debug(productId);

            // Add the product to a list
            List<Product> productList = new List<Product>();
            productList.add(newProduct);

        // Serialize the list of products into a JSON string
        	String jsonData = JSON.serialize(productList);
             request.setBody(jsonData);
			response = http.send(request);
            System.debug(response);
            System.debug(request.getBody());
            if (response.getStatusCode() == 200) {
                return true;
            } 
            return false;
        }
    
    	public static List<String> getProductResults(String searchTerm, TokenResponse tokenRes, RequestInputParams requestInputParamList) {
        	List<String> psr = new List<String>();
            List<String> refinements = new List<String>();
            refinements.add('htype=product');
            String endpoint = 'https://kv7kzm78.api.commercecloud.salesforce.com/search/shopper-search/v1/organizations/f_ecom_zzkt_008/product-search';
            endpoint += '?siteId=RefArch' +
                        '&allVariationProperties=true' +
                        '&refine=htype=master'+
                        //'&expand=promotions' + //refinements + 
                        '&q='+EncodingUtil.urlEncode(searchTerm, 'UTF-8');
            System.debug('endpoint'+endpoint);
            Http http = new Http();
            HttpRequest req = new HttpRequest();
        	req.setEndpoint(endpoint);
        	req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + tokenRes.access_token);
            HttpResponse response = http.send(req);
            System.debug(response.getBody());
            System.debug('req'+req);
            
            List<MessagingSession> mesgSessions = [SELECT Id FROM MessagingSession WHERE User_Session_ID__c =:requestInputParamList.user_session_id];
            //requestInputParamList[0].accessToken = tokenRes.access_token;
            for (MessagingSession msgSession : mesgSessions) {
                msgSession.Session_Bridge_Token__c = tokenRes.access_token;
                msgSession.customer_id__c = tokenRes.customer_id;
            }
            
            Update mesgSessions;
            System.debug(mesgSessions);
            //System.debug('after'+session);
            psr.add(response.getBody());
            return psr;
    	}
    
        public static TokenResponse getGuestoAuthToken(String oAuthCode,String userId, String verifier, RequestInputParams requestInputParamList) {
            	List<String> oAuthResponse = new List<String>();
            	HttpRequest req = new HttpRequest();
                String endpoint = 'https://kv7kzm78.api.commercecloud.salesforce.com/shopper/auth/v1/organizations/f_ecom_zzkt_008/oauth2/session-bridge/token';
                String formData;
            if (requestInputParamList.isLoggedIn == 'true') {
                formData = 'client_id=e593eaae-a3f8-42e7-8280-67e429fcb7bb' +
                    	   '&grant_type=client_credentials' +
                          '&redirect_uri=https://pwa-kit.mobify-storefront.com/callback'+
                          '&channel_id=RefArch'+
                    	  '&hint=sb-user' +
                    	  '&dwsid='+requestInputParamList.user_session_id +
                    	  '&login_id='+requestInputParamList.customerEmail;
                    String clientId = 'e593eaae-a3f8-42e7-8280-67e429fcb7bb';
                    String clientSecret = 'Qj8z8q6sIpBVYGwnCM9zRTVv6vBuWxmZMVS2VHnXzC4';
               String authHeaderValue = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(clientId + ':' + clientSecret));
             req.setHeader('Authorization', authHeaderValue);
            } else {
                formData = 'client_id=69b41a8d-029f-464b-89a9-e7c1b8697e73' +
            			  '&code='+ oAuthCode + 
                    	   '&grant_type=session_bridge' +
                          '&redirect_uri=https://pwa-kit.mobify-storefront.com/callback'+
                          '&channel_id=RefArch' +
                          '&code_verifier=' + verifier +
                          '&dwsid='+requestInputParamList.user_session_id + 
                          '&userId='+userId +
						  '&hint=guest' +
                    	  '&login_id=guest';
            }
         		//System.debug(formData);
                    req.setEndpoint(endpoint);
        			req.setMethod('POST');
                    req.setBody(formData);
                    req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
                    Http http = new Http();
            		HttpResponse res = http.send(req);
            System.debug('response '+res.getBody());
            
                    TokenResponse tokenRes = (TokenResponse)JSON.deserialize(res.getBody(), TokenResponse.class);
            		
            return tokenRes;
        }
    
        public static TokenResponse oAuthToken(String oAuthCode, String verifier, RequestInputParams requestInputParamList) {
            List<String> oAuthResponse = new List<String>();
            String endpoint = 'https://kv7kzm78.api.commercecloud.salesforce.com/shopper/auth/v1/organizations/f_ecom_zzkt_008/oauth2/token';
            
            /*if (true) {
                endpoint = 'https://kv7kzm78.api.commercecloud.salesforce.com/shopper/auth/v1/organizations/f_ecom_zzkt_008/oauth2/session-bridge/token';
            }*/
        // Create the HttpRequest object
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');

        // Prepare the form data in x-www-form-urlencoded format
        // Register customer
        /*String formData = 'client_id=69b41a8d-029f-464b-89a9-e7c1b8697e73' +
            			  '&code='+ oAuthCode + 
                          '&grant_type=authorization_code_pkce' +
                          '&redirect_uri=https://pwa-kit.mobify-storefront.com/callback'+
                          '&channel_id=RefArch' +
                          '&code_verifier=' + verifier;*/
            //Guest customer
            String formData = 'client_id=69b41a8d-029f-464b-89a9-e7c1b8697e73' +
            			  '&code='+ oAuthCode + 
                          '&grant_type=authorization_code_pkce' +
                          '&redirect_uri=https://pwa-kit.mobify-storefront.com/callback'+
                          '&channel_id=RefArch' +
                          '&code_verifier=' + verifier;
                   
            req.setBody(formData);
            
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            //System.debug(formData);
            //System.debug(req);
        	Http http = new Http();
            HttpResponse res = http.send(req);
            System.debug(res);
            //String Location;
            // Handle the response
            TokenResponse tokenRes;
            if (res.getStatusCode() == 200) {
				
                tokenRes = (TokenResponse)JSON.deserialize(res.getBody(), TokenResponse.class);
                if (requestInputParamList.user_session_id != null) {
                    endpoint = 'https://kv7kzm78.api.commercecloud.salesforce.com/shopper/auth/v1/organizations/f_ecom_zzkt_008/oauth2/session-bridge/token';
                    formData = 'client_id=69b41a8d-029f-464b-89a9-e7c1b8697e73' +
            			  '&code='+ oAuthCode +
                          '&redirect_uri=https://pwa-kit.mobify-storefront.com/callback'+
                          '&channel_id=RefArch' +
                          '&code_verifier=' + verifier +
                          '&dwsid='+requestInputParamList.user_session_id;
                    if (requestInputParamList.isLoggedIn == 'false') {
                        formData += '&hint=guest' +
                          '&login_id=guest' + 
                          '&grant_type=session_bridge';
                    }
                    
                    req.setEndpoint(endpoint);
        			req.setMethod('POST');
                    req.setBody(formData);
          			req.setHeader('Authorization', tokenRes.access_token);  
                    req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
                    //System.debug(formData);
                    System.debug('sesiion'+req);
                    System.debug('sesiion'+req.getBody());
                    //Http http = new Http();
                    res = http.send(req);
                    System.debug('sesiion'+res);
                    tokenRes = (TokenResponse)JSON.deserialize(res.getBody(), TokenResponse.class);
                }
                //oAuthResponse['token'] = tokenRes.access_token;
                //oAuthResponse['customer_id'] = tokenRes.customer_id;
            }
            //System.debug('toekn res:'+token);
            return tokenRes;
        }
        public static Map<String, String> OAuthLogin (String challenge, String isLoggedIn) {
         String endpoint;
         if (isLoggedIn == 'true') {
            // Set the endpoint URL for Register
            endpoint = 'https://kv7kzm78.api.commercecloud.salesforce.com/shopper/auth/v1/organizations/f_ecom_zzkt_008/oauth2/login';
         } else {//for Guset
			endpoint = 'https://kv7kzm78.api.commercecloud.salesforce.com/shopper/auth/v1/organizations/f_ecom_zzkt_008/oauth2/authorize';
        }
        // Create the HttpRequest object
        HttpRequest req = new HttpRequest();
       
        

        // Prepare the form data in x-www-form-urlencoded format
        String formData = 'client_id=69b41a8d-029f-464b-89a9-e7c1b8697e73' + 
                          '&response_type=code' +
                          '&redirect_uri=https://pwa-kit.mobify-storefront.com/callback'+
                          '&channel_id=RefArch' +
                          '&code_challenge=' + challenge;
            if (isLoggedIn == 'true') { 
                req.setBody(formData);
                 req.setMethod('POST');
             } else {
                 formData += '&hint=guest';
                endpoint += '?'+formData;
                req.setMethod('GET');
                 
             }
         if (isLoggedIn == 'true') {
        // Your credentials for Basic Authentication
            String username = 'ajaykrishna.alangarumuralikrishna@merkle.com';
            String password = 'India@333';
             String authHeaderValue = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password));
             req.setHeader('Authorization', authHeaderValue);
         }
		 req.setEndpoint(endpoint);
        // Encode the username:password pair in Base64
        //String authHeaderValue = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password));


        // Set the request body (form data)
        //req.setBody(formData);
		//System.debug('formData'+formData);
        // Set headers for x-www-form-urlencoded content type
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        // Set the Authorization header for Basic Auth
        //req.setHeader('Authorization', authHeaderValue);
		//System.debug('req'+req);
        // Send the request
        Http http = new Http();
        HttpResponse res = http.send(req);
        //System.debug('res'+res);
        //System.debug('req'+req);
        Map<String, String> Location = new Map<String, String>();
        String resLocation;
        // Handle the response
        if (res.getStatusCode() == 303) {
            //System.debug('Response Body: ' + res.getBody());
             resLocation = res.getHeader('Location');
            //System.debug(Location);
        } else {
            System.debug('Error Response: ' + res.getStatusCode() + ' - ' + res.getBody());
        }

        List<String> locationSplitData = resLocation.split('\\?')[1].split('&');//.pop().substring(5);
            for (Integer i=0; i < locationSplitData.size(); i++) {
               // System.debug('resLocation'+resLocation);
                List<String> locationData;
             	locationData = locationSplitData[i].split('=');
                if (locationData.size() > 0 && (locationData[0] == 'code' || locationData[0] == 'usid') && !String.isEmpty(locationData[1])) {
                    //System.debug(locationData[0]);
                    //System.debug(locationData[1]);
                    //if (locationData[0] != null) {
                     	Location.put(locationData[0],locationData[1]);   
                    //}
                }
            }
        //System.debug('Location' + Location);
        return Location;
    }

}