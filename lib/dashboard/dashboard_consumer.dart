import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:berry_happy/components/customsearch.dart';
import 'package:berry_happy/cubit/cart/cart_cubit.dart';
import 'package:berry_happy/cubit/cubit/auth_cubit.dart';
import 'package:berry_happy/dto/menu.dart';
import 'package:berry_happy/endpoints/endpoints.dart';
import 'package:berry_happy/services/data_service.dart';
import 'package:berry_happy/cart/cart_screen.dart';

// DashboardConsumer displays a dashboard UI for the consumer.
class DashboardConsumer extends StatefulWidget {
  // Constructor for DashboardConsumer widget.
  // ignore: use_super_parameters
  const DashboardConsumer({Key? key}) : super(key: key);

  @override
  State<DashboardConsumer> createState() => _DashboardConsumerState();
}

class _DashboardConsumerState extends State<DashboardConsumer> {
  Future<List<Menu>>? _menu; // Future holding a list of Menu objects
  late TextEditingController _searchController; // Controller for search input
  int currentPage = 1; // Current page of data being fetched

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(); // Initialize search controller
    _fetchData(currentPage); // Fetch initial data on widget initialization
  }

  @override
  void dispose() {
    _searchController
        .dispose(); // Dispose of search controller to free resources
    super.dispose();
  }

  // Fetches data for a given page.
  void _fetchData(int page) {
    setState(() {
      final token =
          context.read<AuthCubit>().state.accessToken; // Retrieve access token
      _menu = DataService.fetchMenu1(
        // Call service to fetch menu data
        currentPage,
        _searchController.text,
        token,
      );
    });
  }

  // Increment current page and fetch data.
  void _incrementPage() {
    setState(() {
      currentPage++;
      _fetchData(currentPage);
    });
  }

  // Decrement current page and fetch data, ensuring page number does not go below 1.
  void _decrementPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
        _fetchData(currentPage);
      });
    }
  }

  // Show details of a menu item in a bottom sheet.
  void _showMenuDetails(Menu menu) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display menu image if available
                    // ignore: unnecessary_null_comparison
                    if (menu.imageUrl != null)
                      Center(
                        child: Image.network(
                          Uri.parse(
                                  '${Endpoints.baseUAS}/static/storages/${menu.imageUrl}')
                              .toString(),
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    const SizedBox(height: 10),
                    // Display menu name
                    Text(
                      menu.menuName,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Display menu price
                    Text(
                      'Rp. ${menu.menuPrice}',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Display menu description
                    Text(
                      menu.descMenu,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // BlocProvider for managing cart state
                    BlocProvider(
                      create: (context) => CartCubit(),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            final cartCubit =
                                BlocProvider.of<CartCubit>(context);
                            cartCubit.addToCart(menu); // Add menu to cart
                            Navigator.pop(context); // Close bottom sheet
                          },
                          child: const Text('Add to Cart'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Navigate to cart screen
  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authCubit =
        BlocProvider.of<AuthCubit>(context); // Access AuthCubit instance

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 204, 229),
        title: const Text('Berry Happy'), // App title
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart), // Shopping cart icon
            onPressed: _navigateToCart, // Navigate to cart screen
          ),
        ],
      ),
      drawer: Drawer(
        // App drawer for navigation options
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 204, 229),
              ),
              child: Text(
                'Berry Happy',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
            ),
            // Logout option in drawer
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                authCubit.logout(); // Trigger logout action
                Navigator.pushReplacementNamed(
                    context, '/login-screen'); // Navigate to login screen
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        // Scrollable body content
        child: Container(
          color: const Color.fromARGB(255, 255, 204, 229), // Background color
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Custom search box for filtering menu items
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomSearchBox(
                  controller: _searchController,
                  onChanged: (value) => _fetchData(currentPage),
                  onClear: () => _fetchData(currentPage),
                  hintText: 'Search',
                ),
              ),
              const SizedBox(height: 10),
              // Restaurant information section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/images/logo.png'),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Berry Happy Cafe',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                Icons.star,
                                color: index < 4 ? Colors.yellow : Colors.grey,
                                size: 20,
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Menu items section
              Container(
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 204, 229),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: FutureBuilder<List<Menu>>(
                  future: _menu, // Future for fetching menu data
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!; // Retrieved menu data
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index]; // Current menu item
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: () => _showMenuDetails(
                                  item), // Show menu details on tap
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Display menu image if available
                                      // ignore: unnecessary_null_comparison
                                      if (item.imageUrl != null)
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 150,
                                            Uri.parse(
                                                    '${Endpoints.baseUAS}/static/storages/${item.imageUrl}')
                                                .toString(),
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Menu name
                                            Text(
                                              item.menuName,
                                              style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                color: const Color.fromARGB(
                                                    255, 36, 31, 31),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            // Menu price
                                            Text(
                                              'Rp. ${item.menuPrice}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                color: const Color.fromARGB(
                                                    255, 36, 31, 31),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            // Menu description
                                            Text(
                                              item.descMenu,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: const Color.fromARGB(
                                                    255, 36, 31, 31),
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 50,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: IconButton(
                                      icon: const Icon(Icons.shopping_cart,
                                          color: Color.fromARGB(
                                              255, 255, 20, 147)),
                                      onPressed: () {
                                        final cartCubit =
                                            BlocProvider.of<CartCubit>(context);
                                        cartCubit.addToCart(
                                            item); // Add menu item to cart
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text(
                              '${snapshot.error}')); // Display error message if data fetching fails
                    }
                    return const Center(
                        child:
                            CircularProgressIndicator()); // Display loading indicator while fetching data
                  },
                ),
              ),
              // Pagination buttons
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _decrementPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                      ),
                      child: const Text(
                        'Prev',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _incrementPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
