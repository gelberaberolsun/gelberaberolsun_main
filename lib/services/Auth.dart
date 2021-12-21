// ignore_for_file: file_names, prefer_if_null_operators

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<void> singOut() async {
    await _firebaseAuth.signOut();
  }

  Stream<User> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  User getCurrentUser() {
    User user = _firebaseAuth.currentUser;

    return user;
  }

  void metod() {
    _firebaseAuth;
  }

  String getCurrentUserName() {
    User user = _firebaseAuth.currentUser;
    return user.displayName != null ? user.displayName : "Unknown";
  }

  Future<void> updateDisplayName(String name) async {
    await _firebaseAuth.currentUser.updateDisplayName(name);
  }

  Future<void> createRequest(Map<String, dynamic> map) async {
    var allRequestsRef = _firebaseFirestore.collection("request");
    await allRequestsRef.doc(getCurrentUser().uid).set(map);
  }

  Future<void> rateTheUser(Map<String, dynamic> map) {
    User user = _firebaseAuth.currentUser;
    var ratingsCollectionRef = _firebaseFirestore
        .collection("Users")
        .doc(user.uid)
        .collection("ratings");
  }

  void createUser(Map<String, dynamic> map) async {
    var usersCollectionRef = _firebaseFirestore.collection("Users");
    await usersCollectionRef.doc(getCurrentUser().uid).set(map);
  }

  CollectionReference getRef(String refPath) {
    var collectionRef = _firebaseFirestore.collection(refPath);
    return collectionRef;
  }

  Future<DocumentSnapshot> getDocument(String refPath) async {
    DocumentSnapshot snapshot;
    //await getRef(refPath).doc(getCurrentUser().uid).get().then((value) => snapshot=value);
    //return snapshot;
    snapshot = await getRef(refPath).doc(getCurrentUser().uid).get();
    return snapshot;
  }

  Future<String> getUserPhotoByUid(String uid, String url) async {
    String photoUrl = "url";
    DocumentReference document = getRef("Users").doc(uid);
    photoUrl = await document.get().then((value) {
      return value["photoUrl"];
    });
    print("URL:$photoUrl");
    url = photoUrl;
    return photoUrl;
  }

  Future<void> documentDelete(String uid) async {
    await _firebaseFirestore.collection("request").doc(uid).delete();
  }

  String getUserPhoto() {
    return getCurrentUser().photoURL;
  }

  Stream<QuerySnapshot> getRequestListFromApi(String refPath) {
    return _firebaseFirestore.collection(refPath).snapshots();
  }

  Stream<QuerySnapshot> getUserListFromApi(String refPath) {
    return _firebaseFirestore.collection(refPath).snapshots();
  }

  void saveMessage(String uid, String message) {
    _firebaseFirestore
        .collection("Users")
        .doc(uid)
        .collection("conversations")
        .doc(getCurrentUser().uid)
        .collection("messages")
        .add({
          "idFrom": getCurrentUser().uid,
          "idTo": uid,
          "messageTime": DateTime.now(),
          "message": message
        })
        .then((value) => print("message added"))
        .catchError((error) => print("An Error Occured"));
  }

  ///sendRequestNotificationToUser metodu ilgili kullanıcıya istek göndermeye yarar.
  Future<void> sendRequestNotificationToUser(String uid,
      {bool isConfirmed}) async {
    await _firebaseFirestore
        .collection("Users")
        .doc(uid)
        .collection("istekBildirimleri")
        .doc(getCurrentUser().uid)
        .set({
      "receiverId": uid,
      "senderName": getCurrentUser().displayName,
      "sendTime": DateTime.now(),
      "senderId": getCurrentUser().uid,
      "isConfirmed": false
    });
  }

  ///sendRequestNotificationToUser metodu ilgili kullanıcıya istek göndermeye yarar.
  Future<void> updateRequestNotificationToUser(String uid,
      {bool isConfirmed}) async {
    await _firebaseFirestore
        .collection("Users")
        .doc(getCurrentUser().uid)
        .collection("istekBildirimleri")
        .doc(uid)
        .update({"isConfirmed": isConfirmed});
  }

  ///kullanıcıya gönderilen isteği silmek için
  Future<void> deleteRequestToUser(String uid) async {
    await _firebaseFirestore
        .collection("Users")
        .doc(getCurrentUser().uid)
        .collection("istekBildirimleri")
        .doc(uid)
        .delete();
  }

  Stream<QuerySnapshot> getRequestNotifications() {
    return _firebaseFirestore
        .collection("Users")
        .doc(getCurrentUser().uid)
        .collection("istekBildirimleri")
        .snapshots();
  }

///onaylanan requesti kaydetme işlemi
  void saveConfirmedRequest(String uid1, String name,String uid2) async{
  await  _firebaseFirestore
        .collection("Users")
        .doc(uid1)
        .collection("confirmedRequests")
        .add({
          "confirmedDate": DateTime.now(),
          "confirmedId": uid2,
          "confirmedName": name
        })
        .then((value) => print("Successs"))
        .onError((error, stackTrace) => print("error:$error"));
  }
}
