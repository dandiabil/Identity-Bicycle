class Bicycle{
  String id;
  String merk;
  String type;

  Bicycle({this.id, this.merk, this.type});
  
  factory Bicycle.fromJson(Map<String, dynamic> json){
    return Bicycle(
      id: json['_id'],
      merk: json['merk'],
      type: json['type'],
    );
  }
}