import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/address_model.dart';

class UserData {

  Future<String?> getStoredName() async{
    final prefs=await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  Future<String?> getStoredPhone() async{
    final prefs=await SharedPreferences.getInstance();
    return prefs.getString('userPhone');
  }

  Future<String?> getStoredEmail() async{
    final prefs=await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  Future<void> saveDefaultAddressToPrefs(AddressModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(model.toJson());
    await prefs.setString('address', jsonStr);
  }

  Future<void> clearDefaultInPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('address');
  }

  Future<AddressModel?> readDefaultAddressFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('address');
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final Map<String, dynamic> map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return AddressModel.fromJson(map);
    } catch (_) {
      // invalid stored json
      await clearDefaultInPrefs();
      return null;
    }
  }

  Future<void> clearUserPrefsData()async{
    final prefs = await SharedPreferences.getInstance();
    await clearDefaultInPrefs();
    await prefs.remove('userName');
    await prefs.remove('userPhone');
    await prefs.remove('userEmail');
  }
}
