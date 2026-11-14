import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/menu_item_model.dart';

class MenuRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<MenuItemModel>> getMenuItems() async {
    try {
      final snapshot = await _firestore.collection(AppConstants.menuCollection).get();
      return snapshot.docs
          .map((doc) => MenuItemModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}