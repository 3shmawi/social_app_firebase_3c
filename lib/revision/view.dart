import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

//firebase
/// auth
/// database  [stream]
/// storage
class RevisionView extends StatefulWidget {
  const RevisionView({super.key});

  @override
  State<RevisionView> createState() => _RevisionViewState();
}

//request
//40K read

//pagination
//caching
class _RevisionViewState extends State<RevisionView> {
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  bool isLoading = false;

  void testAuth() {
    setState(() {
      isLoading = true;
      limitRefresh--;
    });
    _auth
        .signInWithEmailAndPassword(
            email: "abcd@gmail.com", password: "1234678")
        .then((response) {
      setState(() {
        isLoading = false;
      });
      print(response);
    }).catchError((error) {
      isLoading = false;
      setState(() {});
      print(error);
      print('one of Email And password is incorrect');
    });
  }

  int limitRefresh = 2;
  int seconds = 60;

  testDatabase() async {
    //collection   document
    await _database.collection("review").doc("1").set({"data": "data"});

    await _database.collection("review").get().then((snapshot) {
      print(snapshot.docs.map((doc) => doc.data()).toList());
    });

    await _database
        .collection("review")
        .doc("1")
        .update({"data": "updated data"});

    await _database.collection("review").get().then((snapshot) {
      print(snapshot.docs.map((doc) => doc.data()).toList());
    });

    _database.collection("review").snapshots().map((snapshots) {
      print(snapshots.docs.map((doc) => doc.data()).toList());
    });
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(minutes: 10), (v) {
      print("tick ??????????${v.tick}");
      print("Limit =>>>>>>>>> $limitRefresh");
      setState(() {
        limitRefresh = 2;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrap(
          children: [
            if (isLoading) const CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  print("Limit =########### $limitRefresh");

                  if (limitRefresh > 0) {
                    testAuth();
                  } else {
                    print('limited count finish');
                  }
                },
                child: const Text("Test Auth"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: testDatabase,
                child: const Text("Test Database"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
