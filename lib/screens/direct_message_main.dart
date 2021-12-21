// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DirectMessage extends StatelessWidget {
  const DirectMessage({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: MeetAgain(),
          appBar: AppBar(
            titleSpacing: -10,
            elevation: 30,
            backgroundColor: Colors.white,
            title: Text(
              'burçak',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            leading: Icon(Icons.arrow_back,
                color: Colors.black, size: 20),

            /*Text('user_name',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Expanded(
                        child: Icon(Icons.keyboard_arrow_down_outlined,
                            color: Colors.black),
                      ),
                    ], 
                  ),
                ],
              ), */
            actions: <Widget>[
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.black,
                size: 25,
              ),
              SizedBox(
                width: 330,
              ),
              Icon(
                Icons.videocam_rounded,
                color: Colors.black,
                size: 35,
              ),
              SizedBox(
                width: 10,
              ),
            ],
            bottom: TabBar(
              indicatorColor: Colors.amber,
              labelColor: Colors.black,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(
                  text: 'Tümü',
                ),
                Tab(text: '0 Randevu'),
              ],
            ),
          ),
          body: DirectMessageBody(),
        ),
      ),
    );
  }
}

class DirectMessageBody extends StatefulWidget {
  const DirectMessageBody({key}) : super(key: key);

  @override
  State<DirectMessageBody> createState() => _DirectMessageBodyState();
}

class _DirectMessageBodyState extends State<DirectMessageBody> {
  //final int ppId = 1;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 20),
            shadowColor: Colors.indigo,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 20,
            color: Colors.white70,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: ListTile(
                onTap: () => Navigator.pushNamed(context, '/IndividualDm'),
                title: Text('Burçak',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('5 dakika önce aktifti'),
                leading: CircleAvatar(
                  backgroundColor: Colors.purple,
                  //child: Image.asset('assets/images/ppId_$ppId'),
                  radius: 35,
                ),
                trailing:
                    Icon(Icons.star_rounded, size: 35, color: Colors.amber),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 5,
            ),
            child: Divider(
              color: Colors.black54,
              endIndent: 5,
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 20),
            shadowColor: Colors.indigo,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 20,
            color: Colors.white70,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: ListTile(
                onTap: () => Navigator.pushNamed(context, '/IndividualDm'),
                title: Text('Recep Tayyip Erdoğan',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("2023'ten önce aktifti"),
                leading: CircleAvatar(
                  backgroundColor: Colors.purple,
                  //child: Image.asset('assets/images/ppId_$ppId'),
                  radius: 35,
                ),
                trailing: Icon(Icons.star_half_rounded,
                    size: 35, color: Colors.amber),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 5,
            ),
            child: Divider(
              color: Colors.black54,
              endIndent: 5,
            ),
          ),
        ],
      ),
    );
  }
}

class MeetAgain extends StatefulWidget {
  const MeetAgain({key}) : super(key: key);

  @override
  _MeetAgainState createState() => _MeetAgainState();
}

class _MeetAgainState extends State<MeetAgain> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_dining, color: Colors.indigo, size: 30),
          SizedBox(
            width: 10,
          ),
          Text(
            'Tekrar ye',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class DmSearch extends StatefulWidget {
  const DmSearch({key}) : super(key: key);

  @override
  _DmSearchState createState() => _DmSearchState();
}

class _DmSearchState extends State<DmSearch> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

//alt kısım projede ayrı bir dart sayfası olacak...

class IndividualDM extends StatefulWidget {
  const IndividualDM({key})
      : super(key: key); //Key? ' ler silindi. -sanırım version olayı-

  @override
  _IndividualDMState createState() => _IndividualDMState();
}

class _IndividualDMState extends State<IndividualDM> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text('sdfdsfdsfsdf'),
        //titleSpacing: -20,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.red],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        //leading: Icon(Icons.person_rounded, color: Colors.black),
        elevation: 30,
        actions: [
          Icon(Icons.phone, color: Colors.black),
          SizedBox(
            width: 20,
          ),
          Icon(Icons.videocam_rounded, color: Colors.black),
        ],
      ),
      body: Center(
        child: Text('individual dm page center'),
      ),
    );
  }
}
