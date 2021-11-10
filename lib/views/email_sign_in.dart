import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_authentication_app/services/auth.dart';
import 'package:provider/provider.dart';

enum FormStatus { signIn, register, reset }
enum TextId { passwordText, passwordRecapText }

class EmailSignInPage extends StatefulWidget {
  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  FormStatus _formStatus = FormStatus.signIn;
  TextId? textId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _formStatus == FormStatus.signIn
            ? buildSignInForm()
            : _formStatus == FormStatus.register
                ? buildRegisterForm()
                : buildResetForm(),
      ),
    );
  }

  Widget buildSignInForm() {
    final _signInFormKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
          key: _signInFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Lütfen Giriş Yapınız.',
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (!EmailValidator.validate(value!)) {
                    return 'Lütfen Geçerli Bir Değer Giriniz.';
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'E-mail',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (value!.length < 6) {
                    return 'Parola 6 karakterden az Olamaz.';
                  } else {
                    return null;
                  }
                },
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Şifre',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0))),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_signInFormKey.currentState!.validate()) {
                    // try {
                    final user = await Provider.of<Auth>(context, listen: false)
                        .signInWithEmailAndPassword(
                            _emailController.text, _passwordController.text);

                    if (!user!.emailVerified) {
                      await _showMyDialog('ONAY GEREKİYOR',
                          'Onay Linkini Tıklayıp Tekrar Giriş Yapmalısınız.');
                      await Provider.of<Auth>(context, listen: false).signOut();
                    }

                    Navigator.pop(context);
                    // } on FirebaseAuthException catch (e) {
                    //   _showErrorDialog(e.code);
                    // } catch (e) {
                    //   _showErrorDialog(e.toString());
                    // }
                  }
                },
                child: const Text('Giriş'),
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _formStatus = FormStatus.register;
                    });
                  },
                  child: Text('Yeni Kayıt İçin Tıklayınız.')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _formStatus = FormStatus.reset;
                    });
                  },
                  child: const Text('Şifremi Unuttum'))
            ],
          )),
    );
  }

  Widget buildRegisterForm() {
    final _registerFormKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _passwordConfirmController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
          key: _registerFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Kayıt Ol',
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (!EmailValidator.validate(value!)) {
                    return 'Lütfen Geçerli Bir Değer Giriniz.';
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'E-mail',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0))),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (value!.length < 6) {
                    return 'Parola 6 karakterden az Olamaz.';
                  } else {
                    return null;
                  }
                },
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Şifre',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0))),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _passwordConfirmController,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Parolalar Uyuşmuyor.';
                  } else {
                    return null;
                  }
                },
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    hintText: 'Şifre Onay',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0))),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async { try{
                  if (_registerFormKey.currentState!.validate()) {
                    final user = await Provider.of<Auth>(context, listen: false)
                        .createUserWithEmailAndPassword(
                            _emailController.text, _passwordController.text);
                    if (!user!.emailVerified) {
                      await user.sendEmailVerification();
                    }
                    await _showMyDialog('ONAY GEREKİYOR',
                        'Onay Linkini Tıklayıp Tekrar Giriş Yapmalısınız.');
                    await Provider.of<Auth>(context, listen: false).signOut();

                    setState(() {
                      _formStatus = FormStatus.signIn;
                    });
                  }}on FirebaseAuthException catch(e){
                    print('Hata, ${e.message}');
                  }
                },
                child: const Text('Kayıt'),
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _formStatus = FormStatus.signIn;
                    });
                  },
                  child: const Text('Zaten Üyemisiniz?')),
            ],
          )),
    );
  }

  Widget buildResetForm() {
    final _resetFormKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
          key: _resetFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Şifre Yenileme.',
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (!EmailValidator.validate(value!)) {
                    return 'Lütfen Geçerli Bir Değer Giriniz.';
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'E-mail',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0))),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_resetFormKey.currentState!.validate()) {
                    // try {
                    await Provider.of<Auth>(context, listen: false)
                        .sendPasswordResetEmail(_emailController.text);

                    await _showMyDialog('ONAY GEREKİYOR',
                        'Linke Tıklayarak Şifrenizi Yenileyiniz.');
                    Navigator.pop(context);
                  }
                },
                child: const Text('Gönder'),
              ),
            ],
          )),
    );
  }

  Future<void> _showMyDialog(String baslik, String ikinciText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(baslik),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // Text(ilkText),

                const Text('Merhaba, Lütfen Mailinizi Kontrol Ediniz.'),
                Text(ikinciText),
                // Text('Onay Linkini Tıklayıp Tekrar Giriş Yapmalısınız.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Anladım'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
