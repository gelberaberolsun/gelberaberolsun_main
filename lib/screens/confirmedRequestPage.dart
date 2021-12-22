// ignore_for_file: prefer_const_constructors, duplicate_ignore, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gelberaberolsun/services/Auth.dart';
import 'package:provider/provider.dart';

class ConfirmedRequest extends StatelessWidget {
  const ConfirmedRequest({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        // ignore: prefer_const_constructors
        title: Text("Onaylanmış İstekler"),
      ),
      body: StreamBuilder(
          stream:
              Provider.of<Auth>(context, listen: false).getConfirmedRequests(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Bir Hata Meydana Geldi"));
            } else {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                QuerySnapshot confirmedRequetsData = snapshot.data;
                List<DocumentSnapshot> confirmedRequestsList =
                    confirmedRequetsData.docs;

                return ListView.builder(
                    itemCount: confirmedRequestsList.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> confirmedRequetsMap =
                          confirmedRequestsList[index].data();
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(width: 1),
                        ),
                        elevation: 10,
                        child: ListTile(
                          title: Center(
                            child: Text(
                              confirmedRequetsMap["confirmedName"],
                            ),
                          ),
                        ),
                      );
                    });
              }
            }
          }),
    );
  }
}
