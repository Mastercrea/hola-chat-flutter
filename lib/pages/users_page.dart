import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersPage extends StatefulWidget {



  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  final users = [
    User(uid: '1', name:'Edgar Castro', email:'mastercrea1928@gmail.com', online: true ),
    User(uid: '2', name:'Mary Ontiveros', email:'marybebecita@gmail.com', online: false ),
    User(uid: '3', name:'Manolo Guerra', email:'manologuerra@gmail.com', online: false ),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My name', style: TextStyle(color: Colors.black87)),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black87),
          onPressed: () {},
        ),actions: <Widget>[
          Container(
            margin: EdgeInsets.only( right: 10,),
            // child: Icon(Icons.check_circle), color: Colors.blue[400],
            child: Icon(Icons.offline_bolt, color: Colors.red,),
          )
      ],
      ),
      body: SmartRefresher(controller: _refreshController,
      child: _listViewUsers(),
      enablePullDown: true,
      // action to load the data
      onRefresh: _loadUsers,
      header: WaterDropHeader(
        complete: Icon(Icons.check),
        waterDropColor: Colors.blue,
      ),),
    );
  }
  _listViewUsers() {
    return ListView.separated(physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _userListTile(users[i]),
        separatorBuilder: (_,i) => Divider(),
        itemCount: users.length
    );
  }
  ListTile _userListTile(User user) {
    return ListTile(
      title: Text(user.name!),
      subtitle: Text(user.email!),
      leading: CircleAvatar(
        child: Text(user.name!.substring(0,2)),
        backgroundColor: Colors.blue[150],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: user.online! ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
        ),
      ),
    );
  }

  _loadUsers() async {
      // monitor network fetch
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use refreshFailed()
      _refreshController.refreshCompleted();
  }
}


