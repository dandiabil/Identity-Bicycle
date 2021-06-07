import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:identity_bicycle/models/bike.dart';
import 'package:identity_bicycle/services/auth_services.dart';
import 'package:identity_bicycle/widgets/btn_widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'bicycle_page.dart';

class Generate extends StatefulWidget {
  @override
  _GenerateState createState() => _GenerateState();
}

class _GenerateState extends State<Generate> {
  int count = 0;
  List<Bicycle> bikeList = List<Bicycle>();

  @override
  void initState() {
    super.initState();
    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: count,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.pedal_bike),
                  ),
                  title: Text(
                    bikeList[index].merk,
                  ),
                  subtitle: Text(bikeList[index].type),
                  trailing: GestureDetector(
                      child: Icon(
                        Icons.qr_code,
                        color: Colors.blue,
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QrGenerate(
                                    bikeId: bikeList[index].id,
                                  )))),
                ),
              );
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BikePage()));
              }),
        ),
      ],
    );
  }

  void updateListView() {
    AuthService().getAllBike().then((value) {
      for (int i = 0; i < value.length; i++) {
        bikeList.add(value[i]);
        setState(() {
          this.bikeList = bikeList;
          this.count = bikeList.length;
        });
      }
    });
  }
}

class QrGenerate extends StatefulWidget {
  const QrGenerate({Key key, this.bikeId}) : super(key: key);
  final String bikeId;

  @override
  _QrGenerateState createState() => _QrGenerateState(bikeId);
}

class _QrGenerateState extends State<QrGenerate> {
  String result;
  String bikeId;
  String userId;
  Uint8List decoded;
  _QrGenerateState(this.bikeId);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generated QR'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              (decoded != null)
                  ? Image.memory(
                      decoded,
                      width: 250.0,
                    )
                  : QrImage(
                      data: 'Click Generate',
                      version: QrVersions.auto,
                      size: 150.0,
                      backgroundColor: Colors.grey[200],
                    ),
              Container(
                padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0),
                child: ButtonWidget(
                  btnText: "Generate",
                  onClick: () async {
                    await AuthService().getUserId().then((value) {
                      userId = value;
                      generateQR();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void generateQR() async {
    await AuthService().generateQr(bikeId, userId).then((value) {
      result = value;
      setState(() {
        decoded = Base64Decoder().convert(result);
      });
    });
  }
}