import 'package:flutter/material.dart';
import 'package:identity_bicycle/models/detail.dart';
// import 'package:identity_bicycle/services/auth_services.dart';
import 'package:identity_bicycle/widgets/btn_widgets.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key key, this.detail}) : super(key: key);
  final Detail detail;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Detail detail;
  // String name;
  // String address;
  // String phone;
  // String merk;
  // String type;

  @override
  void initState() {
    super.initState();
    if(detail == null){
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
              child: (detail != null)
                  ? Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 500,
                            child: Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(detail.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500)),
                                    leading: Icon(
                                      Icons.people,
                                      color: Colors.blue[500],
                                    ),
                                  ),
                                  Divider(),
                                  ListTile(
                                    title: Text(detail.phone,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500)),
                                    leading: Icon(
                                      Icons.contact_phone,
                                      color: Colors.blue[500],
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(detail.address),
                                    leading: Icon(
                                      Icons.home,
                                      color: Colors.blue[500],
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(detail.merk),
                                    subtitle: Text(detail.type),
                                    leading: Icon(
                                      Icons.pedal_bike,
                                      color: Colors.blue[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 500,
                            child: Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text('Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500)),
                                    leading: Icon(
                                      Icons.people,
                                      color: Colors.blue[500],
                                    ),
                                  ),
                                  Divider(),
                                  ListTile(
                                    title: Text('Phone Number',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500)),
                                    leading: Icon(
                                      Icons.contact_phone,
                                      color: Colors.blue[500],
                                    ),
                                  ),
                                  ListTile(
                                    title: Text('Address'),
                                    leading: Icon(
                                      Icons.home,
                                      color: Colors.blue[500],
                                    ),
                                  ),
                                  ListTile(
                                    title: Text('Brand'),
                                    subtitle: Text('Type'),
                                    leading: Icon(
                                      Icons.pedal_bike,
                                      color: Colors.blue[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                    Container(
            padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0),
            child: ButtonWidget(
              btnText: "Refresh",
              onClick: () {
                getData();
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  void getData() {
    detail = widget.detail;
  }
}
