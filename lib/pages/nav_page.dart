import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:identity_bicycle/models/bike.dart';
import 'package:identity_bicycle/models/user.dart';
import 'package:identity_bicycle/pages/login_page.dart';
import 'package:identity_bicycle/pages/scan_page.dart';
import 'package:identity_bicycle/services/auth_services.dart';
import 'package:identity_bicycle/widgets/btn_widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

import 'bicycle_page.dart';
import 'generate_screen.dart';
// import 'dart:convert' show json, base64, ascii;

final storage = FlutterSecureStorage();

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetOptions = <Widget>[
    Scan(),
    Generate(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cycle Card'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.find_in_page,
            ),
            label: 'Generator',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Profil user',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
        selectedFontSize: 13.0,
        unselectedFontSize: 13.0,
      ),
    );
  }
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                child: FutureBuilder<User>(
                    future: AuthService().getProfile(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: <Widget>[
                            SizedBox(
                              height: 270,
                              child: Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(snapshot.data.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      subtitle: Text(snapshot.data.username),
                                      leading: Icon(
                                        Icons.people,
                                        color: Colors.blue[500],
                                      ),
                                    ),
                                    Divider(),
                                    ListTile(
                                      title: Text(snapshot.data.phone,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      leading: Icon(
                                        Icons.contact_phone,
                                        color: Colors.blue[500],
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(snapshot.data.email),
                                      leading: Icon(
                                        Icons.contact_mail,
                                        color: Colors.blue[500],
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(snapshot.data.address),
                                      leading: Icon(
                                        Icons.home,
                                        color: Colors.blue[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }
                      return CircularProgressIndicator();
                    })),
            ButtonWidget(
              btnText: "Logout",
              onClick: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: Text('Log Out'),
                        content:
                            Text('You will be logged out from application'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              storage.delete(key: "jwt");
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                            child: Text('Yes'),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context, 'Cancel');
                            },
                            child: Text('No'),
                          )
                        ],
                      )),
            ),
          ],
        ),
      ),
    );
  }
}