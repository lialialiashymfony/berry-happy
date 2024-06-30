// Import Flutter Secure Storage package
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Define AndroidOptions for secure storage configuration
const androidOptions = AndroidOptions(
  encryptedSharedPreferences:
      true, // Enable encrypted shared preferences for Android
);

// Define a utility class SecureStorageUtil
class SecureStorageUtil {
  // Define a static constant storage of type FlutterSecureStorage initialized with androidOptions
  static const storage = FlutterSecureStorage(aOptions: androidOptions);
}
