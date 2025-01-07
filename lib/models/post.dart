import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String description;
  final String uid;
  final String postId;
  final String username;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  const Post({
    required this.description,
    required this.uid,
    required this.postId,
    required this.postUrl,
    required this.username,
    required this.profImage,
    required this.likes,
    required this.datePublished,


  });

  Map<String,dynamic> tojson() => {
    "description" : description,
    "uid" : uid,
    "postId" : postId,
    "postUrl" : postUrl,
    "profImage" : profImage,
    "username" : username,
    "likes" : likes,
    "datePublished" : datePublished,
  };

  static Post fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      username: snapshot['username'],
      uid: snapshot['uid'],
      description: snapshot['description'],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      postId: snapshot['postId'],
      likes: snapshot['likes'],
      datePublished: snapshot['datePublished'],
    );
  }


}