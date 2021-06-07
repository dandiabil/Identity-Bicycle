import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:identity_bicycle/services/auth_services.dart';
import 'package:identity_bicycle/utils/color.dart';
import 'package:identity_bicycle/widgets/btn_widgets.dart';
import 'package:identity_bicycle/widgets/header_container.dart';

class RegPage extends StatefulWidget {
  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            Expanded(
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
                          controller: _nameController,
                          hint: "Name",
                          icon: Icons.person),
                      _textInput(
                          controller: _emailController,
                          hint: "Email",
                          icon: Icons.email),
                      _textInput(
                          controller: _addressController,
                          hint: "Address",
                          icon: Icons.home),
                      _textInput(
                          controller: _phoneController,
                          hint: "Phone Number",
                          icon: Icons.phone),
                      _textInput(
                          controller: _passwordController,
                          hint: "Password",
                          icon: Icons.code),
                      Expanded(
                        child: Center(
                          child: ButtonWidget(
                            btnText: "REGISTER",
                            onClick: () async {
                              if (_formKey.currentState.validate()) {
                                var username = _usernameController.text;
                                var password = _passwordController.text;
                                var email = _emailController.text;
                                var name = _nameController.text;
                                var address = _addressController.text;
                                var phone = _phoneController.text;

                                var statusCode = await AuthService().register(
                                    username,
                                    password,
                                    name,
                                    email,
                                    address,
                                    phone);
                                if (statusCode == '201') {
                                  Fluttertoast.showToast(
                                      msg: "Account Created Successfully",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.blue,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  Navigator.pop(context);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Failed To Create Account",
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
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Already a member ? ",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Login",
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
            if (hint == "Name") {
              return 'Insert Name';
            }
            if (hint == "Email") {
              return 'Insert Email';
            }
            if (hint == "Address") {
              return 'Insert Address';
            }
            if (hint == "Phone Number") {
              return 'Insert Phone Number';
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
