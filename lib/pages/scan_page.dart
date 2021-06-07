import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:identity_bicycle/pages/detail_page.dart';
import 'package:identity_bicycle/services/auth_services.dart';
import 'package:identity_bicycle/widgets/btn_widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Scan extends StatefulWidget {
  const Scan({Key key}) : super(key: key);

  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  String getUrl;
  var result;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Center(
            child: Column(
              children: [
                Text('SCAN A QR', style: Theme.of(context).textTheme.headline4),
                Icon(
                  Icons.fingerprint_rounded,
                  size: 150,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0),
            child: ButtonWidget(
              btnText: "Scan",
              onClick: () {
                scanBarcode();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future scanBarcode() async {
    await FlutterBarcodeScanner.scanBarcode(
            '#009922', "Cancel", true, ScanMode.QR)
        .then((value) {
      getUrl = value;
    });
    var data = jsonDecode(getUrl);
    result = await AuthService().scanQr(data['id'], data['bikeId']);
    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DetailPage(detail: result,)));
    setState(() {});
  }
}
