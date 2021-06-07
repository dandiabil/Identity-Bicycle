import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:identity_bicycle/models/bike.dart';
import 'package:identity_bicycle/services/auth_services.dart';
import 'package:identity_bicycle/widgets/btn_widgets.dart';

class BikePage extends StatefulWidget {
  const BikePage({Key key}) : super(key: key);

  @override
  _BikePageState createState() => _BikePageState();
}

class _BikePageState extends State<BikePage> {
  TextEditingController merkController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('List Sepeda'),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Input Data Sepeda',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: merkController,
                      decoration: InputDecoration(
                        labelText: "Merk Sepeda",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: typeController,
                      decoration: InputDecoration(
                        labelText: "Tipe Sepeda",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3.0)),
                      ),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: ButtonWidget(
                        onClick: () async {
                          if (_formKey.currentState.validate()) {
                            var merk = merkController.text;
                            var type = typeController.text;
                            var statusCode =
                                await AuthService().bikeRegister(merk, type);
                            if (statusCode != null) {
                              Navigator.pop(context);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Failed To Register Bike",
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
                        btnText: "Save",
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }
}