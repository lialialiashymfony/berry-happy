import 'dart:convert';
import 'package:berry_happy/components/constants.dart';
import 'package:berry_happy/dto/menu.dart';
import 'package:berry_happy/endpoints/endpoints.dart';
import 'package:berry_happy/utils/secure_storage_util.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class DataService {
  static Future<List<Menu>> fetchMenu() async {
    final response = await http.get(Uri.parse(Endpoints.menuRead));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Menu.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      // Handle error
      throw Exception('Failed to load data ${response.statusCode}');
    }
  }

  static Future<List<Menu>> fetchMenu1(
      int page, String search, String accessToken) async {
    // ignore: unnecessary_string_interpolations

    if (accessToken.isEmpty) {
      accessToken =
          (await SecureStorageUtil.storage.read(key: tokenStoreName))!;
    }
    // ignore: unnecessary_string_interpolations
    final uri = Uri.parse('${Endpoints.menuRead}').replace(queryParameters: {
      'search': search,
      'page': page.toString(),
    });
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Menu.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load datas');
    }
  }

  static Future<bool> deleteMenu(int menuId, String accessToken) async {
    final response = await http.delete(
      Uri.parse('${Endpoints.menuDelete}/$menuId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    return response.statusCode == 200;
  }

  //post login with email and password
  static Future<http.Response> sendLoginData(
      String email, String password) async {
    final url = Uri.parse(Endpoints.login);
    debugPrint("$email test");
    debugPrint("$password test");

    final data = {'username_user': email, 'pass_user': password};

    final response = await http.post(
      url,
      headers: {'Content-type': 'application/json'},
      body: jsonEncode(data),
    );
    return response;
  }

  static Future<http.Response> sendSignUpData(
      String email, String password) async {
    final url = Uri.parse(Endpoints.register);
    final data = {'username_user': email, 'pass_user': password};
    final response = await http.post(
      url,
      headers: {'Content-type': 'application/json'},
      body: jsonEncode(data),
    );
    return response;
  }
}
