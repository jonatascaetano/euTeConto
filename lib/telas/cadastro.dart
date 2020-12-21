import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Confidence/telas/home_page.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  bool senhaSecreta = true;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future cadastrar()async{
    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
       password: senhaController.text
       ).then((value){
         FirebaseFirestore.instance.collection('usuarios').doc(value.user.uid).set({
           'situação' : 'ativa'
         });
         Navigator.of(context).pop();
         Navigator.of(context).pushReplacement(
           MaterialPageRoute(builder: (context)=> HomePage())
         );
         
       }).catchError((error){
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Erro ao realizar cadastro')));
         
       });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:  Color(0xff0f1b1b),
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Form(
        key: _formKey,
      child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 8, right: 8),
            child: Column(              
            children: [
              SizedBox(height: 30),
              
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
                   suffixIcon: Icon(Icons.email, color: Colors.black),
                  suffixStyle: TextStyle(
                    color: Colors.black,
                  )
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
                    icon: senhaSecreta ? Icon(Icons.visibility_off, color: Colors.black) : Icon(Icons.visibility, color: Colors.black),                   
                     onPressed: (){
                      setState(() {
                         senhaSecreta = !senhaSecreta;
                      });
                     }
                     ),
                   suffixStyle: TextStyle(
                    color: Colors.black,
                  )  
                ),
              ),
              SizedBox(height: 8,),
              RaisedButton(
                child: Text('Cadastrar',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                color: Colors.grey[800],
                onPressed: (){
                  if(_formKey.currentState.validate()){
                    cadastrar();
                  }
                }
                ),
              SizedBox(height: 8,),
             
            ],
          ),
          ),
      ),
    ),
    );
  }
}