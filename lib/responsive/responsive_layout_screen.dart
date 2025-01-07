import 'package:auth/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../utils/global_variables.dart';
class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout({super.key, required this.webScreenLayout, required this.mobileScreenLayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
  void initState() {

    super.initState();
    addData();
  }



  addData() async {
    //it will constantly listen to the userprovider so we will do it as false to listen one time
    UserProvider userProvider = Provider.of(context,listen: false);
    await userProvider.refreshUser();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          if(constraints.maxWidth > webScreenSize) {
            /// web screen layer
            return widget.webScreenLayout;
          }

            /// mobile screen
          return widget.mobileScreenLayout;


    },
    );
  }
}
