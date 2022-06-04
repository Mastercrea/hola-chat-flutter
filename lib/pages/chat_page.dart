import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/messages_response.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/chat_service.dart';
import 'package:flutter_chat_app/services/socket_service.dart';
import 'package:flutter_chat_app/widgets/chat_message.dart';
import 'package:provider/provider.dart';

import '../theme.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}
// TickerProviderStateMixin for animations

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  List<ChatMessage> _messages = [];

  late ChatService chatService;
  late SocketService socketService;

  late AuthService authService;

  bool _writing = false;

  @override
  void initState() {
    // Providers
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.socketService.socket.on('personal-message', _listenMessage);
    _loadHistoryMessages(this.chatService.userFor.uid);
    super.initState();
  }

  void _loadHistoryMessages(String userUid) async {
    List<Message> chat = await this.chatService.getChat(userUid);
    final history = chat.map((m) => ChatMessage(
        text: m.message,
        uid: m.from,
        animationController: new AnimationController(
            vsync: this, duration: Duration(milliseconds: 0))..forward()));
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _listenMessage(dynamic payload) {
    print('Have a message: $payload');
    ChatMessage message = new ChatMessage(
        text: payload['message'],
        uid: payload['from'],
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 300)));
    setState(() {
      _messages.insert(0, message);
    });
    //*Required* run the animation
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final userFor = chatService.userFor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text(userFor.name.substring(0, 2),
                  style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 16,
            ),
            SizedBox(height: 3),
            Text(userFor.name,
                style: TextStyle(color: Colors.black87, fontSize: 12))
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Center(
        child: Container(
            child: Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _messages[i],
              reverse: true,
            )),
            Divider(height: 1),
            Container(
              color: textSecondaryColor,
            ),
            _inputChat()
          ],
        )),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Flexible(
                    child: TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmit,
                  onChanged: (String text) {
                    setState(() {
                      if (text.length > 0) {
                        _writing = true;
                      } else {
                        _writing = false;
                      }
                    });
                  },
                  decoration:
                      InputDecoration.collapsed(hintText: 'Send Message'),
                  focusNode: _focusNode,
                )),
                // Button send
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Platform.isIOS
                      ? CupertinoButton(
                          child: Text('Send'),
                          onPressed: _writing
                              ? () => _handleSubmit(_textController.text.trim())
                              : null)
                      : Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          child: IconTheme(
                            data: IconThemeData(color: Colors.blue[400]),
                            child: IconButton(
                                onPressed: _writing
                                    ? () => _handleSubmit(
                                        _textController.text.trim())
                                    : null,
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                icon: Icon(Icons.send)),
                          ),
                        ),
                )
              ],
            )));
  }

  _handleSubmit(String text) {
    if (text.length == 0) return;
    print(text);
    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = new ChatMessage(
        text: text,
        uid: authService.user.uid,
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 200)));
    _messages.insert(0, newMessage);
    // trigger for the animation
    newMessage.animationController.forward();

    setState(() {
      _writing = false;
    });


    this.socketService.emit('personal-message', {
      'from': this.authService.user.uid,
      'for': this.chatService.userFor.uid,
      'message': text
    });
  }

  @override
  void dispose() {
    // clean all the animations controller of the messages
    // TODO: off socket
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    this.socketService.socket.off('personal-message');
    super.dispose();
  }
}
