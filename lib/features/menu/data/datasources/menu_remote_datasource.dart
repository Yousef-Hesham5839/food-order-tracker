import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/menu_item_model.dart';

class MenuRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<MenuItemModel>> getMenuItems() async {
    try {
      debugPrint('🔍 [Firestore] Fetching from collection: ${AppConstants.menuCollection}');
      final snapshot = await _firestore.collection(AppConstants.menuCollection).get();
      debugPrint('🔍 [Firestore] Docs found count: ${snapshot.docs.length}');
      
      for (var doc in snapshot.docs) {
        debugPrint('📄 [Firestore] Doc ID: ${doc.id} => Data: ${doc.data()}');
      }

      return snapshot.docs
          .map((doc) => MenuItemModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e, stack) {
      debugPrint('❌ [Firestore Error]: $e');
      debugPrint('❌ [Stack]: $stack');
      throw ServerException(e.toString());
    }
  }
}