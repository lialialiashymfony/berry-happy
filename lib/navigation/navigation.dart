import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:berry_happy/utils/constants.dart';
import 'package:berry_happy/background/background.dart';
import 'package:berry_happy/dashboard/dashboard_consumer.dart';
import 'package:berry_happy/menu/menu_history.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: use_super_parameters
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Berry Happy',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(),
      routes: {
        '/': (context) => const MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<CheckoutHistory> history = [];
  int checkoutIndex = 1;
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const DashboardConsumer(),
      const CafeBackgroundScreen(),
      MenuHistory(onAddNewCheckout: (newCheckout) {
        setState(() {
          history.add(newCheckout);
          checkoutIndex = newCheckout.index + 1;
        });
      }), // Pass the history list to MenuHistory
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: screens[activeIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Constants.scaffoldBackgroundColor,
        buttonBackgroundColor: Constants.primaryColor,
        color: const Color.fromARGB(255, 255, 204, 229),
        items: [
          Icon(
            Icons.home,
            size: 30.0,
            color: activeIndex == 0 ? Colors.white : Constants.activeMenu,
          ),
          Icon(
            Icons.food_bank,
            size: 30.0,
            color: activeIndex == 1 ? Colors.white : Constants.activeMenu,
          ),
          Icon(
            Icons.history,
            size: 30.0,
            color: activeIndex == 2 ? Colors.white : Constants.activeMenu,
          ),
        ],
        onTap: (index) {
          setState(() {
            activeIndex = index;
          });
        },
      ),
    );
  }
}
