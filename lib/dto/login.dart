// Define a class named Login to represent the login response data
class Login {
  // Declare final variables to hold login response data
  final String accessToken; // Access token received from the server
  final String tokenType; // Token type (e.g., Bearer)
  final int expiresIn; // Expiry duration of the access token (in seconds)
  final int idUser; // ID of the logged-in user
  final String role; // Role of the logged-in user

  // Constructor to initialize the Login object with required parameters
  Login({
    required this.accessToken, // Initialize accessToken parameter
    required this.tokenType, // Initialize tokenType parameter
    required this.expiresIn, // Initialize expiresIn parameter
    required this.idUser, // Initialize idUser parameter
    required this.role, // Initialize role parameter
  });

  // Factory constructor to create a Login object from a JSON map
  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      accessToken: json['access_token']
          as String, // Extract access_token from JSON and cast it to String
      tokenType: json['type']
          as String, // Extract type from JSON and cast it to String
      expiresIn: json['expires_in']
          as int, // Extract expires_in from JSON and cast it to int
      idUser:
          json['iduser'] as int, // Extract iduser from JSON and cast it to int
      role: json['role']
          as String, // Extract role from JSON and cast it to String
    );
  }
}
