import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';
import '../bloc/menu_state.dart';
import '../widgets/menu_item_card.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MenuBloc>()..add(FetchMenuEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delivery_dining, color: AppTheme.primaryColor),
              SizedBox(width: 8),
              Text('FoodTrack Menu'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: AppTheme.textSecondary),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutEvent());
              },
            ),
          ],
        ),
        body: BlocBuilder<MenuBloc, MenuState>(
          builder: (context, state) {
            if (state is MenuLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              );
            } else if (state is MenuError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: const TextStyle(color: AppTheme.secondaryColor)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<MenuBloc>().add(FetchMenuEvent()),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            } else if (state is MenuLoaded) {
              if (state.items.isEmpty) {
                return const Center(
                  child: Text('No food items found in the menu! 🍔',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<MenuBloc>().add(FetchMenuEvent());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 20),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return MenuItemCard(
                      item: item,
                      onAddToCart: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item.name} added to cart!'),
                            duration: const Duration(seconds: 1),
                            backgroundColor: AppTheme.primaryColor,
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}