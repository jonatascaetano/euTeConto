import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NovoComentario extends StatefulWidget {
  String idConto;
  String titulo;

  NovoComentario(this.idConto, this.titulo);

  @override
  _NovoComentarioState createState() => _NovoComentarioState();
}

class _NovoComentarioState extends State<NovoComentario> {
  TextEditingController comentarioController = TextEditingController();
  int comentariosNum;

  comentariosNumero() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('contos').doc(widget.idConto).get();
    setState(() {
      comentariosNum = documentSnapshot.data()['comentarios'];
    });
  }

  salvarComentario(){
   comentariosNumero();

   String autor = FirebaseAuth.instance.currentUser.uid;
   FirebaseFirestore.instance.collection('contos').doc(widget.idConto).collection('comentarios').add({
      'texto' : comentarioController.text,
      'autor' : autor,
      'conto' : widget.idConto,
      'titulo' : widget.titulo,
      'data' : DateTime.now(),
    }).then((value){
      FirebaseFirestore.instance.collection('comentarios').doc(autor).collection('comentarios').doc(value.id).set({
      'texto' : comentarioController.text,
      'autor' : autor,
      'conto' : widget.idConto,
      'titulo' : widget.titulo,
      'data' : DateTime.now(),
    });
    }).then((value){
      FirebaseFirestore.instance.collection('contos').doc(widget.idConto).update({
        'comentarios' : comentariosNum + 1
      });
      comentariosNumero();
      setState(() {
      comentarioController.clear();
    });
      Navigator.of(context).pop();
    });
     
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: TextField(
      autofocus: true,
      cursorColor: Color(0xffb34700),
      controller: comentarioController,
      style: TextStyle(color: Colors.white),
      maxLength: 280,
      minLines: 1,
      maxLines: 5,
      decoration: InputDecoration(
          counterStyle: TextStyle(
            color: Colors.white
          ),
          border: InputBorder.none,  
          labelText: 'comentario',
          labelStyle: TextStyle(color: Colors.white),
          suffixIcon: IconButton(
            icon: Icon(Icons.send,
              color: Color(0xffb34700),
            ),
             onPressed: (){
               if(comentarioController.text.isNotEmpty){
                 salvarComentario();
               }
          })),
    ),
    );
  }
}
