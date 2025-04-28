import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/user.dart';
import '../constant/share_pref.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._();
  static SharedPreferences? _sharedPreferences;

  factory UserPreferences() => _instance;

  UserPreferences._();

  static Future<void> initPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  SharedPreferences get _prefs {
    if (_sharedPreferences == null) {
      throw Exception("UserPreferences has not been initialized. Make sure to call initPreferences() first.");
    }
    return _sharedPreferences!;
  }

  Future<void> clearAll() async{
   await _prefs.clear();
  }
  Future<void> setValue<T>(String key, T value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is Map<String, dynamic> || value is List) {
      await _prefs.setString(key, jsonEncode(value));
    } else {
      throw Exception("Unsupported type for saving in SharedPreferences");
    }
  }

  T? getValue<T>(String key, {T? defaultValue}) {
    if (!_prefs.containsKey(key)) return defaultValue;
    if (T == String) return _prefs.getString(key) as T?;
    if (T == int) return _prefs.getInt(key) as T?;
    if (T == bool) return _prefs.getBool(key) as T?;
    if (T == double) return _prefs.getDouble(key) as T?;
    if (T == Map<String, dynamic>) {
      return jsonDecode(_prefs.getString(key) ?? "{}") as T;
    }
    if (T == List) {
      return jsonDecode(_prefs.getString(key) ?? "[]") as T;
    }
    return defaultValue;
  }

  Future<void> removeValue(String key) async => await _prefs.remove(key);

  Future<void> clearPreferences() async => await _prefs.clear();

  bool containsKey(String key) => _prefs.containsKey(key);



  bool get isLoggedIn => getValue<bool>(ConstantsSherPref.isLogged) ?? false;

  Future<int> get notifyCount async => getValue<int>(ConstantsSherPref.notifyCount) ?? 0;

  String get token => getValue<String>(ConstantsSherPref.token) ?? '';

  String get username => getValue<String>(ConstantsSherPref.username) ?? '';

  String get password => getValue<String>(ConstantsSherPref.password) ?? '';

  String get language => getValue<String>(ConstantsSherPref.language) ?? Platform.localeName.substring(0, 2);



  getBoolS(String key) {
    bool? boolValue = _prefs.getBool(key);

    return boolValue;
  }

  String getStringSFWithDefault(String key, String dfault) {
    return _prefs.getString(key) ?? dfault;
  }

  String getString(String key) {
    return _prefs.getString(key) ?? "";
  }

  Map<String, dynamic> getMap(String key) {
    String? data = _prefs.getString(key);
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    } else {
      return {};
    }
  }

  List<dynamic> getListDynamic(String key) {
    String? data = _prefs.getString(key);
    if (data != null) {
      return jsonDecode(data) as List<dynamic>;
    } else {
      return [];
    }
  }

  Future<dynamic> getBoolSF(String key) async {
    bool? boolValue = _prefs.getBool(key);
    return boolValue ?? false;
  }

  bool getBool(String key) {
    bool? boolValue = _prefs.getBool(key);
    return boolValue ?? false;
  }

  Future<dynamic> getIntValuesSF(String key) async {
    int? intValue = _prefs.getInt(key);
    return intValue;
  }

  int getInt(String key) {
    int? intValue = _prefs.getInt(key);
    return intValue ?? -1;
  }

  Future<dynamic> getDoubleValuesSF(String key) async {
    double? doubleValue = _prefs.getDouble(key);
    return doubleValue;
  }

  double getDouble(String key) {
    double? doubleValue = _prefs.getDouble(key);
    return doubleValue ?? 0.0;
  }



  Future<dynamic> removeAllValues() async {
    _prefs.clear();
  }

  Future setObject(String key, Object value) async {
    await _prefs.setString(key, jsonEncode(value));
  }

  User getUser() {
    Map<String, dynamic> map;
    String? userStr = getString(ConstantsSherPref.userInfo);
    print(userStr);
    if (userStr != null) {
      map = jsonDecode(userStr) as Map<String, dynamic>;
      return User.fromJson(map);
    } else {
      return User();
    }
  }
}