class User{

  String username;
  String name;
  String email;
  String address;
  String phone;


  User({this.username, this.name, this.email, this.address, this.phone});
  
  factory User.fromJson(Map<String, dynamic> json){
    var user = User(
      username: json['username'],
      name: json['name'],
      email: json['email'],
      address: json['address'],
      phone: json['phone'],
    );
    return user;
  }
}