import 'dart:ui';
import 'package:Confidence/abas/biblioteca.dart';
import 'package:Confidence/telas/cadastro.dart';
import 'package:Confidence/telas/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  bool senhaSecreta = true;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future entrar()async{
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
       password: senhaController.text
       ).then((value){
         Navigator.of(context).pushReplacement(
           MaterialPageRoute(builder: (context)=> HomePage())
         );
       }).catchError((error){
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Erro ao realizar login')));
         
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff272727),
      body: Form(
        key: _formKey,
      child: SingleChildScrollView(
        child:
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
              TextFormField(
                controller: emailController,
                validator: (texto){
                  if(texto.isEmpty || !texto.contains('@')) return 'Email inválido';
                },               
                style: TextStyle(
                  color: Colors.white
                ),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.white
                  ),
                  suffixIcon: Icon(Icons.email)
                ),
              ),
              TextFormField(
                controller: senhaController,
                validator: (texto){
                  if(texto.isEmpty || texto.length < 6) return 'Senha inválida';
                },
                style: TextStyle(
                  color: Colors.white
                ),
                obscureText: senhaSecreta,              
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(
                    color: Colors.white
                  ),
                  suffixIcon: IconButton(
                    icon: senhaSecreta ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                     onPressed: (){
                      setState(() {
                         senhaSecreta = !senhaSecreta;
                      });
                     }
                     )
                ),
              ),
              SizedBox(height: 8,),
              RaisedButton(
                child: Text('Entrar',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                color: Colors.grey[800],
                onPressed: (){
                  if(_formKey.currentState.validate()){
                    entrar();
                  }
                }
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
      ),
    ),
    );
  }
}