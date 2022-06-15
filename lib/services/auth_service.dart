import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/global/environment.dart';
import 'package:flutter_chat_app/models/login_response.dart';
import 'package:flutter_chat_app/models/user.dart';

class AuthService with ChangeNotifier {
// create the user object empty
  User user = User(name: '', email: '', uid: '', online: false, google: false, img: 'no-image');

  // Create storage
  final _storage = new FlutterSecureStorage();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Static Getters token

  static Future<String?> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.isLoading = true;

    final data = {'email': email, 'password': password};

    final resp = await http.post(Uri.parse('${Environment.apiUrl}/login'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
    this.isLoading = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;
      // TODO: save token in a secure place
      await this._saveToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future register(String name, String email, String password) async {
    this.isLoading = true;
    final data = {'name': name, 'email': email, 'password': password};
    final resp = await http.post(Uri.parse('${Environment.apiUrl}/login/new'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));
    this.isLoading = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;
      // TODO: save token in a secure place
      await this._saveToken(loginResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token') ?? '';
    final resp = await http.get(Uri.parse('${Environment.apiUrl}/login/renew'),
        headers: {'Content-Type': 'application/json',
        'x-token': token });

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;
      await this._saveToken(loginResponse.token);

      return true;
    } else {
      this._logout();
      return false;
    }
  }
  Future savePicture(String imagePath) async {
    isLoading = true;
    final request = await http.MultipartRequest('PUT',
        Uri.parse('${Environment.apiUrl}/uploads/${user.uid}'));

    final picture = await http.MultipartFile.fromPath(
        'image',
        imagePath,
        filename: 'testPicture.png' );
    request.files.add(picture);
    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    // TODO: validate responsed.statusCode 200
    final responseData = json.decode(responsed.body);
    user.img = responseData['img'];
    isLoading = false;
    return responseData;
  }

  Future _saveToken(String token) async {
    // Write value
    return await _storage.write(key: 'token', value: token);
  }

  Future _logout() async {
    // Delete value
    await _storage.delete(key: 'token');
  }

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  Future signInWithGoogle() async {
    try {
      isLoading = true;
      final account = await _googleSignIn.signIn();
      final googleKey = await account!.authentication;

      // print(account);
      print('====== ID TOKEN ======');
      print(googleKey.idToken);

      final signInWithGoogleEndpoint = Uri(scheme: 'https', host: 'hola-chat-backend.herokuapp.com', path: '/api/login/google');

      final session =  await http.post(signInWithGoogleEndpoint, body: {'token': googleKey.idToken});

      print('===== backend =====');
      print(json.decode(session.body));


      if (session.statusCode == 200) {
        final LoginResponse loginResponse = loginResponseFromJson(session.body);
        user = loginResponse.user;
        await _saveToken(loginResponse.token);
        isLoading = false;
        return true;
      } else {
        isLoading = false;
        return false;
      }
    } catch (e) {
      isLoading = false;
      print('Error en GoogleSignIn');
      print(e);
      return false;
    }
  }

  static Future signOutWithGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print('Error en GoogleSignOut');
      print(e);
    }
  }
}
