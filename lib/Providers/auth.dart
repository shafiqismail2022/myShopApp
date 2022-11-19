import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Authentication with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signup(String email, String passwd) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA3DklKXm98dF2dp919hSEVzdF6M9TBon0 ');
    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': passwd,
          'returnSecureToken': true,
        },
      ),
    );
    print(response.body);
  }
}
