import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UtilsSharedPreferences{
  Future<SharedPreferences> get sf async => await SharedPreferences.getInstance();

  Future setString(String key, String value)async{
    return (await sf).setString(key, value);
  }
  Future<String> getString(String key)async{
    return (await sf).getString(key)??"";
  }

  Future setObject(String key, dynamic value)async{
    (await sf).setString(key, json.encode(value));
  }

  Future<String?> getObject(String key)async{
    return (await sf).getString(key);
  }

  Future clearObject(String key)async{
    (await sf).remove(key);
  }
}