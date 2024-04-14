class ApiEndPoint {
  static String baseUrl = 'http://apniseva.com/APITEST';
  static String loginOtp = '$baseUrl/LoginOTP';
  static String verifyOtp = '$baseUrl/VerifyOTP';
  static String getLoc = '$baseUrl/select_city?user_id';
  static String getDash = '$baseUrl/user_home';
  static String subCat = '$baseUrl/SubCategory';
  static String service = '$baseUrl/user_service_list';

  static String addToCart = '$baseUrl/addto_to_cart';
  static String cartDetails = '$baseUrl/view_cart';
  static String removeItems = '$baseUrl/Remove_cart';
  static String applyCoupon = '$baseUrl/apply_coupon';
  static String checkout = '$baseUrl/checkout';
  static String reshedule = '$baseUrl/Reshedule';

  static String getOrder = '$baseUrl/customer_allorder';
  static String getOrderDetails = "$baseUrl/single_order_user";
  static String aditionalPayment =
      "$baseUrl/Aditional_Payment"; //Aditional_PaymentAditional_Payment
  static String submitRattinguser = "$baseUrl/Submitrattinguser";
  static String imageAPI = 'https://apniseva.com/uploads/';
  static String acceptRejectOrder = "$baseUrl/Aceptreject_order";

  static String addressAPI = '$baseUrl/add_address';
  static String updateAddress = '$baseUrl/update_address';

  static String generatePDF = "https://apniseva.com/Home/generate_pdf";
}
