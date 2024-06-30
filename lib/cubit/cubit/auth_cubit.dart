import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

// Include the part file for AuthState
part 'auth_state.dart';

// Define the AuthCubit class that extends Cubit with a state of type AuthState
class AuthCubit extends Cubit<AuthState> {
  // Constructor initializes the state with AuthInitialState
  AuthCubit() : super(const AuthInitialState());

  // Method to log in a user
  void login(String accessToken, int idUser, String role) {
    // Emit a new state with the user logged in
    emit(AuthState(
        isLoggedIn: true, // Set isLoggedIn to true
        accessToken: accessToken, // Set the access token
        idPengguna: idUser, // Set the user ID
        role: role // Set the user role
        ));
  }

  // Method to log out a user
  void logout() {
    // Emit a new state with the user logged out and default values
    emit(const AuthState(
        isLoggedIn: false, // Set isLoggedIn to false
        accessToken: "", // Clear the access token
        idPengguna: -1, // Set the user ID to -1 (indicating no user)
        role: "customer" // Set the role to "customer"
        ));
  }
}
