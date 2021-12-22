// ignore_for_file: use_key_in_widget_constructors, prefer_typing_uninitialized_variables, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unnecessary_string_interpolations, avoid_unnecessary_containers

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gelberaberolsun/services/Auth.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:image_picker/image_picker.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String yas = "", meslek = "";
  String bio = "";
  double rate = 0;
  String imageString = "";
  var image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Provider.of<Auth>(context, listen: false)
        .getDocument("Users")
        .then((value) {
      meslek = value["meslek"];
      yas = value["yas"];
      bio = value["bio"];
      print("meslek:$meslek    yas:$yas");

      setState(() {});
    });
  }

  /*var vari=Provider.of<Auth>(context,listen: false).getDocument("Users");
                      print(vari["name"]);*/

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<Auth>(context).getCurrentUser();
    print(user.photoURL);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.edit,
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/Profile Edit Page");
              })
        ],
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Profilim",
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black87, Colors.white])),
              child: Container(
                width: double.infinity,
                height: 350.0,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              try {
                                XFile imageX = await _picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 50);
                                setState(() async {
                                  user.updatePhotoURL(imageX.path);

                                  image = File(imageX.path);
                                  Map<String, dynamic> map = {
                                    "photoUrl": imageX.path
                                  };
                                  print("path:${imageX.path}");

                                  CollectionReference ref =
                                      Provider.of<Auth>(context, listen: false)
                                          .getRef("Users");
                                  await ref.doc(user.uid).update(map);
                                  await user.updatePhotoURL(imageX.path);
                                });
                              } catch (e) {
                                print("e:$e");
                              }
                            },
                            child: CircleAvatar(
                              backgroundImage: user.photoURL == null
                                  ? null
                                  : FileImage(File(user.photoURL)),
                              radius: 50.0,
                            ),
                          ),
                          Positioned(
                            child: Icon(Icons.edit),
                            bottom: 0,
                            right: 30,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Card(
                        child: SmoothStarRating(
                          rating: rate,
                          allowHalfRating: true,
                          onRated: (rating) {
                            rate = rating;
                            print("RATİNH:$rating");
                            print("RATe:$rate");
                          },
                          starCount: 5,
                          size: 50,
                          color: Colors.amber,
                          borderColor: Colors.amber,
                          spacing: 0,
                        ),
                      ),
                      Text(
                        Provider.of<Auth>(context, listen: false)
                            .getCurrentUserName(),
                        style: TextStyle(fontSize: 25, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Yaş-$yas",
                        style: TextStyle(fontSize: 25, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "$meslek",
                        style: TextStyle(fontSize: 25, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Bio:",
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontStyle: FontStyle.normal,
                          fontSize: 28.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      bio,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
