import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance
    .authStateChanges()
    .listen((User? user) {
      if(user == null){
        print('User is signed out');
      }else{
        print('User is signed in');
      }
  });

  runApp(ChangeNotifierProvider(
      create: (context) => LoginState(),
      child: const MaterialApp(
        home: LoginWidget()
      ),
  ));
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});
  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {

  final TextEditingController _tecEmail = TextEditingController();
  final TextEditingController _tecPass = TextEditingController();
  bool _isLoading = false;

  Future<bool> signIn(String email, String pass) async {
    try{
      setState(() {
        _isLoading = true;
      });
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
      return true;
    } on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found'){
        print('No user found');
      }else if (e.code == 'wrong-password'){
        print('Wrong password');
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context){
    var state = context.watch<LoginState>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Email: "),
            TextField(
                controller: _tecEmail
            ),
            Text("Password: "),
            TextField(
              controller: _tecPass,
            ),
            ElevatedButton(
                onPressed: () async {
                  final email = _tecEmail.text.trim();
                  final password = _tecPass.text.trim();

                  bool success = await signIn(email, password);

                  if(success & mounted){
                    state.email = email;
                    state.password = password;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                          create: (context) => HomeState(),
                          child: const HomeWidget(),
                        )
                      ),
                    );
                  }
                },
              child: const Text("Iniciar sesion"),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginState extends ChangeNotifier{
  String _email = "";
  String _password = "";

  String get email => _email;
  String get password => _password;

  set email(String newValue){
    _email = newValue;
    notifyListeners();
  }
  set password(String newValue){
    _password = newValue;
    notifyListeners();
  }
}
