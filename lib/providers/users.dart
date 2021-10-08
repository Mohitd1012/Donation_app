import 'dart:convert';

import 'package:flutter_complete_guide/providers/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Users {
  static SharedPreferences _prefrences;
  static const _keyUser = 'user';
  static const myUser = User(
    name: "Full Name",
    email: "My email",
    address: "My Address",
    city: "My City",
    state: "My State",
    about: "About",
  );

  static Future init() async =>
      _prefrences = await SharedPreferences.getInstance();

  static Future setUser(User user) async {
    final json = jsonEncode(user.toJson());
    await _prefrences.setString(_keyUser, json);
  }

  static User getUser() {
    final json = _prefrences.getString(_keyUser);
    return json == null ? myUser : User.fromJson(jsonDecode(json));
  }
}
