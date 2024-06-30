// Import necessary packages and files
import 'package:berry_happy/cubit/cubit/auth_cubit.dart';
import 'package:berry_happy/login/login_screen.dart';
import 'package:berry_happy/utils/constants.dart';
import 'package:berry_happy/utils/secure_storage_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Define a StatelessWidget class named AuthWrapper
class AuthWrapper extends StatelessWidget {
  final Widget child; // Property to hold the child widget to display
  // ignore: use_super_parameters
  const AuthWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtain the AuthCubit instance from the nearest BlocProvider
    final authCubit = BlocProvider.of<AuthCubit>(context);

    // FutureBuilder to asynchronously fetch and display data
    return FutureBuilder<String?>(
      // Invoke method to get access token from secure storage
      future: _getAccessTokenFromSecureStorage(),
      // Builder function to handle different states of the future
      builder: (context, snapshot) {
        final storedAccessToken =
            snapshot.data; // Retrieve the access token from snapshot

        // Check if the future has completed
        if (snapshot.connectionState == ConnectionState.done) {
          // Check if there's a stored access token and it matches the current authCubit's state
          if (storedAccessToken != null &&
              storedAccessToken == authCubit.state.accessToken) {
            return child; // Display the child widget if tokens match
          } else {
            return const LoginScreen(); // Redirect to LoginScreen if no token or mismatch
          }
        } else {
          // Show a loading indicator while fetching the token
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // Asynchronous method to retrieve access token from secure storage
  Future<String?> _getAccessTokenFromSecureStorage() async {
    try {
      final accessToken = await SecureStorageUtil.storage
          .read(key: tokenStoreName); // Read access token from secure storage
      return accessToken; // Return the retrieved access token
    } catch (e) {
      // Handle potential errors (e.g., storage unavailable, decryption issues)
      debugPrint(
          'Error while retrieving access token: $e'); // Print error message to debug console
      return null; // Return null if an error occurs
    }
  }
}
