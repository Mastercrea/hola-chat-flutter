import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}
// TickerProviderStateMixin for animations

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  List<ChatMessage> _messages = [

  ];

  bool _writing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text('Te', style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 16,
            ),
            SizedBox(height: 3),
            Text('Mary Ontiveros',
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
            // Todo: Caja de Texto
            Container(
              color: Colors.white,
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
                          child: Text('Enviar'),
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
     final newMessage = new ChatMessage(text: text, uid: '123',
       animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)));
     _messages.insert(0,newMessage);
     // trigger for the animation
     newMessage.animationController.forward();

    setState(() {
      _writing = false;
    });
  }
  @override
  void dispose() {
    // clean all the animations controller of the messages
    // TODO: off socket
    for( ChatMessage message in _messages){
      message.animationController.dispose();
    }
    super.dispose();
  }
}
