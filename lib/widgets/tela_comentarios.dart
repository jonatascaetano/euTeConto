import 'package:Confidence/widgets/lista_meus_comentarios.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class TelaComentarios extends StatefulWidget {
  @override
  _TelaComentariosState createState() => _TelaComentariosState();
}


class _TelaComentariosState extends State<TelaComentarios> {

String autor;

  recuperarUsuario(){
    setState(() {
      autor = FirebaseAuth.instance.currentUser.uid;
    });
  }

  @override
  void initState() {
    super.initState();
    recuperarUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color:  Color(0xff0f1b1b),  
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('comentarios').doc(autor).collection('comentarios').orderBy('data').snapshots(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(0xffb34700),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xffb34700))
              ),
              
            );
            break;
          default: 
                if(snapshot.data.docs.length ==0 ){
                  return Center(
                    child: Text('Nada encontrado',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }else{    

            return MeusComentarios(snapshot.data.docs.reversed.toList());
          }    
        }
       }
      )
    );
  }
}