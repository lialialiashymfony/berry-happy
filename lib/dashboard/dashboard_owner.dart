import 'package:berry_happy/components/customsearch.dart'; // Import CustomSearchBox widget
import 'package:berry_happy/cubit/cubit/auth_cubit.dart'; // Import AuthCubit
import 'package:berry_happy/dto/menu.dart'; // Import Menu DTO
import 'package:berry_happy/endpoints/endpoints.dart'; // Import Endpoints for API URLs
import 'package:berry_happy/menu/add_menu.dart'; // Import AddMenu page
import 'package:berry_happy/menu/edit_menu.dart'; // Import EditMenu page
import 'package:flutter/material.dart'; // Flutter material library
import 'package:flutter_bloc/flutter_bloc.dart'; // Flutter BLoC library
import 'package:google_fonts/google_fonts.dart'; // Google Fonts for text styling
import 'package:berry_happy/services/data_service.dart'; // DataService for API calls

// Define a StatefulWidget for the DashboardOwner
class DashboardOwner extends StatefulWidget {
  // ignore: use_super_parameters
  const DashboardOwner({Key? key}) : super(key: key);

  @override
  State<DashboardOwner> createState() => _DashboardOwnerState();
}

// Define the state class _DashboardOwnerState that manages the widget's state
class _DashboardOwnerState extends State<DashboardOwner> {
  Future<List<Menu>>? _menu; // Future to hold the list of menus
  late TextEditingController
      _searchController; // Controller for the search input
  int currentPage = 1; // Variable to keep track of the current page number

  @override
  void initState() {
    super.initState();
    _searchController =
        TextEditingController(); // Initialize the search controller
    _fetchData(currentPage); // Fetch initial data
  }

  // Method to fetch data from the API based on the page number
  void _fetchData(int page) {
    setState(() {
      final token = context.read<AuthCubit>().state.accessToken;
      _menu = DataService.fetchMenu1(
        currentPage,
        _searchController.text,
        token,
      ); // Fetch menu data asynchronously
    });
  }

  // Method to increment the current page number and fetch data for the next page
  void _incrementPage() {
    setState(() {
      currentPage++;
      _fetchData(currentPage);
    });
  }

  // Method to decrement the current page number and fetch data for the previous page
  void _decrementPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
        _fetchData(currentPage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCubit =
        BlocProvider.of<AuthCubit>(context); // Get instance of AuthCubit

    // Scaffold widget for the main UI structure
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 204, 229),
        title: const Text('Berry Happy'), // AppBar title
      ),
      drawer: Drawer(
        // Drawer for navigation options
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
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                authCubit.logout(); // Call logout method from AuthCubit
                Navigator.pushReplacementNamed(
                    context, '/login-screen'); // Navigate to login screen
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 255, 204, 229),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Search Box
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSearchBox(
                    controller: _searchController,
                    onChanged: (value) => _fetchData(
                        currentPage), // Update search results on text change
                    onClear: (value) =>
                        _fetchData(currentPage), // Clear search results
                    hintText: 'search'),
              ),

              // const Divider(color: Colors.white),

              // Profile, Restaurant Name, and Rating Section
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
                        backgroundImage: AssetImage(
                            'assets/images/logo.png'), // Add your image asset here
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
              const SizedBox(height: 30),

              // List of Menus Section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 204, 229),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: FutureBuilder<List<Menu>>(
                  future: _menu, // Future containing the list of menus
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item =
                              data[index]; // Get menu item at current index
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            padding: const EdgeInsets.all(20.0),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Display menu details
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            // ignore: unnecessary_string_interpolations
                                            '${item.menuName}', // Menu name
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              color: const Color.fromARGB(
                                                  255, 36, 31, 31),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Rp. ${item.menuPrice}', // Menu price
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color: const Color.fromARGB(
                                                  255, 36, 31, 31),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            // ignore: unnecessary_string_interpolations
                                            '${item.descMenu}', // Menu description
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: const Color.fromARGB(
                                                  255, 36, 31, 31),
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Display menu image if available with edit and delete buttons
                                    // ignore: unnecessary_null_comparison
                                    if (item.imageUrl != null)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                fit: BoxFit.cover,
                                                width: 100,
                                                height: 100,
                                                Uri.parse(
                                                        '${Endpoints.baseUAS}/static/storages/${item.imageUrl}')
                                                    .toString(),
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    const Icon(Icons.error),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.edit,
                                                      color: Colors
                                                          .blue), // Edit button
                                                  onPressed: () {
                                                    final accessToken = context
                                                        .read<AuthCubit>()
                                                        .state
                                                        .accessToken;
                                                    _editMenu(item,
                                                        accessToken); // Call edit menu method
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.delete,
                                                      color: Colors
                                                          .red), // Delete button
                                                  onPressed: () {
                                                    final accessToken = context
                                                        .read<AuthCubit>()
                                                        .state
                                                        .accessToken;
                                                    _deleteMenu(item.idMenu,
                                                        accessToken); // Call delete menu method
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ],
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

              // Pagination Buttons
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
                      child: Text(
                        "prev", // Button text
                        style: GoogleFonts.poppins(
                            fontSize: 15, color: Colors.white), // Styling
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _incrementPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                      ),
                      child: Text(
                        "next", // Button text
                        style: GoogleFonts.poppins(
                            fontSize: 15, color: Colors.white), // Styling
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Floating Action Button for adding new menu items
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const AddMenu()), // Navigate to AddMenu page
          );
          if (result == true) {
            setState(() {
              _menu = DataService
                  .fetchMenu(); // Refresh menu list after adding new item
            });
          }
        },
        backgroundColor: const Color.fromARGB(225, 223, 6, 112), // Button color
        child: const Icon(Icons.add), // Add icon
      ),
    );
  }

  // Method to navigate to EditMenu page for editing a menu item
  void _editMenu(Menu menu, String accessToken) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditMenu(
                menu: menu,
                accessToken: accessToken,
              )), // Navigate to EditMenu page with menu data
    );
    if (result == true) {
      setState(() {
        _menu = DataService.fetchMenu(); // Refresh menu list after editing
      });
    }
  }

  // Method to delete a menu item
  void _deleteMenu(int menuId, String accessToken) async {
    final success = await DataService.deleteMenu(
        menuId, accessToken); // Call deleteMenu method from DataService
    if (success) {
      setState(() {
        _menu = DataService.fetchMenu(); // Refresh menu list after deleting
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Failed to delete menu')), // Show error message if deletion fails
      );
    }
  }
}
