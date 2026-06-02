import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});
  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget>{
  @override
  Widget build(BuildContext context){
    var state = context.watch<HomeState>();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Hola mundo!")
        ],
      ),
    );
  }
}

class HomeState extends ChangeNotifier{
  String _test = "Hola mundo";

  String get test => _test;

  set test(String newValue){
    _test = newValue;
    notifyListeners();
  }
}