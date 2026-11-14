import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/menu_repository.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository menuRepository;

  MenuBloc(this.menuRepository) : super(MenuInitial()) {
    on<FetchMenuEvent>(_onFetchMenu);
  }

  Future<void> _onFetchMenu(FetchMenuEvent event, Emitter<MenuState> emit) async {
    emit(MenuLoading());
    try {
      final items = await menuRepository.getMenuItems();
      emit(MenuLoaded(items));
    } catch (e) {
      emit(MenuError(e.toString()));
    }
  }
}