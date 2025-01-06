import 'package:auth/utils/colors.dart';
import 'package:auth/widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class feedScreen extends StatelessWidget {
  const feedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset('assets/insta.svg', color: primaryColor,height: 32,),
        actions: [
          IconButton(onPressed: (){}, icon: FaIcon(FontAwesomeIcons.facebookMessenger),),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
          if(snapshot.connectionState== ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,

            itemBuilder: (context,index)=> postCard(
              snap : snapshot.data!.docs[index].data(),
            ),);

        },
      ),
    );
  }
}
