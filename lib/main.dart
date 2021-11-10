// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_authentication_app/views/sign_in_page.dart';
import 'package:flutter_authentication_app/widgets/on_board.dart';
import 'package:provider/provider.dart';

import 'services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<Auth>(
      create: (context) => Auth(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          home: OnBoardWidget()
          //const MyHomePage(title: 'Flutter Demo Home Page'),
          ),
    );
  }
}

// FutureBuilder(
//           future: _initialization,
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return const Center(
//                 child: Text('Beklenilmeyen bir Hata Oluştu'),
//               );
//             } else if (snapshot.hasData) {
//               return const HomePage(title: 'Flutter Demo Home Page');
//             } else {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           },
//         )