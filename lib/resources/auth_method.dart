



import 'package:auth/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import 'package:auth/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }


  /// Sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
   required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty ||
          bio.isNotEmpty) {
        // Register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        print(cred.user!.uid);
        //store in database
        String photoUrl = await StorageMethods().uploadImageToStorage(
            'profilePics', file, false);

        // Store the data in Firestore
        model.User user = model.User(photoUrl: photoUrl,
            uid: cred.user!.uid,
            email: email,
            bio: bio,
            username: username,
            followers: [],
            following: []);
        await _firestore.collection('users').doc(cred.user!.uid).set(user.tojson(),);

        ///without uid, it will have 2 diff uid
        // await _firestore.collection('users').add({
        //   'username': username,
        //   'uid' : cred.user!.uid,
        //   'email' : email,
        //   'bio': bio,
        //   'followers' : [],
        //   'following' : [],
        //
        // });

        res = "Success";
      }
    }on FirebaseAuthException catch(e){
        if(e.code == " Invalid-email"){
          res = " The email is badly formatted.";
        } else if(e.code == "weak-password"){
          res = "Password should be atleast 6 character";
        }

    } catch (e) {
      res = e.toString(); // Capture error message
    }
    return res;
  }

  //logging in user
 Future<String> loginUser({
    required String email,
   required String password
}) async {
    String res = "Some error occured";

    try{
      if(email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      }else {
        res = "Please enter all the fields";
      }
    }catch(err){
      res = err.toString();

    }
    return res;
 }
}
