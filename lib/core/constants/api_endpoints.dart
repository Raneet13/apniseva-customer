/// Centralized API endpoint configuration
/// Used by ApiClient and repositories

class ApiEndpoints {
  ApiEndpoints._();

  /// Base URL
  static const String baseUrl = 'http://apniseva.com/APITEST';

  /// Image base URL
  static const String imageBaseUrl = 'https://apniseva.com/uploads/';

  // ================= AUTH =================

  static const String loginOtp = '$baseUrl/LoginOTP';

  static const String verifyOtp = '$baseUrl/VerifyOTP';

  // ================= LOCATION =================

  static const String getLocation = '$baseUrl/select_city?user_id';

  // ================= DASHBOARD =================

  static const String dashboard = '$baseUrl/user_home';

  // ================= CATEGORY =================

  static const String subCategory = '$baseUrl/SubCategory';

  static const String serviceList = '$baseUrl/user_service_list';

  // ================= CART =================

  static const String addToCart = '$baseUrl/addto_to_cart';

  static const String cartDetails = '$baseUrl/view_cart';

  static const String removeCart = '$baseUrl/Remove_cart';

  static const String applyCoupon = '$baseUrl/apply_coupon';

  static const String checkout = '$baseUrl/checkout';

  static const String reschedule = '$baseUrl/Reshedule';

  // ================= ORDER =================

  static const String orders = '$baseUrl/customer_allorder';

  static const String orderDetails = '$baseUrl/single_order_user';

  static const String additionalPayment = '$baseUrl/Aditional_Payment';

  static const String acceptAdditionalOrder = '$baseUrl/acceptaditinalorder';

  static const String submitRating = '$baseUrl/Submitrattinguser';

  static const String acceptRejectOrder = '$baseUrl/Aceptreject_order';

  // ================= ADDRESS =================

  static const String addAddress = '$baseUrl/add_address';

  static const String updateAddress = '$baseUrl/update_address';

  // ================= PDF =================

  static const String generatePdf = 'https://apniseva.com/Home/generate_pdf';
}
