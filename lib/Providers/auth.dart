import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Authentication with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Future<void> _authenticate(
      String email, String passwd, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:${urlSegment}?key=AIzaSyA3DklKXm98dF2dp919hSEVzdF6M9TBon0');
    try {
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
      print(json.decode(response.body));
      final resp = jsonDecode(response.body);
      if (resp['error' != null]) {
        throw HttpExceptions(resp['error']['message']);
      }
    } catch (err) {
      throw err;
    }
  }

  Future<void> signup(String email, String passwd) async {
    return _authenticate(email, passwd, "signUp");
  }

  Future<void> login(String email, String passwd) async {
    return _authenticate(email, passwd, "signInWithPassword");
  }
}
