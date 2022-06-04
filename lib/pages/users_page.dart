import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/services/socket_service.dart';
import 'package:flutter_chat_app/services/chat_service.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../services/users_service.dart';
import '../theme.dart';

class UsersPage extends StatefulWidget {
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final usersService = new UsersService();
  List<User> users = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    final user = authService.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(user.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
        bottom: PreferredSize(
          child: Text('Connected', style: TextStyle(fontSize: 16,)),
          preferredSize: Size(4,4),
        ),

      //   bottom: PreferredSize(
      //       child: Text("Title 2"),
      //       preferredSize: null),
      // )
        elevation: 1,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black87),
          onPressed: () {
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
        ),
        actions: <Widget>[
          Container(
              margin: EdgeInsets.only(
                right: 10,
              ),
              // child: Icon(Icons.check_circle), color: Colors.blue[400],
              child: (socketService.serverStatus == ServerStatus.Online)
                  ? Icon(Icons.check_circle, color: Colors.blue[400])
                  : Icon(Icons.offline_bolt, color: Colors.red))
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
      leading: CircleAvatar(
        child: Text(user.name.substring(0, 2), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white ),),
        backgroundColor: tertiaryColor,
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.userFor = user;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _loadUsers() async {
    this.users = await usersService.getUsers();
    setState(() {});

    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
