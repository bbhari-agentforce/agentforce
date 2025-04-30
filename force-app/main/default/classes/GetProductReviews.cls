public class GetProductReviews {
    @InvocableMethod(label='Fetch Product Reviews' description='Fetch Product Reviews')
    public static List<String> FetchProductReviews(List<String> input) {
        List<productreviews__dlm> reviews = [SELECT customername__c, dateofreview__c, productskuid__c, productname__c, rating__c, review__c, sociallink__c FROM productreviews__dlm];

        List<String> result = new List<String>();
        String resultString = '';

        for (productreviews__dlm review : reviews) {
            resultString = resultString + '\n Product SKU ID: ' + review.productskuid__c + ', Product Name: ' + review.productname__c + ', Rating: ' + review.rating__c + ', Comment: ' + review.review__c + ', Product Social Link: ' + review.sociallink__c + ', Customer: ' + review.customername__c + ', Date of Review: ' + review.dateofreview__c;
        }

        result.add(resultString);

        return result;
    }
}