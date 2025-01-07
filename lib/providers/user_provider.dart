
import 'package:auth/resources/auth_method.dart';
import 'package:flutter/cupertino.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier{
  User? _user;//keep it private for not creating but further
  final AuthMethods _authMethods = AuthMethods();

 User get getUser => _user!;

 Future<void> refreshUser() async {
   User user = await _authMethods.getUserDetails();
   _user = user;
   notifyListeners();
 }

}
