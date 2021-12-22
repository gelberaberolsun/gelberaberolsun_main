// ignore_for_file: prefer_const_constructors, annotate_overrides, unused_local_variable, duplicate_ignore, must_be_immutable, use_key_in_widget_constructors, unnecessary_brace_in_string_interps, avoid_print

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gelberaberolsun/data/post_json.dart';
import 'package:gelberaberolsun/screens/denemeNotificationPage.dart';
import 'package:gelberaberolsun/services/Auth.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void initState() {
    super.initState();
  }

  int activeTab = 0;
  @override
  Widget build(BuildContext context) {
    String a = Provider.of<Auth>(context).getCurrentUserName();

    return Scaffold(
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 75,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 20,
                offset: const Offset(0, 1)),
          ],
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    activeTab = 0;
                    Navigator.pushNamed(context, '/Main');
                  });
                },
                child: const Icon(
                  Icons.home,
                  size: 35,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              // IconButton(
              //   icon: Icon(
              //     Icons.notifications,
              //     size: 35,
              //     color: Colors.black,
              //   ),
              //   onPressed: () {},
              // ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    activeTab = 3;
                    Navigator.pushNamed(context, '/Profile');
                  });
                },
                child: const Icon(
                  Icons.person,
                  size: 35,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/Request");
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 15,
                offset: const Offset(0, 1),
              ),
            ],
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Center(
            child: Icon(
              Icons.add_box_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Gel Beraber Olsun',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          // ignore: prefer_const_constructors
                          builder: (context) => NotificationPage()));
                },
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
              ),
              IconButton(
                  // ignore: prefer_const_constructors
                  icon: Icon(
                    Icons.login_rounded,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    await Provider.of<Auth>(context, listen: false).singOut();
                  })
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Güncel İstekler",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(icon: Icon(Icons.sort), onPressed: () {}),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            StreamBuilder(
                stream: Provider.of<Auth>(context, listen: false)
                    .getRequestListFromApi("request"),
                builder: (context, snapshot) {
                  return StreamBuilder(
                      stream: Provider.of<Auth>(context, listen: false)
                          .getUserListFromApi("Users"),
                      builder: (context, snapshot2) {
                        if (snapshot.hasError && snapshot2.hasError) {
                          return Center(
                            child: Text("Bir Hata Meydana Geldi"),
                          );
                        } else {
                          if (!snapshot.hasData || !snapshot2.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            QuerySnapshot requestData = snapshot.data;
                            List<DocumentSnapshot> requestdataList =
                                requestData.docs;

                            QuerySnapshot userData = snapshot2.data;
                            List<DocumentSnapshot> userDataList = userData.docs;

                            return MyColumn2(
                                requestList: requestdataList,
                                userList: userDataList);
                          }
                        }
                      });
                }),
          ],
        ),
      ),
    );
  }
}

class MyColumn2 extends StatelessWidget {
  final String name, info, requestTime;
  final List<DocumentSnapshot> requestList;
  final List<DocumentSnapshot> userList;
  double rate = 3.75;

