class Detail{

  String name;
  String address;
  String phone;
  String merk;
  String type;

  Detail({this.name, this.address, this.phone, this.merk, this.type});
  
  factory Detail.fromJson(Map<String, dynamic> json){
    var user = Detail(
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      merk: json['merk'],
      type: json['type'],
    );
    return user;
  }
}