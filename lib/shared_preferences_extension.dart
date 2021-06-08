library shared_preferences_extension;

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

class SpExtension {
  static SpExtension? _singletion;
  static SharedPreferences? _prefs;
  static Lock _lock = Lock();

  static Future<SpExtension?> getInstance() async {
    if (_singletion == null) {
      await _lock.synchronized(() async {
        if (_singletion == null) {
          var singleton = SpExtension._();
          await singleton._init();
          _singletion = singleton;
        }
      });
    }
    return _singletion;
  }

  SpExtension._();

  _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// save 是一个异步过程, get 是同步过程
  /// object
  static Future<bool>? putObject(String key, Object object) {
    return _prefs?.setString(key, json.encode(object));
  }

  static Map? getObject(String key) {
    String? str = _prefs?.getString(key);
    return (str == null || str.isEmpty)? null: json.decode(str);
  }

  static T? getObj<T>(String key, T? f(Map m), {T? defaultValue}) {
    Map? m = getObject(key);
    return m == null? defaultValue: f(m);
  }

  /// object list
  static Future<bool>? putObjectList(String key, List<Object> list) {
    List<String>? str_list = list.map((e) => json.encode(e)).toList();
    return _prefs?.setStringList(key, str_list);
  }

  static List<Map>? getObjectList(String key) {
    List<String>? list = _prefs?.getStringList(key);
    List<Map>? mapList = list?.map((e) => json.decode(e) as Map).toList();
    return mapList;
  }

  static List<T>? getObjList<T>(String key, T? f(Map m), {List<T>? defaultValue = const []}) {
    List<Map>? mapList = getObjectList(key);
    List<T>? list = mapList?.map((e) => f(e) as T).toList();
    return list ?? defaultValue;
  }

  /// string
  static Future<bool>? putString(String key, String value) {
    return _prefs?.setString(key, value);
  }

  static String? getString(String key, {String? defaultValue = ''}) {
    return _prefs?.getString(key) ?? defaultValue;
  }

  /// bool
  static Future<bool>? putBool(String key, bool value) {
    return _prefs?.setBool(key, value);
  }

  static bool? getBool(String key, {bool defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  /// int
  static Future<bool>? putInt(String key, int value) {
    return _prefs?.setInt(key, value);
  }

  static int? getInt(String key, {int? defaultValue = 0}) {
    return _prefs?.getInt(key) ?? defaultValue;
  }

  /// double
  static Future<bool>? putDouble(String key, double value) {
    return _prefs?.setDouble(key, value);
  }

  static double? setDouble(String key, {double? defaultValue = 0.0}) {
    return _prefs?.getDouble(key) ?? defaultValue;
  }

  /// string list
  static Future<bool>? putStringList(String key, List<String> list) {
    return _prefs?.setStringList(key, list);
  }

  static List<String>? getStringList(String key, {List<String>? defaultValue = const []}) {
    return _prefs?.getStringList(key) ?? defaultValue;
  }

  /// dynamic
  static dynamic getDynamic(String key, {Object? defaultValue}) {
    return _prefs?.get(key) ?? defaultValue;
  }

  /// have key
  static bool? haveKey(String key) {
    return _prefs?.getKeys().contains(key);
  }

  /// contains key
  static bool? containsKey(String key) {
    return _prefs?.containsKey(key);
  }

  /// get keys
  static Set<String>? getKeys() {
    return _prefs?.getKeys();
  }

  /// remove
  static Future<bool>? remove(String key) {
    return _prefs?.remove(key);
  }

  /// clear
  static Future<bool>? clear() {
    return _prefs?.clear();
  }

  /// Fetches the latest values from the host platform.
  static Future<void>? reload() {
    return _prefs?.reload();
  }

  static bool isInitialized() {
    return _prefs != null;
  }

  /// get sp
  static SharedPreferences? getSp() {
    return _prefs;
  }
}
