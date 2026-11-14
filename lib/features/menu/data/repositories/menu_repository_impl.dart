import '../../domain/entities/menu_item_entity.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasources/menu_remote_datasource.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;

  MenuRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MenuItemEntity>> getMenuItems() async {
    return await remoteDataSource.getMenuItems();
  }
}