  MyColumn2(
      {this.name,
      this.info,
      this.requestTime,
      this.requestList,
      this.userList});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: requestList.length,
          itemBuilder: (context, index) {
            ///Olusturulma tarihine göre sıralama işlemi.En son oluşturulan en üstte çıkacak.
            sortListsMethod();

            Map<String, dynamic> requetsMap = requestList[index].data();
            String uid = requetsMap["uid"];
            Map<String, dynamic> usersMap = userList[index].data();
            String photoURL = "";

            for (var i = 0; i < userList.length; i++) {
              Map<String, dynamic> usersMap = userList[i].data();
              if (usersMap["id"] == uid) {
                photoURL = usersMap["photoUrl"];
                print("url:${photoURL}");
                break;
              }
            }

            User user =
                Provider.of<Auth>(context, listen: false).getCurrentUser();
            return Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: GestureDetector(
                onTap: () {
                  print(requetsMap["isim"]);
                },

                ///onDoubleTap yapınca istek gönderme işlemi yapılsın.
                onDoubleTap: () async {
                  await sendRequestToOtherUserMethod(
                      requetsMap, user, context, uid);
                },
                onLongPress: () async {
                  //silme işlemi için
                  await deleteRequest(requetsMap, user, context);
                },
                child: Stack(
                  children: [
                    Container(
                      //width: double.infinity,
                      height: 175,
                      decoration: BoxDecoration(
                        border: requetsMap["uid"] == user.uid
                            ? Border.all(color: Colors.yellow, width: 5)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.25),
                            spreadRadius: 2,
                            blurRadius: 15,
                            offset: const Offset(0, 1),
                          ),
                        ],
                        image: DecorationImage(
                            image: NetworkImage(
                                postsList[Random().nextInt(6)]['postImg']),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      //width: double.infinity,
                      height: 175,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      //width: double.infinity,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    // ignore: prefer_const_constructors
                                    CircleAvatar(
                                        // backgroundImage:
                                        //     usersMap["photoUrl"] != null
                                        //         ? FileImage(
                                        //             File(usersMap["photoUrl"]))
                                        //         : null,
                                        ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          requetsMap["isim"],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          postsList[index]['time'],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 15),
                                    Column(
                                      children: [
                                        Text(
                                          requetsMap["sehir"],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          requetsMap["ilce"],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SmoothStarRating(
                                  isReadOnly: true,
                                  allowHalfRating: true,
                                  rating: rate,
                                  starCount: 5,
                                  size: 25,
                                  color: Colors.amber,
                                  borderColor: Colors.amber,
                                  spacing: 0,
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.message,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      ///Mesaj sayfasına yönlendiren kod
                                      // if (requetsMap["uid"] != user.uid) {
                                      //   Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //           builder: (context) => ChatPage(
                                      //                 kullaniciName:
                                      //                     usersMap["name"],
                                      //                 uid: usersMap["id"],
                                      //               )));
                                      // }
                                    }),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 15,
                                      offset: const Offset(0, 1),
                                    )
                                  ]),
                              child: Text(
                                requetsMap["bilgi"],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future sendRequestToOtherUserMethod(Map<String, dynamic> requetsMap,
      User user, BuildContext context, String uid) async {
    if (requetsMap["uid"] != user.uid) {
      showAlertDialog(context, () async {
        await Provider.of<Auth>(context, listen: false)
            .sendRequestNotificationToUser(uid);

        Navigator.pop(context);
      }, Text("İstek Gönderme"),
          Text("Bu kişiye istek göndermek istediğinize emin misiniz?"));
    }
  }

  void sortListsMethod() {
    requestList.sort((a, b) {
      Map<String, dynamic> map1 = a.data();
      Map<String, dynamic> map2 = b.data();

      if ((map1["olusturma tarihi"].compareTo(map2["olusturma tarihi"]) < 0)) {
        return 1;
      } else {
        return -1;
      }
    });
    userList.sort((a, b) {
      Map<String, dynamic> map1 = a.data();
      Map<String, dynamic> map2 = b.data();

      if ((map1["olusturma tarihi"].compareTo(map2["olusturma tarihi"]) < 0)) {
        return 1;
      } else {
        return -1;
      }
    });
  }

  Future deleteRequest(
      Map<String, dynamic> requetsMap, User user, BuildContext context) async {
    if (requetsMap["uid"] == user.uid) {
      showAlertDialog(context, () async {
        try {
          await Provider.of<Auth>(context, listen: false)
              .documentDelete(user.uid);

          Navigator.pop(context);
        } catch (e) {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(
                      "Bir Hata Meydana Geldi Lütfen Daha Sonra Tekrar Deneyin!"),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Anladım."))
                  ],
                );
              });
        }
      },
          Text("Silme İşlemi"),
          Text(
              "Bu işlemi onaylarsanız geri alamazsınız.Silmek istediğinize emin misiniz?"));
      // await Provider.of<Auth>(context,listen: false).documentDelete(user.uid);
    }
  }

  void showAlertDialog(context, Function function, Text title, Text content) {
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
                  // width: MediaQuery.of(context).size.width / 2,
                  child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
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
