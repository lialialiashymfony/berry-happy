import 'package:berry_happy/cart/cart_screen.dart';
import 'package:berry_happy/cubit/cart/cart_cubit.dart';
import 'package:berry_happy/cubit/cubit/auth_cubit.dart';
import 'package:berry_happy/dashboard/dashboard_consumer.dart';
import 'package:berry_happy/dashboard/dashboard_owner.dart';
import 'package:berry_happy/endpoints/endpoints.dart';
import 'package:berry_happy/launch/launch_screen.dart';
import 'package:berry_happy/login/login_screen.dart';
import 'package:berry_happy/login/main_login.dart';
import 'package:berry_happy/menu/add_menu.dart';
import 'package:berry_happy/navigation/navigation.dart';
import 'package:berry_happy/sign up/signup_screen.dart';
import 'package:berry_happy/utils/auth_wrapper.dart';
// ignore: unused_import
import 'package:berry_happy/utils/constants.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: unused_import
import 'package:google_fonts/google_fonts.dart';

// Entry point of the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Endpoints.initialize();
  runApp(const MyApp());
}

// Define the root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
            create: (context) =>
                AuthCubit()), // Provide AuthCubit to the application
        BlocProvider<CartCubit>(
            create: (context) =>
                CartCubit()) // Provide CartCubit to the application
      ],
      // MaterialApp widget for configuring the application
      child: MaterialApp(
        title: 'Flutter Demo', // Set application title
        debugShowCheckedModeBanner: false, // Disable debug banner
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple), // Set color scheme
          useMaterial3: true, // Enable Material3 design
        ),
        home: const LaunchScreen(), // Set initial screen to LaunchScreen
        // Define named routes for navigation
        routes: {
          '/login-screen': (context) => const LoginScreen(),
          '/cart': (context) => const CartScreen(),
          '/main-login': (context) => const MainLogin(),
          '/signup-screen': (context) => const SignUp(),
          // '/my-homepage': (context) => const MyHomePage(),
          '/add-menu': (context) => const AddMenu(),
          '/dashboard-consumer': (context) =>
              const AuthWrapper(child: DashboardConsumer()),
          '/dashboard-owner': (context) =>
              const AuthWrapper(child: DashboardOwner()),
          '/nav-customer': (context) => const MyHomePage(),
         
        },
      ),
    );
  }
}

// // Define a stateful widget for the main home page of the application
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// // State class for MyHomePage widget
// class _MyHomePageState extends State<MyHomePage> {
//   int activeIndex = 0; // Index of the currently active screen

//   final List<Widget> screens = [
//     // List of widgets representing screens in the application
//     const DashboardConsumer(),
//     const ConsumerProfile(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Scaffold widget for the main home page layout
//       // backgroundColor: Color.fromARGB(255, 250, 143, 195), // Commented out background color
//       extendBodyBehindAppBar: true, // Extend body behind the app bar
//       appBar: AppBar(
//         // AppBar widget for the top app bar
//         backgroundColor: const Color.fromARGB(
//             255, 255, 204, 229), // Set app bar background color
//         elevation: 0.0, // Remove app bar elevation
//         iconTheme: const IconThemeData(
//             color: Colors.black), // Set icon theme for app bar
//         title: Padding(
//           padding: const EdgeInsets.only(left: 3),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               // Text widget for app bar title
//               Text('BERRY HAPPY',
//                   style: GoogleFonts.poppins(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   )),
//               const SizedBox(width: 95), // SizedBox for spacing
//               GestureDetector(
//                 // GestureDetector for shopping cart icon
//                 onTap: () {
//                   Navigator.pushNamed(
//                       context, '/cart'); // Navigate to cart screen on tap
//                 },
//                 child: Stack(
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.only(right: 5),
//                       child: Icon(Icons.shopping_cart, color: Colors.black),
//                     ),
//                     Positioned(
//                       right: 0,
//                       top: 0,
//                       child: Container(
//                         padding: const EdgeInsets.all(1),
//                         decoration: BoxDecoration(
//                           color: Colors.red,
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         constraints: const BoxConstraints(
//                           minWidth: 12,
//                           minHeight: 12,
//                         ),
//                         child: const Text(
//                           '3',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 8,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: screens[activeIndex], // Set body content based on activeIndex
//       bottomNavigationBar: CurvedNavigationBar(
//         // CurvedNavigationBar widget for bottom navigation bar
//         backgroundColor:
//             Constants.scaffoldBackgroundColor, // Set background color
//         buttonBackgroundColor:
//             Constants.primaryColor, // Set button background color
//         color: const Color.fromARGB(
//             255, 255, 204, 229), // Set navigation bar color
//         items: [
//           // Define navigation bar items with icons
//           Icon(
//             Icons.home,
//             size: 30.0,
//             color: activeIndex == 0 ? Colors.white : Constants.activeMenu,
//           ),
//           Icon(
//             Icons.person,
//             size: 30.0,
//             color: activeIndex == 1 ? Colors.white : Constants.activeMenu,
//           ),
//           Icon(
//             Icons.settings,
//             size: 30.0,
//             color: activeIndex == 2 ? Colors.white : Constants.activeMenu,
//           ),
//         ],
//         onTap: (index) {
//           setState(() {
//             activeIndex = index; // Update activeIndex on tap
//           });
//         },
//       ),
//       drawer: Drawer(
//         // Drawer widget for side drawer menu
//         child: ListView(
//           padding: EdgeInsets.zero, // Set padding for ListView
//           children: [
//             const DrawerHeader(
//               // DrawerHeader widget for header section
//               decoration: BoxDecoration(
//                 color: Color.fromARGB(255, 255, 126, 188),
//               ),
//               child: Text(
//                 'Berry Happy', // Drawer header text
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             ListTile(
//               // ListTile widget for menu item
//               title: const Text('API'), // Menu item text
//               onTap: () {
//                 // Handle onTap event for menu item
//                 // Navigator.push(context,
//                 //     MaterialPageRoute(builder: (context) => NewsScreen())); // Example navigation action (commented out)
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }