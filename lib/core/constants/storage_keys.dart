//lib/core/constants/storage_keys.dart
/// Keys used for:
/// - SharedPreferences
/// - API parameters
/// - Local storage

class StorageKeys {
  StorageKeys._();

  // ================= USER =================

  static const String userId = 'user_id';

  static const String fullName = 'full_name';

  static const String email = 'email';

  static const String mobile = 'mobile';

  static const String cityName = 'city_name';

  static const String cityId = 'loc_id';

  static const String otp = 'login_otp';

  static const String guestUserId = '0';

  // ================= CATEGORY =================

  static const String categoryId = 'cat_id';

  static const String subCategoryId = 'sub_cat';

  static const String serviceId = 'service_id';

  // ================= CART =================

  static const String cartId = 'cart_id';

  static const String productQty = 'product_qty';

  // ================= ADDRESS =================

  static const String addressId = 'address_id';

  // ================= ORDER =================

  static const String orderId = 'order_id';

  // ================= PAYMENT =================

  static const String paymentMode = 'payment_mode';

  static const String couponCode = 'coupon_code';

  static const String couponCharge = 'coupon_charge';

  static const String gstAmount = 'gst_amount';

  // ================= BOOKING =================

  static const String date = 'date';

  static const String time = 'time';

  // ================= RATING =================

  static const String technicianId = 'technician_id';

  static const String technicianRating = 'ratng_techniian';

  static const String technicianReview = 'review_technician';

  static const String companyRating = 'rate_company';

  static const String companyReview = 'review_cocmpany';
}
