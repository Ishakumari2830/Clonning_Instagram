import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  const User({
    required this.photoUrl,
    required this.uid,
  required this.email,
  required this.bio,
  required this.username,
  required this.followers,
    required this.following,

});

  Map<String,dynamic> tojson() => {
    "username" : username,
    "uid" : uid,
    "email" : email,
    "photoUrl" : photoUrl,
    "bio":bio,
    "followers" : followers,
    "following" : following,
  };


  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }


}