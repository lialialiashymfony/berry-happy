// Part directive to include this file as part of 'auth_cubit.dart'
part of 'auth_cubit.dart';

// Annotate the AuthState class as immutable, meaning its fields cannot be changed after it is created
@immutable
class AuthState {
  // Declare final fields for the state properties
  final bool isLoggedIn;
  final String accessToken;
  final int idPengguna;
  final String role;

  // Constructor to initialize the state properties, all fields are required
  const AuthState({
    required this.isLoggedIn, // Indicates if the user is logged in
    required this.accessToken, // Stores the access token
    required this.idPengguna, // Stores the user ID
    required this.role, // Stores the user's role
  });
}

// Define a subclass of AuthState for the initial state
class AuthInitialState extends AuthState {
  // Constructor to initialize the initial state with default values
  const AuthInitialState()
      : super(
            isLoggedIn: false, // User is not logged in
            accessToken: '', // Access token is an empty string
            idPengguna: -1, // User ID is set to -1 indicating no user
            role: 'customer'); // Role is set to 'customer'
}
