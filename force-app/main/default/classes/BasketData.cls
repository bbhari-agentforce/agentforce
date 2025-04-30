public class BasketData {
        public class Address {
            public String address1;
            public String city;
            public String countryCode;
            public String firstName;
            public String fullName;
            public String id;
            public String lastName;
            public String phone;
            public String postalCode;
            public String salutation;
            public String stateCode;
        }
    
        public class CouponItem {
            public String code;
            public String couponItemId;
            public String statusCode;
            public Boolean valid;
        }
    
        public class PaymentInstrument {
            /*public class PaymentCard {
                public String cardType;
                public Boolean creditCardExpired;
                public String creditCardToken;
                public Integer expirationMonth;
                public Integer expirationYear;
                public String holder;
                public String maskedNumber;
                public String numberLastDigits;
                public Integer validFromMonth;
                public Integer validFromYear;
            }*/
    
            public String amount;
            public String paymentInstrumentId;
            public String paymentMethodId;
            //public PaymentCard paymentCard;
        }
    
        public class ProductItem {
            public String adjustedTax;
            public String basePrice;
            public String itemId;
            public String itemText;
            public String price;
            //public List<PriceAdjustment> priceAdjustments;
            public String priceAfterItemDiscount;
            public String productId;
            public String productName;
            public Integer quantity;
            public String shipmentId;
            public String shippingItemId;
            public String tax;
            public String taxBasis;
            public String taxClassId;
            public String taxRate;
    
            /*public class PriceAdjustment {
                public AppliedDiscount appliedDiscount;
    
                public class AppliedDiscount {
                    public String amount;
                    public String percentage;
                    public String priceBookId;
                    public String type;
                }
            }*/
        }
    
        public class BonusDiscountLineItem {
            public String couponCode;
            public String id;
            //public List<BonusProduct> bonusProducts;
    
            /*public class BonusProduct {
                public String link;
                public String productDescription;
                public String productId;
                public String productName;
                public String title;
            }*/
        }
    
        public class Basket {
            public String basketId;
            public Address billingAddress;
            public List<CouponItem> couponItems;
            public String creationDate;
            //public String currency;
            public String customerId;
            public String customerName;
            public String email;
            public List<BonusDiscountLineItem> bonusDiscountLineItems;
            public List<ProductItem> productItems;
            public String orderPriceAdjustments;
            public String orderTotal;
            public List<PaymentInstrument> paymentInstruments;
        }
    
        public class BasketResponse {
            public List<Basket> baskets;
            public Integer total;
        }
    
        public static BasketResponse parseBasketResponse(String jsonResponse) {
            return (BasketResponse)JSON.deserialize(jsonResponse, BasketResponse.class);
        }
    }