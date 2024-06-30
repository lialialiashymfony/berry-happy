// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart'; // Bloc library for state management
import 'package:berry_happy/dto/menu.dart'; // Menu DTO
import 'package:berry_happy/cubit/cart/cart_item.dart'; // CartItem class for items in the cart

// CartCubit manages the state of the shopping cart using Cubit.
class CartCubit extends Cubit<List<CartItem>> {
  // Constructor initializes CartCubit with an empty list of cart items.
  CartCubit() : super([]);

  // Method to add a menu item to the cart.
  void addToCart(Menu menu) {
    bool alreadyInCart =
        false; // Flag to track if menu item is already in the cart

    // Check if the menu item is already in the cart
    // ignore: avoid_function_literals_in_foreach_calls
    state.forEach((item) {
      if (item.menu.idMenu == menu.idMenu) {
        // If already in cart, update the quantity of the existing item
        emit(state
            .map((e) => e.menu.idMenu == menu.idMenu
                ? CartItem(e.menu,
                    quantity: e.quantity + 1) // Increase quantity
                : e)
            .toList());
        alreadyInCart = true;
      }
    });

    // If menu item is not already in cart, add it as a new CartItem
    if (!alreadyInCart) {
      emit([...state, CartItem(menu)]);
    }
  }

  // Method to remove a specific item from the cart.
  void removeFromCart(CartItem item) {
    emit(state
        .where((element) => element != item)
        .toList()); // Remove item from cart
  }

  // Method to remove all items from the cart.
  void removeAllItems() {
    emit([]); // Clear cart by emitting an empty list
  }
}
