import 'package:flutter/material.dart';
import 'package:flutter_authentication_app/services/auth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async =>
                  await Provider.of<Auth>(context, listen: false).signOut(),
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Container(
          child: Text('HOME PAGE'),
        ),
      ),
    );
  }
}
