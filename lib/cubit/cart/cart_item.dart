import 'package:berry_happy/dto/menu.dart'; // Import Menu DTO

// CartItem represents an item in the shopping cart.
class CartItem {
  final Menu menu; // Menu associated with this cart item
  final int quantity; // Quantity of this menu item in the cart

  // Constructor for CartItem, initializes with a menu and optional quantity (default is 1).
  CartItem(this.menu, {this.quantity = 1});

  // Factory method to create a CartItem from JSON data.
  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        Menu.fromJson(
            json['menu']), // Create Menu object from JSON 'menu' field
        quantity: json['quantity'] as int, // Assign 'quantity' field from JSON
      );

  // Method to convert CartItem to JSON format.
  Map<String, dynamic> toJson() => {
        'menu': menu.toJson(), // Convert menu to JSON format
        'quantity': quantity, // Include quantity in JSON
      };
}
