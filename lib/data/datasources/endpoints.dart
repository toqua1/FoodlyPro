class ApiEndpoints{
  static const String baseProducts = '/products';

  // Returns a path with query string, e.g. "/products?foodType=GRILLED&categoryId=1"
  static String getProducts({String? foodType, int? categoryId}) {
    final Map<String, String> q = {};

    if (foodType != null && foodType.isNotEmpty) {
      q['foodType'] = foodType;
    }
    if (categoryId != null) {
      q['categoryId'] = categoryId.toString();
    }

    if (q.isEmpty) return baseProducts;

    // Build query safely (percent-encoding)
    final uri = Uri(path: baseProducts, queryParameters: q);
    return uri.toString(); // "/products?foodType=GRILLED&categoryId=1"
  }

  static const String handleCartEndpoint = '/cart';
  static const String handleAddressesEndpoint = '/addresses';
  static const String createOrdersEndpoint = '/orders';
static const String authRegister ='/auth/register';
static const String authLogin ='/auth/login';
static const String authOtpRequest ='/auth/forgot-password/otp-request';
static const String authOtpVerify ='/auth/forgot-password/otp-verify';
static const String authResetPass ='/auth/forgot-password/reset';
static const String userProfile ='/users/me';
static const String userChangePass ='/users/me/password';
static const String getAllCategories ='/categories';
static const String favourites ='/favorites';
static const String authRefreshToken ='/auth/refresh';
static const String reviewOfProduct ='/reviews/product';/*need product id*/
static const String myOrders ='/orders/my';
static const String review ='/reviews'; /*need product id if update or delete
 => /10*/
static String getReviewDetailed(int productId,bool isMe){
  return isMe?
      '$reviewOfProduct/$productId/me':
       '$reviewOfProduct/$productId/summary';
}
  static String payment(int orderId){
  return '/orders/$orderId/pay';
  }
}
