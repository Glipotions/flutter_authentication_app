import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_authentication_app/services/auth.dart';
import 'package:flutter_authentication_app/views/email_sign_in.dart';
import 'package:flutter_authentication_app/widgets/my_raised_button.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;
  Future<void> _signInAnonymously() async {
    setState(() {
      _isLoading = true;
    });
    final user =
        await Provider.of<Auth>(context, listen: false).signInAnonymously();
    setState(() {
      _isLoading = false;
    });
    print(user!.uid);
  }

  Future<void> _signInWithGoogle() async {
    // try {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Auth>(context, listen: false).signInWithGoogle();
    // } on FirebaseAuthException catch (e) {
    //   _showErrorDialog(e.code);
    // } catch (e) {
    //   _showErrorDialog(e.toString());
    // }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                Provider.of<Auth>(context, listen: false).signOut();
                // await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign In Page',
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(
              height: 30,
            ),
            MyRaisedButton(
              child: const Text('Sign In Anonymously'),
              color: Colors.orangeAccent,
              onPressed: _isLoading ? null : _signInAnonymously,
            ),
            const SizedBox(
              height: 10,
            ),
            MyRaisedButton(
              child: const Text('Sign In Email/Password'),
              color: Colors.yellow,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmailSignInPage(),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            MyRaisedButton(
              color: Colors.lightBlueAccent,
              child: Text('Google Sign In'),
              onPressed: _isLoading ? null : _signInWithGoogle,
            ),
          ],
        ),
      ),
    );
  }
}
