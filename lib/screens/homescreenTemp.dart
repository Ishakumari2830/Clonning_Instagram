import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:auth/screens/phone_auth/sign_in_with_phone.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
// Adjust the import according to your actual file structure

class Homescreentemp extends StatefulWidget {
  const Homescreentemp({super.key});

  @override
  State<Homescreentemp> createState() => _HomescreentempState();
}

class _HomescreentempState extends State<Homescreentemp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  File? profilepic;

  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => SignInWithPhone()));
  }

  void saveUser() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String ageString = ageController.text.trim();
    int age = int.tryParse(ageString) ?? 0;

    nameController.clear();
    emailController.clear();
    ageController.clear();

    if (name.isNotEmpty && email.isNotEmpty && profilepic != null) {
      try {
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child("profilepictures")
            .child(Uuid().v1())
            .putFile(profilepic!);

        //if u want to see the progress of uploading an image,realitime update...set the listener
       StreamSubscription tasksubscription =  uploadTask.snapshotEvents.listen((snapshot){
          double percentage = snapshot.bytesTransferred/snapshot.totalBytes*100;
          log(percentage.toString());
        });


        TaskSnapshot taskSnapshot = await uploadTask;//launching the task
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        tasksubscription.cancel();//cancel the progess,as it continues to infinite

        Map<String, dynamic> userData = {
          "name": name,
          "email": email,
          "age": age,
          "profilepic": downloadUrl,
          "sampleArray": [name, email, age],
        };

        await FirebaseFirestore.instance.collection("users1").add(userData);

        log("User created!");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Success"),
            content: Text("User created successfully!"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          ),
        );
      } catch (e) {
        log("Error creating user: $e");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text(
                "An error occurred while creating the user. Please try again."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    } else {
      log("Please fill all the fields!");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Validation Error"),
          content: Text("Please fill all the fields!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
    setState(() {
      profilepic = null; // Clear the pic after saving
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              logOut();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              CupertinoButton(
                onPressed: () async {
                  XFile? selectedImage =
                  await ImagePicker().pickImage(source: ImageSource.gallery);

                  if (selectedImage != null) {
                    File convertedFile = File(selectedImage.path);
                    setState(() {
                      profilepic = convertedFile;
                    });
                    log("Image selected!");
                  } else {
                    log("No image selected!");
                  }
                },
                padding: EdgeInsets.zero,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: profilepic != null ? FileImage(profilepic!) : null,
                  backgroundColor: Colors.grey,
                ),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: "Name"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(hintText: "Email Address"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: ageController,
                decoration: InputDecoration(hintText: "Age"),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              CupertinoButton(
                onPressed: saveUser,
                child: Text("Save"),
              ),
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("users1").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> userMap = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                            String docId = snapshot.data!.docs[index].id;

                            String name = userMap["name"] ?? "No Name";
                            String email = userMap["email"] ?? "No Email";
                            String age = userMap["age"]?.toString() ?? "No Age";
                            String profilePicUrl = userMap["profilepic"] ?? "https://via.placeholder.com/150"; // Placeholder image URL

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(profilePicUrl),
                              ),
                              title: Text("$name ($age)"),
                              subtitle: Text(email),
                              trailing: IconButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance.collection("users1").doc(docId).delete();
                                  print("Deleted document with ID: $docId");
                                },
                                icon: Icon(Icons.delete),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Text("No data");
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
