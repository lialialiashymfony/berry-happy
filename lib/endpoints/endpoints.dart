import 'package:berry_happy/utils/secure_storage_util.dart';

class Endpoints {
  static late String baseUAS;

  static Future<void> initialize() async {
    final urlInput = await SecureStorageUtil.storage.read(key: 'url_setting');
    baseUAS = urlInput ?? "default_url_if_not_found";
  }

  // Menu endpoints
  static String get menuRead => "$baseUAS/api/v1/menu/read";
  static String get menuCreate => "$baseUAS/api/v1/menu/create";
  static String get menuDelete => "$baseUAS/api/v1/menu/delete";
  static String get menuUpdate => "$baseUAS/api/v1/menu/update";

  // Authentication endpoint
  static String get login => "$baseUAS/api/v1/auth/login";
  static String get register => "$baseUAS/api/v1/auth/register";
}
