import 'dart:convert';
import 'package:berry_happy/components/assets_image_widget.dart';
import 'package:berry_happy/cubit/cubit/auth_cubit.dart';
import 'package:berry_happy/dto/login.dart';
import 'package:berry_happy/login/input_url_page.dart';
import 'package:berry_happy/services/data_service.dart';
import 'package:berry_happy/utils/constants.dart';
import 'package:berry_happy/utils/secure_storage_util.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MainLogin extends StatefulWidget {
  const MainLogin({super.key}); // Constructor for MainLogin class

  @override
  State<MainLogin> createState() =>
      _MainLoginState(); // Creates state for MainLogin
}

class _MainLoginState extends State<MainLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String url = '';
  void mssg() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('IP API IS EMPTY!')),
    );
  }

  void cekUrl() async {
    url = (await SecureStorageUtil.storage.read(key: 'url_setting'))!;
    if (url.isEmpty) {
      mssg();
      return;
    }
  }

  void sendLogin(context, AuthCubit authCubit) async {
    final email = _emailController.text;
    final password = _passwordController.text;
    debugPrint(email); // Prints email to debug console
    debugPrint(password); // Prints password to debug console

    cekUrl();

    try {
      final response = await DataService.sendLoginData(
          email, password); // Sends login data to DataService
      debugPrint(response.statusCode
          .toString()); // Prints status code of response to debug console

      if (response.statusCode == 200) {
        debugPrint(
            "sending success"); // Prints success message to debug console
        final data =
            jsonDecode(response.body); // Decodes response body from JSON
        final loggedIn =
            Login.fromJson(data); // Converts JSON data to Login object
        await SecureStorageUtil.storage.write(
            key: tokenStoreName,
            value: loggedIn.accessToken); // Stores access token securely
        authCubit.login(
            loggedIn.accessToken,
            loggedIn.idUser,
            loggedIn
                .role); // Calls login method on authCubit with accessToken, idUser, and role
        if (loggedIn.role == 'owner') {
          Navigator.pushReplacementNamed(context,
              "/dashboard-owner"); // Navigates to dashboard-owner route if role is 'owner'
        } else if (loggedIn.role == 'customer') {
          Navigator.pushReplacementNamed(context, "/nav-customer");
        }
        debugPrint(loggedIn.accessToken); // Prints accessToken to debug console
      } else {
        debugPrint("failed not"); // Prints failure message to debug console
      }
    } catch (eror) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Internet')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(
        context); // Retrieves authCubit from BlocProvider
    return Scaffold(
      backgroundColor: const Color.fromARGB(
          255, 255, 204, 229), // Sets background color of Scaffold

      body: SingleChildScrollView(
        // Allows scrolling if the content overflows
        child: Padding(
          padding: const EdgeInsets.only(
              top: 60, left: 75, right: 60), // Sets padding around the content
          child: Center(
            child: Column(
              children: [
                const AssetImageWidget(
                    imagePath:
                        'assets/images/logo.png', // Specifies path for logo image
                    height: 250, // Sets height of logo image widget
                    width: 250, // Sets width of logo image widget
                    fit: BoxFit
                        .fill), // Defines how the image should be inscribed into the box

                const SizedBox(
                    height: 20), // Creates fixed size box for vertical spacing

                const Text(
                  'Welcome,', // Displays welcome text
                  style: TextStyle(
                      fontSize: 30, // Sets font size
                      fontWeight: FontWeight.bold, // Sets font weight
                      color:
                          Color.fromARGB(255, 255, 65, 158)), // Sets text color
                ),

                const Text(
                  'Sign in to continue!', // Displays instruction text
                  style: TextStyle(
                    fontSize: 18, // Sets font size
                    color: Color.fromARGB(255, 53, 2, 63), // Sets text color
                  ),
                ),

                const SizedBox(
                    height: 20), // Creates fixed size box for vertical spacing

                TextField(
                  controller:
                      _emailController, // Binds controller to email TextField
                  style: const TextStyle(
                    fontWeight: FontWeight.normal, // Sets font weight
                    fontSize: 16, // Sets font size
                    color:
                        Color.fromARGB(255, 168, 168, 168), // Sets text color
                  ),
                  keyboardType: TextInputType
                      .emailAddress, // Specifies input type as email address
                  textInputAction:
                      TextInputAction.next, // Specifies action button as 'Next'
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.0,
                          color: Color.fromARGB(
                              255, 102, 7, 128)), // Sets border width and color
                      borderRadius:
                          BorderRadius.circular(10), // Sets border radius
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.0,
                          color: Color.fromARGB(255, 102, 7,
                              128)), // Sets focused border width and color
                      borderRadius: BorderRadius.circular(
                          10), // Sets focused border radius
                    ),
                    hintText: 'Username', // Sets hint text for TextField
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.normal, // Sets hint font weight
                      fontSize: 16, // Sets hint font size
                      color: Color.fromARGB(
                          255, 110, 110, 110), // Sets hint text color
                    ),
                    fillColor: Colors.white, // Sets fill color of TextField
                    filled: true, // Enables filling of TextField
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12), // Sets content padding
                  ),
                ),

                const SizedBox(
                    height: 16), // Creates fixed size box for vertical spacing

                TextField(
                  controller:
                      _passwordController, // Binds controller to password TextField
                  style: const TextStyle(
                    fontWeight: FontWeight.normal, // Sets font weight
                    fontSize: 16, // Sets font size
                    color:
                        Color.fromARGB(255, 168, 168, 168), // Sets text color
                  ),
                  keyboardType: TextInputType
                      .visiblePassword, // Specifies input type as visible password
                  textInputAction:
                      TextInputAction.done, // Specifies action button as 'Done'
                  obscureText: true, // Hides entered text
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.0,
                          color: Color.fromARGB(
                              255, 102, 7, 128)), // Sets border width and color
                      borderRadius:
                          BorderRadius.circular(10), // Sets border radius
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1.0,
                          color: Color.fromARGB(255, 102, 7,
                              128)), // Sets focused border width and color
                      borderRadius: BorderRadius.circular(
                          10), // Sets focused border radius
                    ),
                    hintText: 'Password', // Sets hint text for TextField
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.normal, // Sets hint font weight
                      fontSize: 16, // Sets hint font size
                      color: Color.fromARGB(
                          255, 110, 110, 110), // Sets hint text color
                    ),
                    fillColor: Colors.white, // Sets fill color of TextField
                    filled: true, // Enables filling of TextField
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12), // Sets content padding
                  ),
                ),

                const SizedBox(
                    height: 30), // Creates fixed size box for vertical spacing

                SizedBox(
                  height: 50, // Sets height of ElevatedButton
                  child: ElevatedButton(
                    onPressed: () {
                      sendLogin(context,
                          authCubit); // Calls sendLogin method on button press
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 65,
                          158), // Sets background color of ElevatedButton
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            30), // Sets border radius of ElevatedButton
                      ),
                    ),
                    child: Text(
                      'Login', // Displays text on ElevatedButton
                      style: GoogleFonts.poppins(
                        color:
                            Colors.black, // Sets text color of ElevatedButton
                        fontSize: 18, // Sets font size of ElevatedButton text
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InputUrlPage()),
          );
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.wifi),
      ),
    );
  }
}
