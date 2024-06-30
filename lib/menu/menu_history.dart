import 'dart:convert';
import 'package:berry_happy/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: library_prefixes
import 'package:berry_happy/cubit/cart/cart_item.dart' as CartItem;

// CheckoutHistoryManager manages saving and loading checkout history using SharedPreferences.
class CheckoutHistoryManager {
  static const String _historyKey = 'checkout_history';

  // Save a list of CheckoutHistory objects as JSON to SharedPreferences.
  static Future<void> saveHistory(List<CheckoutHistory> history) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = jsonEncode(history.map((h) => h.toJson()).toList());
    await prefs.setString(_historyKey, historyJson);
  }

  // Load saved checkout history from SharedPreferences and convert it back to List<CheckoutHistory>.
  static Future<List<CheckoutHistory>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_historyKey);
    if (historyJson == null) {
      return [];
    }
    final List<dynamic> historyList = jsonDecode(historyJson);
    return historyList.map((json) => CheckoutHistory.fromJson(json)).toList();
  }
}

// CheckoutHistory represents a single checkout event with an index and a list of CartItems.
class CheckoutHistory {
  final int index;
  final List<CartItem.CartItem> items;

  CheckoutHistory({
    required this.index,
    required this.items,
  });

  // Convert CheckoutHistory object to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  // Create CheckoutHistory object from JSON format.
  factory CheckoutHistory.fromJson(Map<String, dynamic> json) {
    return CheckoutHistory(
      index: json['index'],
      items: (json['items'] as List<dynamic>)
          .map((itemJson) => CartItem.CartItem.fromJson(itemJson))
          .toList(),
    );
  }
}

// MenuHistory is a StatefulWidget that displays a list of checkout histories.
class MenuHistory extends StatefulWidget {
  final Function(CheckoutHistory) onAddNewCheckout;

  // ignore: use_super_parameters
  const MenuHistory({Key? key, required this.onAddNewCheckout})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MenuHistoryState createState() => _MenuHistoryState();
}

class _MenuHistoryState extends State<MenuHistory> {
  List<CheckoutHistory> history = []; // List to hold loaded checkout histories
  int checkoutIndex = 1; // Index to track the next checkout number

  @override
  void initState() {
    super.initState();
    _loadHistory(); // Load history from SharedPreferences when widget initializes
  }

  // Load checkout history from SharedPreferences and update state
  Future<void> _loadHistory() async {
    final loadedHistory = await CheckoutHistoryManager.loadHistory();
    setState(() {
      history = loadedHistory;
      if (history.isNotEmpty) {
        checkoutIndex = history.last.index +
            1; // Set next checkout index based on last saved history
      }
    });
  }

  // Unused method to add new checkout history
  // ignore: unused_element
  void _addNewCheckout(CheckoutHistory newCheckout) {
    setState(() {
      history.add(newCheckout);
      checkoutIndex = newCheckout.index + 1; // Update next checkout index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 204, 229),
        title: const Text(
          'Checkout History', // Title of the app bar
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // Disable back button on app bar
      ),
      body: history
              .isEmpty // Display loading indicator if history is empty, otherwise display list of histories
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final checkout = history[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  color: const Color.fromARGB(255, 255, 204, 229),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Checkout ${checkout.index}', // Display checkout index
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: checkout.items.length,
                          itemBuilder: (context, itemIndex) {
                            final item = checkout.items[itemIndex];
                            final totalPrice =
                                item.menu.menuPrice * item.quantity;
                            return ListTile(
                              title: Text(
                                  item.menu.menuName), // Display menu item name
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Price: Rp. ${item.menu.menuPrice}'), // Display menu item price
                                  Text(
                                      'Quantity: ${item.quantity}'), // Display quantity of the menu item
                                  Text(
                                      'Total: Rp. $totalPrice'), // Display total price of the menu item
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const MyHomePage())); // Navigate to MyHomePage on button press
        },
        label: const Text('Back to Dashboard'), // Button label
        backgroundColor: Colors.pink, // Button background color
      ),
    );
  }
}
