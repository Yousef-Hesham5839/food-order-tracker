import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../orders/presentation/screens/admin_orders_screen.dart';
import '../../../orders/presentation/screens/my_orders_screen.dart';
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
              icon: const Icon(Icons.admin_panel_settings_outlined, color: AppTheme.primaryColor),
              tooltip: 'Admin Dashboard',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminOrdersScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.receipt_long_outlined),
              tooltip: 'My Orders',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyOrdersScreen()),
                );
              },
            ),
            BlocBuilder<CartBloc, CartState>(
              builder: (context, cartState) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined),
                      tooltip: 'Cart',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        );
                      },
                    ),
                    if (cartState.totalItemCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                          child: Text(
                            '${cartState.totalItemCount}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: AppTheme.textSecondary),
              tooltip: 'Logout',
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
                    Text(
                      state.message,
                      style: const TextStyle(color: AppTheme.secondaryColor),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => context.read<MenuBloc>().add(FetchMenuEvent()),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            } else if (state is MenuLoaded) {
              if (state.items.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<MenuBloc>().add(FetchMenuEvent());
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                      const Center(
                        child: Text(
                          'No food items found in the menu! 🍔',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            context.read<MenuBloc>().add(FetchMenuEvent());
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Refreshing menu... 🍔'),
                                duration: Duration(milliseconds: 800),
                                backgroundColor: AppTheme.primaryColor,
                              ),
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh Menu'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Adding sample food items... 🍕'),
                                duration: Duration(seconds: 1),
                                backgroundColor: AppTheme.primaryColor,
                              ),
                            );

                            final firestore = FirebaseFirestore.instance;
                            await firestore.collection('menu_items').add({
                              'name': 'Double Cheese Burger',
                              'description': 'Juicy beef patty with melted cheddar and special sauce',
                              'price': 120.0,
                              'category': 'Burgers',
                              'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
                            });
                            await firestore.collection('menu_items').add({
                              'name': 'Pepperoni Pizza',
                              'description': 'Crispy crust with mozzarella and spicy pepperoni',
                              'price': 160.0,
                              'category': 'Pizza',
                              'imageUrl': 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=500',
                            });

                            if (context.mounted) {
                              context.read<MenuBloc>().add(FetchMenuEvent());
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add Sample Food 🍔🍕'),
                        ),
                      ),
                    ],
                  ),
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
                        context.read<CartBloc>().add(AddToCartEvent(item));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item.name} added to cart!'),
                            duration: const Duration(milliseconds: 600),
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