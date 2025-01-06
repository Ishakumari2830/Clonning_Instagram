import 'package:auth/utils/colors.dart';
import 'package:auth/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  @override
  void initState() {

    super.initState();
    getData();
  }

  getData() async {
    try{
     var snap =  await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
     userData = snap.data()!;
     setState(() {

     });
    }
    catch(e){
      showSnackBar(e.toString(), context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(userData['username'] ),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(userData['photoUrl']),
                    radius: 35,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildStateColumn(20, "posts"),
                            buildStateColumn(400, "followers"),
                            buildStateColumn(2, "following"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FollowButton(
                              text: 'Edit Profile ',
                              backgroundcolor: mobileBackgroundColor,
                              textColor: primaryColor,
                              bordercolor: Colors.grey,
                              function: (){},
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 15),
                child: Text(userData['username'],
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 1),
                child: Text(userData['bio'],
                  ),
              )

            ],
          ),),
          Divider(),
        ],
      ),
    );
  }
  Column buildStateColumn(int num,String label){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(num.toString(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15,
              color: Colors.grey
            ),),
        ),


      ],
    );
  }
}
