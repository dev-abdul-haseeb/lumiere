import 'package:flutter/material.dart';

class AppConstants {

  static const String appName                 = 'LUMIÈRE';
  static const String appSubtitle             = 'LUXURY SKINCARE';
  // Firestore collection names
  static const String userCollection          = 'user';
  static const String cartCollection          = 'cart';
  static const String cartItemsCollection     = 'cart_items';
  static const String reviewsCollection       = 'reviews';
  static const String productsCollection      = 'products';
  static const String orderProductsCollection = 'order_products';
  static const String ordersCollection        = 'orders';
  static const String addressCollection       = 'address';


  static final Map<String, Icon> appIcon = {
    'Email': Icon(Icons.email_outlined),
    'Password' : Icon(Icons.lock),
    'Name' : Icon(Icons.person),
    'Phone': Icon(Icons.phone)
  };

  // Pagination
  static const int productsPageSize = 20;

  // Storage keys (SharedPreferences etc.)
  static const String tokenKey = 'auth_token';
}