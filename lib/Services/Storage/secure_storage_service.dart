import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService{
  static const _storage = FlutterSecureStorage();
  static const _passwordKey='user_password';
  static const _tokenKey='auth_token';

  Future<void> savePassword(String pass)async{
    await _storage.write(key: _passwordKey, value: pass);
  }

 Future<String?> getPassword() async{
    final res = await _storage.read(key: _passwordKey);
    return res ;
 }

Future<void> clearPassword() async{
    await _storage.delete(key: _passwordKey);
}

  Future<void> saveToken(String token)async{
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async{
    final res = await _storage.read(key: _tokenKey);
    return res ;
  }

  Future<void> clearToken() async{
    await _storage.delete(key: _tokenKey);
  }
}