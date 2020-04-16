import 'package:flutter/material.dart';
import 'dart:async';
import './others/AutoGenJSON/Services.dart';
import './models/users.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title = 'Json Render List Filtering';
  @override
  _HomePageState createState() => _HomePageState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});
  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _HomePageState extends State<HomePage> {
  final debouncer = Debouncer(milliseconds: 1000);
  Users users;
  String title;

  @override
  void initState() {
    super.initState();
    title = 'Loading Users';
    users = Users();
    Services.getUsers().then((usersFromServer) {
      setState(() {
        users = usersFromServer;
        title = widget.title;
      });
    });
  }

  Widget list() {
    return Expanded(
        child: ListView.builder(
            itemCount: users.users == null ? 0 : users.users.length,
            itemBuilder: (BuildContext context, int index) {
              return row(index);
            }));
  }

  Widget row(int index) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              users.users[index].name,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              users.users[index].email.toLowerCase(),
              style: TextStyle(fontSize: 14, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  Widget searchTF() {
    return TextField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(5))),
          filled: true,
          fillColor: Colors.white60,
          contentPadding: EdgeInsets.all(15),
          hintText: 'Filter by name or email'),
      onChanged: (string) {
        debouncer.run(() {
          setState(() {
            title = 'Searching...';
          });
          Services.getUsers().then((usersFromServer) {
            setState(() {
              users = Users.filterList(usersFromServer, string);
              title = widget.title;
            });
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Column(
          children: <Widget>[
            searchTF(),
            SizedBox(height: 5),
            Text('Json List Here'),
            list(),
          ],
        )),
      ),
    );
  }
}
