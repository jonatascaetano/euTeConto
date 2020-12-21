import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ComentariosConto extends StatefulWidget {
  DocumentSnapshot documentSnapshot;
  String autorConto;

  ComentariosConto(this.documentSnapshot, this.autorConto);

  @override
  _ComentariosContoState createState() => _ComentariosContoState();
}

class _ComentariosContoState extends State<ComentariosConto> {
  String autor;
  TextEditingController comentarioController = TextEditingController();

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
    if(user != null){
      if (widget.documentSnapshot.data()['autor'] == widget.autorConto) {
      setState(() {
        autor = 'Autor';
      });
    } else {
      setState(() {
        autor = 'Anônimo';
      });
    }
    }else if (user == null){
      setState(() {
        autor = 'Anônimo';
      });
    }
     initializeDateFormatting('pt_BR');
     var formatador = DateFormat('d/M/y H:mm');
     String dataFormatada = formatador.format( widget.documentSnapshot.data()['data'].toDate() );
     print('data formatada ' + dataFormatada.toString());

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 0.8,
      //color: Colors.black26,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
                autor,
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              ),
          
          Text(
            widget.documentSnapshot.data()['texto'],
            style: TextStyle(color: Colors.grey[400], fontSize: 14.0),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(
               dataFormatada.toString(),
                style: TextStyle(color: Color(0xffb34700), fontSize: 14.0),
              ),
              user == null ? Expanded(
                child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.more_vert_outlined,
                        color: Color(0xffb34700),
                      ),
                      onPressed: (){
                        showDialog(
                            context: (context),
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Denunciar comentario',
                                  style: TextStyle(
                                    fontSize: 14
                                  ),
                                ),
                                content: TextField(
                                  cursorColor: Color(0xffb34700),
                                  controller: comentarioController,
                                  style: TextStyle(color: Colors.black),
                                  maxLength: 140,
                                  decoration: InputDecoration(
                                    counterStyle:
                                        TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0) ),
                                    labelText: 'motivo',
                                    labelStyle: TextStyle(color: Colors.black),
                                    
                                  ),
                                ),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancelar')),
                                  FlatButton(
                                      onPressed: () {
                                        if(comentarioController.text.isNotEmpty){
                                          FirebaseFirestore.instance
                                            .collection('denuncias')
                                            .add({
                                          'autor': widget.documentSnapshot
                                              .data()['autor'],
                                          'texto': widget.documentSnapshot
                                              .data()['texto'],
                                          'conto': widget.documentSnapshot
                                              .data()['conto'],
                                          'idComentario': widget.documentSnapshot.reference.id,                                         
                                          'motivo' : comentarioController.text,
                                          'tipo' : 'comentario',
                                          'data': DateTime.now(),
                                          'status' : 'ativo',   
                                        });
                                        Navigator.of(context).pop();
                                        }
                                      },
                                      child: Text('Enviar')),
                                ],
                              );
                            }
                            );
                      }
                      ),
                ],
              )
              ) :  widget.documentSnapshot.data()['autor'] != user.uid ? 
                Expanded(
                child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.more_vert_outlined,
                        color: Color(0xffb34700),
                      ),
                      onPressed: (){
                        showDialog(
                            context: (context),
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Denunciar comentario',
                                  style: TextStyle(
                                    fontSize: 14
                                  ),
                                ),
                                content: TextField(
                                  cursorColor: Color(0xffb34700),
                                  controller: comentarioController,
                                  style: TextStyle(color: Colors.black),
                                  maxLength: 140,
                                  decoration: InputDecoration(
                                    counterStyle:
                                        TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0) ),
                                    labelText: 'motivo',
                                    labelStyle: TextStyle(color: Colors.black),
                                    
                                  ),
                                ),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancelar')),
                                  FlatButton(
                                      onPressed: () {
                                        if(comentarioController.text.isNotEmpty){
                                          FirebaseFirestore.instance
                                            .collection('denuncias')
                                            .add({
                                          'autor': widget.documentSnapshot
                                              .data()['autor'],
                                          'texto': widget.documentSnapshot
                                              .data()['texto'],
                                          'conto': widget.documentSnapshot
                                              .data()['conto'],
                                          'idComentario': widget.documentSnapshot.reference.id,                                         
                                          'motivo' : comentarioController.text,
                                          'tipo' : 'comentario',
                                          'data': DateTime.now(),
                                          'status' : 'ativo',   
                                        });
                                        Navigator.of(context).pop();
                                        }
                                      },
                                      child: Text('Enviar')),
                                ],
                              );
                            }
                            );
                      }
                      ),
                ],
              )
              ) : Container()
            ],
          ),
          
        ],
      ),
    );
  }
}
