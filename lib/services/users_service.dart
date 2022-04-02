import 'package:flutter_chat_app/global/environment.dart';
import 'package:flutter_chat_app/models/users_response.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chat_app/models/user.dart';


class UsersService {
  Future<List<User>> getUsers() async{

    try{
      final String token = await AuthService.getToken() ?? '';
      final resp = await http.get(Uri.parse('${Environment.apiUrl}/users'),
        headers: {
        'Content-Type': 'application/json',
          'x-token'   : token
        }
      );

      final usersResponse = usersResponseFromJson(resp.body);
      return usersResponse.users;

    }
    catch(err){
      print(err);
      return [];
    }

  }
}