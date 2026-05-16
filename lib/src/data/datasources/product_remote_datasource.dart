import 'dart:io';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumiere/src/core/constants/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumiere/src/data/models/products_model.dart';

class ProductRemoteDatasource {
  final FirebaseFirestore _firestore;
  final SupabaseClient    _supabase;

  static const String _bucket     = 'photos';
  static const String _collection = AppConstants.productsCollection;

  ProductRemoteDatasource({
    required FirebaseFirestore firestore,
    required SupabaseClient    supabase,
  })  : _firestore = firestore,
        _supabase  = supabase;

  // Add

  Future<void> addProduct(ProductsModel product, {String? imageLocalPath}) async {
    String imageUrl = product.image_link;

    if (imageLocalPath != null && imageLocalPath.isNotEmpty) {
      imageUrl = await _uploadImage(
        localPath: imageLocalPath,
        productId: product.productId,
      );
    }

    final updated = product.copyWith(image_link: imageUrl);
    await _firestore.collection(_collection).doc(updated.productId).set(_toMap(updated));
  }

  // Fetch
  Future<List<ProductsModel>> fetchProducts() async {
    final snapshot = await _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ProductsModel.fromFirestore(doc.data(), id: doc.id)) // ← pass doc.id
        .toList();
  }

  // Delete

  Future<void> deleteProduct(String productId) async {
    await _firestore.collection(_collection).doc(productId).delete();
  }

  // Update

  Future<void> updateProduct(ProductsModel product, {String? imageLocalPath}) async {
    String imageUrl = product.image_link;

    if (imageLocalPath != null && imageLocalPath.isNotEmpty) {
      imageUrl = await _uploadImage(
        localPath: imageLocalPath,
        productId: product.productId,
      );
    }

    final updated = product.copyWith(image_link: imageUrl);
    await _firestore
        .collection(_collection)
        .doc(updated.productId)
        .set(_toUpdateMap(updated), SetOptions(merge: true));
  }

  // Image Upload
  Future<String> _uploadImage({
    required String localPath,
    required String productId,
  }) async {
    if (kIsWeb) {
      final xfile       = XFile(localPath);
      final bytes       = await xfile.readAsBytes();
      final mime        = xfile.mimeType ?? 'image/jpeg';
      final ext         = mime.split('/').last;
      final storagePath = 'products/$productId.$ext';

      await _supabase.storage.from(_bucket).uploadBinary(
        storagePath,
        bytes,
        fileOptions: FileOptions(upsert: true, contentType: mime),
      );

      final publicUrl = _supabase.storage.from(_bucket).getPublicUrl(storagePath);
      return '$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}'; // ← cache bust
    } else {
      final file        = File(localPath);
      final ext         = localPath.split('.').last;
      final storagePath = 'products/$productId.$ext';

      await _supabase.storage.from(_bucket).upload(
        storagePath,
        file,
        fileOptions: const FileOptions(upsert: true),
      );

      final publicUrl = _supabase.storage.from(_bucket).getPublicUrl(storagePath);
      return '$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}'; // ← cache bust
    }
  }

  // Helpers

  Map<String, dynamic> _toMap(ProductsModel p) => {
    'productName':    p.productName,
    'subtitle':       p.subtitle,
    'description':    p.description,
    'category':       p.category,
    'volume':         p.volume,
    'stock_quantity': p.stock_quantity,
    'cost_price':     p.cost_price,
    'sale_price':     p.sale_price,
    'image_link':     p.image_link,
    'isNewArrival':   p.isNewArrival,
    'isFeatured':     p.isFeatured,
    'createdAt':      FieldValue.serverTimestamp(),
  };

// Separate map for updates — does NOT overwrite createdAt
  Map<String, dynamic> _toUpdateMap(ProductsModel p) => {
    'productName':    p.productName,
    'subtitle':       p.subtitle,
    'description':    p.description,
    'category':       p.category,
    'volume':         p.volume,
    'stock_quantity': p.stock_quantity,
    'cost_price':     p.cost_price,
    'sale_price':     p.sale_price,
    'image_link':     p.image_link,
    'isNewArrival':   p.isNewArrival,
    'isFeatured':     p.isFeatured,
    'updatedAt':      FieldValue.serverTimestamp(), // ← track update time separately
  };
}