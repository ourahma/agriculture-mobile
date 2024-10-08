import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'DataBase.dart';
import 'Models/User.dart';

class AuthReposistory {

  Future<bool?> signUp(SignupUser user) async {
    bool? signedin;
    var db = await Database.connect();
    var collection = db.collection('user');
    try {
      collection.insertOne({
        "roles": user.role,
        "f_name": user.firstname,
        "l_name": user.lastname,
        "phone": user.phone,
        "password": user.password,
        "email": user.email,
        "signindate": DateTime.now()
      });

      signedin = true;
    } catch (e) {
      print(e.toString());
      signedin = false;
    }
    return signedin;
  }

  getUser(String? email, String? password) async {
    var db = await Database.connect();
    var collection = db.collection('user');
    final user;
    try {
      user = await collection.find({"email": "$email","password": "$password"}).toList();
      print(user);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  login(String? email, String? password) async { //the function that log the user in
    var db = await Database.connect();
    var collection = db.collection('user');
    final user;
    try {
      user = await collection.find({"email": "$email", "password": "$password"}).toList();
      print(user);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  bool start() {
    bool ready = false;
    return ready;
  }

  //azure
  logout() async {
    bool isloggedin;
    final userdata = GetStorage();
    //String useremail =userdata.read("email");
    userdata.write("isloggedin", false);
    var response = await http.post(Uri.parse("link"),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    isloggedin = false;
    return isloggedin;
  }



}
