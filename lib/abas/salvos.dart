import 'package:Confidence/telas/login.dart';
import 'package:Confidence/widgets/tela_salvo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Salvos extends StatefulWidget {
  @override
  _SalvosState createState() => _SalvosState();
}

class _SalvosState extends State<Salvos> {

  User user;

  usuarioLogado()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    print(user.uid);
  }

  @override
  void initState() {
    super.initState();
    usuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return user == null ?
      Login() : TelaSalvo(user.uid);   
  }
}