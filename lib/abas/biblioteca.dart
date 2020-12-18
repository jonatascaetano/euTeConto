import 'dart:ui';
import 'package:Confidence/telas/cadastro.dart';
import 'package:Confidence/widgets/tela_biblioteca.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class Biblioteca extends StatefulWidget {
  @override
  _BibliotecaState createState() => _BibliotecaState();
}

class _BibliotecaState extends State<Biblioteca> {

  User user;

  usuarioLogado()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    print(user.uid);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color:  Color(0xff272727),
      child: SingleChildScrollView(
          child: user == null ?
          Container(
            margin: EdgeInsets.only(left: 8, right: 8),
            child: Column(              
            children: [
              SizedBox(height: 30),
              Text('Faça login para acessar',
              style: TextStyle(
                    color: Colors.white
                  ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.white
                  ),
                  suffixIcon: Icon(Icons.email)
                ),
              ),
              TextField(
                obscureText: true,              
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(
                    color: Colors.white
                  ),
                  suffixIcon: Icon(Icons.visibility_off)
                ),
              ),
              SizedBox(height: 8,),
              RaisedButton(
                child: Text('Entrar',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                color: Colors.grey,
                onPressed: (){}
                ),
              SizedBox(height: 8,),
              GestureDetector(
                child: Text('não tem conta? cadastre-se',
              style: TextStyle(
                    color: Colors.white
                  ),
              ),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=> Cadastro())
                );
              },  
              )
            ],
          ),
          )
           : TelaBiblioteca(),
      ),
    );
  }
}