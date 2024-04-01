import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:laundryonapp_laundromat/Models/authData.dart';
import 'package:laundryonapp_laundromat/Models/authResponse.dart';

import 'package:laundryonapp_laundromat/Provider/authData_provider.dart';

Future<AuthData?> authenticateUser(
    String email, String password, WidgetRef ref) async {
  const url = 'http://68.183.204.241/laundromart/login/';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final authData = AuthData.fromJson(jsonResponse);
      print(response.body);
      return authData;
    } else {
      print('Failed to authenticate user. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error occurred while authenticating: $e');
  }
  return null;
}
