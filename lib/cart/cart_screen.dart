import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:berry_happy/cubit/cart/cart_cubit.dart';
// ignore: library_prefixes
import 'package:berry_happy/cubit/cart/cart_item.dart' as CartItem;
import 'package:berry_happy/menu/menu_history.dart';

class CartScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CheckoutHistory> history = [];
  int checkoutIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final loadedHistory = await CheckoutHistoryManager.loadHistory();
    setState(() {
      history = loadedHistory;
      if (history.isNotEmpty) {
        checkoutIndex = history.last.index + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartCubit = BlocProvider.of<CartCubit>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 204, 229),
        title: const Text(
          'Cart',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<CartCubit, List<CartItem.CartItem>>(
        builder: (context, state) {
          if (state.isEmpty) {
            return const Center(
              child: Text('Cart is empty.'),
            );
          } else {
            int totalAmount = 0;
            for (var cartItem in state) {
              totalAmount += cartItem.menu.menuPrice * cartItem.quantity;
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.length,
                    itemBuilder: (context, index) {
                      final cartItem = state[index];
                      final totalPrice =
                          cartItem.menu.menuPrice * cartItem.quantity;
                      return Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 204, 229),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          title: Text(cartItem.menu.menuName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Price: Rp. ${cartItem.menu.menuPrice}'),
                              Text('Quantity: ${cartItem.quantity}'),
                              Text('Total: Rp. $totalPrice'),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              cartCubit.removeFromCart(cartItem);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey.shade200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rp. $totalAmount',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final List<CartItem.CartItem> checkoutItems =
                        List<CartItem.CartItem>.from(state);

                    final newCheckout = CheckoutHistory(
                      index: checkoutIndex,
                      items: checkoutItems,
                    );

                    setState(() {
                      history.add(newCheckout);
                      checkoutIndex++;
                    });

                    await CheckoutHistoryManager.saveHistory(history);

                    cartCubit.removeAllItems();

                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Checked out'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    // Navigate to MenuHistory and pass the newCheckout
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuHistory(
                          onAddNewCheckout: (newCheckout) {
                            setState(() {
                              history.add(newCheckout);
                              checkoutIndex = newCheckout.index + 1;
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: const Color.fromARGB(255, 255, 204, 229),
                    child: const Center(
                      child: Text(
                        'CHECKOUT',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
