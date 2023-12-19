import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/firestore_services_new.dart';

class PlateListView extends StatefulWidget {
  const PlateListView({super.key});

  @override
  State<PlateListView> createState() => _PlateListViewState();
}

class _PlateListViewState extends State<PlateListView> {
  late String uid;

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uid = user.uid;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result?>(
      future: readResult(uid: uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        } else if (snapshot.hasData) {
          final result = snapshot.data!.resultList;
          return result.isEmpty
              ? const Center(
                  child: Text(
                    'No Result Yet',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              : Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                    itemCount: snapshot.data!.resultList.length,
                    itemBuilder: (context, index) {
                      return buildUser(
                        snapshot.data!.resultList[index],
                      );
                    },
                  ),
              );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildUser(String resultItem) => Card(
        margin: const EdgeInsets.all(5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          tileColor: const  Color.fromARGB(255, 57, 57, 57),
          contentPadding: const EdgeInsets.only(left: 20),
          title: Text(
            resultItem,
            style: const TextStyle(
              color: Colors.yellow,
              fontSize: 17,
            ),
          ),
        ),
      );
}
