import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// ignore: must_be_immutable
class ComentariosConto extends StatefulWidget {
  DocumentSnapshot documentSnapshot;
  String autorConto;
  String idConto;

  ComentariosConto(this.documentSnapshot, this.autorConto, this.idConto);

  @override
  _ComentariosContoState createState() => _ComentariosContoState();
}

class _ComentariosContoState extends State<ComentariosConto> {
  String autor;
  TextEditingController comentarioController = TextEditingController();
  String nomeAutorComentario;
    int comentariosNum;
    int comentarioNovoNum;


  User user;

  usuarioLogado()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    print(user.uid);
  }

  void recuperarAutorComentario() async {
   DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('usuarios').doc('usuarios').collection('nomes').doc(widget.documentSnapshot.data()['autor']).get();
    setState(() {
      nomeAutorComentario = documentSnapshot.data()['usuario'];
    });
  }

  excluirComentario() async {
    
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('contos')
        .doc(widget.idConto)
        .get();
      comentariosNum = documentSnapshot.data()['comentarios'];
      comentarioNovoNum = comentariosNum - 1;
      print('numero de comentarios : ' + comentariosNum.toString());
      print('numero de comentarios : ' + comentarioNovoNum.toString());

    if (comentariosNum != null) {
      print('comentariosNãoNum');

      FirebaseFirestore.instance
          .collection('comentarios')
          .doc(user.uid)
          .collection('comentarios')
          .doc(widget.documentSnapshot.reference.id)
          .delete();

      FirebaseFirestore.instance
          .collection('contos')
          .doc(widget.idConto)
          .collection('comentarios')
          .doc(widget.documentSnapshot.reference.id)
          .delete();

      FirebaseFirestore.instance
          .collection('contos')
          .doc(widget.idConto)
          .update({'comentarios': comentarioNovoNum});

      Navigator.of(context).pop();
    } else if (comentariosNum == null) {
      FirebaseFirestore.instance
          .collection('comentarios')
          .doc(user.uid)
          .collection('comentarios')
          .doc(widget.documentSnapshot.reference.id)
          .delete();
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    usuarioLogado();
    recuperarAutorComentario();
  }

  @override
  Widget build(BuildContext context) {
     if (widget.documentSnapshot.data()['autor'] == widget.autorConto) {
      setState(() {
        autor = 'Autor';
      });
    } else {
      nomeAutorComentario == null ?
      setState(() {
        autor = 'Anônimo';
      }) :

      setState(() {
        autor = nomeAutorComentario;
      });

    }
     initializeDateFormatting('pt_BR');
      var formatadorData = DateFormat('d/M/y');
      var formatadorHora = DateFormat('H:mm');
     String dataFormatada = formatadorData.format( widget.documentSnapshot.data()['data'].toDate() );
     String horaFormatada = formatadorHora.format( widget.documentSnapshot.data()['data'].toDate() );

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.only(left: 8, right: 8),
      width: MediaQuery.of(context).size.width * 0.8,
      //color: Colors.black26,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
                autor + ' disse:',
                style: TextStyle(color: Colors.grey[600], fontSize: 11.0),
              ),
          SizedBox(
                height: 6,
              ),

          Text(
            widget.documentSnapshot.data()['texto'],
            style: TextStyle(color: Colors.white, fontSize: 14.0),
          ),

          SizedBox(
            height: 0,
          ),
          Row(
            children: [
              Text(
                dataFormatada.toString() + ' às ' + horaFormatada.toString(),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
              user == null ? Expanded(
                child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.more_vert_outlined,
                        size: 14,
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
                        size: 14,
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
              ) : Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.more_vert_outlined,
                              size: 14,
                              color: Color(0xffb34700),
                            ),
                        onPressed: () {
                          showDialog(
                              context: (context),
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'Excluir comentario',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancelar')),
                                    FlatButton(
                                        onPressed: () {
                                        
                                        excluirComentario();
                                        },
                                        child: Text('Excluir')),
                                  ],
                                );
                              });
                        }),
                  ],
                ))
            ],
          ),
          SizedBox(
                height: 8,
              ),
        ],
      ),
    );
  }
}
