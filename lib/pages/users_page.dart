import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/socket_service.dart';
import 'package:flutter_chat_app/services/chat_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../app_theme.dart';
import '../helpers/show_notification.dart';

import '../services/users_service.dart';
import '../widgets/user_circle_avatar.dart';

class UsersPage extends StatefulWidget {
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  AuthService authService = AuthService();
  SocketService socketService = SocketService();

  final usersService = new UsersService();
  List<User> users = [];
  var idLastChatOpen = '';
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _loadUsers();
    authService = Provider.of<AuthService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('personal-notification', _newMessage);
    socketService.socket.on('new-user-status', (_) => _loadUsers());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = authService.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(user.name,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22)),
        centerTitle: true,

        //   bottom: PreferredSize(
        //       child: Text("Title 2"),
        //       preferredSize: null),
        // )
        elevation: 1,
        backgroundColor: AppTheme.primaryColor,
        // leading: IconButton(
        //   icon: Icon(Icons.exit_to_app, color: Colors.black87),
        //   onPressed: () {
        //     socketService.disconnect();
        //     Navigator.pushReplacementNamed(context, 'login');
        //     AuthService.deleteToken();
        //   },
        // ),
        actions: <Widget>[
          GestureDetector(
            onTap: (socketService.serverStatus == ServerStatus.Online)
                ? () => shortToast('Connected to server')
                : () => shortToast('Disconnected from server'),
            child: Container(
                margin: EdgeInsets.only(
                  right: 10,
                ),
                // child: Icon(Icons.check_circle), color: Colors.blue[400],
                child: (socketService.serverStatus == ServerStatus.Online)
                    ? Icon(Icons.check_circle, color: Colors.blue[400])
                    : Icon(Icons.offline_bolt, color: Colors.red)),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        child: _listViewUsers(),
        enablePullDown: true,
        // action to load the data
        onRefresh: _loadUsers,
        header: WaterDropHeader(
          complete: Icon(Icons.check),
          waterDropColor: Colors.blue,
        ),
      ),
    );
  }

  _newMessage(dynamic payload) {
    print(payload);
    if (idLastChatOpen != payload['from']) {
      for (var e in users) {
        {
          if (e.uid == payload['from']) {
            showNotification(e.name, payload['message']);
            break;
          }
        }
        ;
      }
    }
  }

  _listViewUsers() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _userListTile(users[i]),
        separatorBuilder: (_, i) => Divider(),
        itemCount: users.length);
  }

  ListTile _userListTile(User user) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      leading: UserCircleAvatar(user: user),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        idLastChatOpen = user.uid;
        chatService.userFor = user;
        Navigator.pushNamed(context, 'chat').then((_) => {
              idLastChatOpen = '',
            });
      },
    );
  }

  shortToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Color(0xff16DCF2),
        timeInSecForIosWeb: 1);
  }

  // Widget userCircleAvatar (user) {
  //   if (user.img != null && Uri.parse(user.img!).isAbsolute) {
  //     final String lowResImg = user.img.substring(0, 50) + 'c_scale,h_100,w_100/' + user.img.substring(50);
  //     return CircleAvatar(
  //       backgroundImage: NetworkImage(lowResImg),
  //       backgroundColor: AppTheme.tertiaryColor,
  //     );
  //   } else {
  //     return CircleAvatar(
  //     child: Text(
  //       user.name.substring(0, 2),
  //       style: const TextStyle(
  //           fontWeight: FontWeight.bold, color: Colors.white),
  //     ),
  //     backgroundColor: AppTheme.tertiaryColor,
  //   );
  //   }
  // }
  _loadUsers() async {
    this.users = await usersService.getUsers();
    setState(() {});

    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
