import 'dart:convert';
// import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:identity_bicycle/models/bike.dart';
import 'package:identity_bicycle/models/detail.dart';
import 'package:identity_bicycle/models/user.dart';
import 'dart:typed_data';

final storage = FlutterSecureStorage();

class AuthService {
  String aToken;

  //register member
  Future<String> register(String username, String password, String name,
      String email, String address, String phone) async {
    String url = 'https://identity-bicycle.herokuapp.com/auth/signup';
    var response = await http.post(url,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: jsonEncode({
          'username': username,
          'password': password,
          'name': name,
          'email': email,
          'address': address,
          'phone': phone,
        }));

    if (response.statusCode == 201) {
      print('pendaftaran berhasil');
      return response.statusCode.toString();
    }
    return null;
  }

  //login member
  Future<String> login(String username, String password) async {
    String url = 'https://identity-bicycle.herokuapp.com/auth/login';
    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }));
    var cookie = response.headers['set-cookie'];
    if (cookie != null) {
      int index = cookie.indexOf(';');
      aToken = (index == -1) ? cookie : cookie.substring(8, index);
    }
    if (response.statusCode == 200) {
      return aToken;
    }
    return null;
  }

  //register bicycle
  Future<String> bikeRegister(String merk, String type) async {
    if (aToken == null) {
      aToken = await storage.read(key: 'jwt');
    }
    String url = "https://identity-bicycle.herokuapp.com/profile/bike";
    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": aToken,
        },
        body: jsonEncode({
          'merk': merk,
          'type': type,
        }));

    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  //Generate QR code
  Future<String> generateQr(String bikeId, String userId) async {
    if (aToken == null) {
      aToken = await storage.read(key: 'jwt');
    }
    String url =
        'https://identity-bicycle.herokuapp.com/profile/bike/id?bikeId=' +
            bikeId +
            '&userId=' +
            userId;
    var headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "Cookie": 'jwtoken='+aToken,
    };
    var response = await http.get(
      url,
      headers: headers,
    );
    var imageUrl = jsonDecode(response.body)['image'];
    var result;
    if (imageUrl != null) {
      int index = imageUrl.indexOf(',');
      result = (index == -1) ? imageUrl : imageUrl.substring(index + 1, imageUrl.length);
    }
    
    if (response.statusCode == 200) {
      return result;
    }
    return null;
  }

  //Scan Qr Code
  Future<Detail> scanQr(String id, String bikeId) async {
    if (aToken == null) {
      aToken = await storage.read(key: 'jwt');
    }
    String url = 'https://identity-bicycle.herokuapp.com/user/bike?id=' +
        id +
        '&bikeId=' +
        bikeId;
    var headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "Cookie": 'jwtoken='+aToken,
    };
    var response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Detail.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  //get all bicycle from user
  Future<List<Bicycle>> getAllBike() async {
    if (aToken == null) {
      aToken = await storage.read(key: 'jwt');
    }
    String url = "https://identity-bicycle.herokuapp.com/profile/bike";
    var headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "Cookie": 'jwtoken='+aToken,
    };
    var response = await http.get(url, headers: headers);
    var jsonObject = json.decode(response.body);
    List<dynamic> listBikes = (jsonObject as Map<String, dynamic>)['bike'];

    List<Bicycle> bikes = [];
    for (int i = 0; i < listBikes.length; i++) {
      bikes.add(Bicycle.fromJson(listBikes[i]));
    }
    return bikes;
  }

  //Get Profile Data
  Future<User> getProfile() async {
    if (aToken == null) {
      aToken = await storage.read(key: 'jwt');
    }
    String url = "https://identity-bicycle.herokuapp.com/profile";
    var headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "Cookie": 'jwtoken='+aToken,
      };
    var response = await http.get(url, headers: headers);

    if (response.body != null) {
      return User.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  //Get User Id
  Future<String> getUserId() async {
    if (aToken == null) {
      aToken = await storage.read(key: 'jwt');
    }
    var payload = aToken.split('.');
    var decodedPayload = json.decode(ascii.decode(base64.decode(base64.normalize(payload[1]))));
    var userId = decodedPayload['id'];
    return userId;
  }
}
