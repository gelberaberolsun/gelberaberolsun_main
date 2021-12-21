import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gelberaberolsun/services/Auth.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool istekControl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.info_outline_rounded),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Bilgilendirme"),
                          content: Text("Aşağıdaki görülen kayıtlar oluşturmuş oldugunuz request için size istek atan kullanıcıların istekleridir ve " +
                              "tamamı tek bir requet için oluşturulmuştur.Herhangi bir istek üzerine çift tıklayarak istek ile alaklı işlem yapabilirsiniz." +
                              "Eğer isteği onaylamak istemiyorsanız Hayır'a tıklayarak işlemi silebilirsiniz.Onaylamak için Evet'e tıklamanız yeterli." +
                              "Bir isteği onayladıgınız zaman diğer isteklerde aynı request'e yapıldıgı için onlar otomatik olarak silinecektir." +
                              "Onaylanmış olan istek yeşil renkte görünecektir."),
                        );
                      });
                })
          ],
          backgroundColor: Colors.black,
          title: Text("Notifications"),
        ),
        body: StreamBuilder(
            stream: Provider.of<Auth>(context, listen: false)
                .getRequestNotifications(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Bir Hata Meydana Geldi"),
                );
              } else {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  QuerySnapshot notificationData = snapshot.data;
                  List<DocumentSnapshot> notificationDataList =
                      notificationData.docs;

                  return ListView.builder(
                      itemCount: notificationDataList.length,
                      itemBuilder: (context, index) {
                        User user=Provider.of<Auth>(context,listen: false).getCurrentUser();
                        Map<String, dynamic> map =
                            notificationDataList[index].data();
                        return GestureDetector(
                          onDoubleTap: map["isConfirmed"] != true
                              ? () async {
                                  await showAlertDialog(
                                    context,
                                    () async {
                                      // Provider.of<Auth>(context,listen: false).sendRequestNotificationToUser(uid)
                                      Provider.of<Auth>(context, listen: false)
                                          .updateRequestNotificationToUser(
                                              map["senderId"],
                                              isConfirmed: true);
                                      istekControl = true;

                                    await Provider.of<Auth>(context,listen: false).saveConfirmedRequest(map["senderId"], user.displayName,user.uid);
                                    await Provider.of<Auth>(context,listen: false).saveConfirmedRequest(user.uid, map["senderName"],map["senderId"]);
  
                                      for (var i = 0;
                                          i < notificationDataList.length;
                                          i++) {
                                        Map<String, dynamic> map2 =
                                            notificationDataList[i].data();
                                        if (i == index) {
                                        } else {
                                          Provider.of<Auth>(context,
                                                  listen: false)
                                              .deleteRequestToUser(
                                                  map2["senderId"]);
                                        }
                                      }
                                      await Provider.of<Auth>(context, listen: false)
                                          .documentDelete(Provider.of<Auth>(
                                                  context,
                                                  listen: false)
                                              .getCurrentUser()
                                              .uid);

                                      Navigator.pop(context);
                                    },
                                    Text("Onaylama İslemi"),
                                    Text(
                                        "Bu isteği onaylamak istiyor musunuz.İsteği onaylamazsanız silinecek.Ve bu iki işlemde geri alınamaz."),
                                    () {
                                      Provider.of<Auth>(context, listen: false)
                                          .deleteRequestToUser(map["senderId"]);
                                    },
                                  );
                                }
                              : null,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: BorderSide(width: 1)),
                            elevation: 10,
                            child: ListTile(
                                tileColor: map["isConfirmed"] == true
                                    ? Colors.green
                                    : Colors.white,
                                title: Center(
                                    child: Text(
                                  map["senderName"],
                                )),
                                leading: Icon(Icons.info)),
                          ),
                        );
                        //child: Text(map["senderName"]),),onTap: (){},
                      });
                }
              }
            }));
  }

  void showAlertDialog(context, Function function, Text title, Text content,
      Function deleteFunction) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: title,
            content: content,
            actions: [
              SizedBox(
                  //width: MediaQuery.of(context).size.width / 2,
                  child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      istekControl = true;
                      setState(() {});
                      function();
                    },
                    child: Text("Evet"),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(130, 30),
                        elevation: 10,
                        primary: Colors.black),
                  ),
                ],
              )),
              SizedBox(
                  
                  child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      deleteFunction();
                      Navigator.pop(context);
                    },
                    child: Text("Hayır"),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(130, 30),
                        elevation: 10,
                        primary: Colors.black),
                  ),
                ],
              )),
            ],
          );
        });
  }
}
