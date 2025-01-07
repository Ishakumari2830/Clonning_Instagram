import 'package:auth/insta/screens/add_post_screen.dart';
import 'package:auth/insta/screens/profile_screen.dart';
import 'package:auth/insta/screens/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../insta/screens/feed_screen.dart';
const webScreenSize = 600;

List<Widget> homeScreenItems = [
  feedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text('notifiaction'),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),




];