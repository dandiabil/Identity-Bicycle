import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:identity_bicycle/pages/register_page.dart';
import 'package:identity_bicycle/services/auth_services.dart';
import 'package:identity_bicycle/utils/color.dart';
import 'package:identity_bicycle/widgets/btn_widgets.dart';
import 'package:identity_bicycle/widgets/header_container.dart';
import 'nav_page.dart';

final storage = FlutterSecureStorage();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final dialog = GlobalKey<_LoginPageState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HeaderContainer("MASUK"),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _textInput(
                          controller: _usernameController,
                          hint: "Username",
                          icon: Icons.people),
                      _textInput(
                          controller: _passwordController,
                          hint: "Password",
                          icon: Icons.vpn_key),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Lupa Password?",
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: ButtonWidget(
                            onClick: () async {
                              if (_formKey.currentState.validate()) {
                                var username = _usernameController.text;
                                var password = _passwordController.text;
                                var jwt = await AuthService()
                                    .login(username, password);
                                if (jwt != null) {
                                  await storage.write(key: 'jwt', value: jwt);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Nav()));
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Failed To Login",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              } else
                                return null;
                            },
                            btnText: "LOGIN",
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Don't have an account ? ",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegPage()));
                              },
                              child: Text(
                                " Register",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: blueLightColors),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _textInput({controller, hint, icon}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: 10),
      child: TextFormField(
        obscureText: (hint == 'Password') ? true : false,
        controller: controller,
        onChanged: (value) {
          controller = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            if (hint == "Username") {
              return 'Insert Username';
            }
            return 'Insert Password';
          }
          return null;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}
