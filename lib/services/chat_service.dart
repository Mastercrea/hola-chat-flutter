import 'package:flutter/material.dart';
import 'package:flutter_chat_app/global/environment.dart';
import 'package:flutter_chat_app/models/messages_response.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ChatService with ChangeNotifier {
  late User userFor;

  Future<List<Message>> getChat(String userId) async{

    final resp = await http.get(Uri.parse('${Environment.apiUrl}/messages/$userId'),
    headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken() ?? ''
    });
    final messagesResp = messagesResponseFromJson(resp.body);

    return messagesResp.messages;

  }

}