import 'package:Confidence/telas/conto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// ignore: must_be_immutable
class TelaListaSalvos extends StatefulWidget {

  List<DocumentSnapshot> listaContos;

  TelaListaSalvos(this.listaContos);

  @override
  _TelaListaSalvosState createState() => _TelaListaSalvosState();
}

class _TelaListaSalvosState extends State<TelaListaSalvos> {

  TextEditingController comentarioController = TextEditingController();
  List<String> listaSalvos = List();

  excluirConto(contoId) {
    showDialog(
        context: (context),
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Excluir',
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
                    FirebaseFirestore.instance
                        .collection('contos')
                        .doc(contoId)
                        .delete();
                    Navigator.of(context).pop();
                  },
                  child: Text('Excluir')),
            ],
          );
        });
  }

  salvarConto(idConto) async {
    bool existe = false;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).collection('salvos').get();
     String idContoSalvo;
      querySnapshot.docs.forEach((element) {
        if(element.data()['conto'] == idConto){
            setState(() {
              existe = true;
              idContoSalvo = element.reference.id;
            });
        }
        
      });
    print('existe : ' + existe.toString());
    if(existe == false){
    FirebaseFirestore.instance.collection('usuarios').doc(user.uid).collection('salvos').add(
      {
        'conto' : idConto,
        'data' : DateTime.now(),
      }
    );
    }else{
     
      FirebaseFirestore.instance.collection('usuarios').doc(user.uid).collection('salvos').doc(idContoSalvo).delete();
    }
    recuperarContoSalvo();
  }


  recuperarContoSalvo()async{
    QuerySnapshot queryDocumentSnapshot =  await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).collection('salvos').get();
    setState(() {
      listaSalvos = [];
    });
    for(DocumentSnapshot documentSnapshot in queryDocumentSnapshot.docs){
      setState(() {
        listaSalvos.add(documentSnapshot.data()['conto']);
      });
    }
  }

  User user;
  bool logado= false;

  usuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    if(user != null){
      setState(() {
      logado = true;
    });
    }
  }

  @override
  void initState() {
    super.initState();
    usuarioLogado();
    recuperarContoSalvo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
          padding: EdgeInsets.only(top: 5.0),
          itemCount: widget.listaContos.length,
          separatorBuilder: (context, index) => Divider(
                height: 1.0,
                color: Colors.black,
                thickness: 1.0,
              ),
          itemBuilder: (context, index) {
             initializeDateFormatting('pt_BR');
             var formatador = DateFormat('d/M/y H:mm');
             String dataFormatada = formatador.format( widget.listaContos[index]['data'].toDate() );
            
            return Container(
              padding: EdgeInsets.only(left: 12, right: 12),
              color: Color(0xff0f1b1b),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.listaContos[index]['titulo'],
                    maxLines: 2,
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'em ',
                        maxLines: 1,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                      ),
                      Text(
                        widget.listaContos[index]['categoria'],
                        maxLines: 1,
                        style: TextStyle(color: Colors.blue[800], fontSize: 18.0),
                      ),

                     
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    dataFormatada.toString(),
                    style: TextStyle(
                      color: Color(0xffb34700),
                    ),
                  ),
                 
                  SizedBox(
                    height: 8,
                  ),
                  Image.network(
                    widget.listaContos[index]['imagem'],
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.listaContos[index]['texto'],
                          maxLines: 3,
                          style: TextStyle(
                              color: Colors.grey[400], fontSize: 14.0),
                        ),
                        Text(
                          'ver mais',
                          style: TextStyle(color: Colors.blue[800], fontSize: 14.0),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              Conto(widget.listaContos[index].reference.id)));
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.listaContos[index]['curtidas'].length.toString(),
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Color(0xffb34700), fontSize: 18.0),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.thumb_up_alt_outlined,
                                color: Color(0xffb34700),
                              ),
                              onPressed: () {}),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            widget.listaContos[index]['comentarios'].toString(),
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Color(0xffb34700), fontSize: 18.0),
                          ),
                          IconButton(
                              icon: Icon(Icons.mode_comment_outlined,
                                  color: Color(0xffb34700)),
                              onPressed: () {}),
                        ],
                      ),

                      user != null ? IconButton(
                              icon: Icon(
                                  Icons.bookmark_border,
                                  color: listaSalvos.contains(widget.listaContos[index].reference.id) == false ?  Color(0xffb34700) : Colors.blue[800]),
                              onPressed: () {
                                salvarConto(widget.listaContos[index].reference.id);
                              }
                              ) : Container(),

                      IconButton(
                          icon: Icon(
                            Icons.more_vert_outlined,
                            color: Color(0xffb34700),
                          ),
                          onPressed: () {
                           if( user != null){
                             if(widget.listaContos[index]['autor'] == user.uid){
                                 excluirConto(
                                    widget.listaContos[index].reference.id);
                                    }else if (widget.listaContos[index]['autor'] != user.uid){                                                                       
                                         showDialog(
                                    context: (context),
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Denunciar',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        content: TextField(
                                          cursorColor: Color(0xffb34700),
                                          controller: comentarioController,
                                          style: TextStyle(color: Colors.black),
                                          maxLength: 140,
                                          decoration: InputDecoration(
                                            counterStyle:
                                                TextStyle(color: Colors.black),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            labelText: 'motivo',
                                            labelStyle:
                                                TextStyle(color: Colors.black),
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
                                                if (comentarioController
                                                    .text.isNotEmpty) {
                                                  FirebaseFirestore.instance
                                                      .collection('denuncias')
                                                      .add({
                                                    'autor': widget
                                                            .listaContos[index]
                                                        ['autor'],
                                                    'texto': widget
                                                            .listaContos[index]
                                                        ['texto'],
                                                    'idConto': widget
                                                        .listaContos[index]
                                                        .reference
                                                        .id,
                                                    'motivo':
                                                        comentarioController
                                                            .text,
                                                    'tipo': 'conto',
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
                           }else if(user == null){
                                  showDialog(
                                    context: (context),
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Denunciar',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        content: TextField(
                                          cursorColor: Color(0xffb34700),
                                          controller: comentarioController,
                                          style: TextStyle(color: Colors.black),
                                          maxLength: 140,
                                          decoration: InputDecoration(
                                            counterStyle:
                                                TextStyle(color: Colors.black),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            labelText: 'motivo',
                                            labelStyle:
                                                TextStyle(color: Colors.black),
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
                                                if (comentarioController
                                                    .text.isNotEmpty) {
                                                  FirebaseFirestore.instance
                                                      .collection('denuncias')
                                                      .add({
                                                    'autor': widget
                                                            .listaContos[index]
                                                        ['autor'],
                                                    'texto': widget
                                                            .listaContos[index]
                                                        ['texto'],
                                                    'idConto': widget
                                                        .listaContos[index]
                                                        .reference
                                                        .id,
                                                    'motivo':
                                                        comentarioController
                                                            .text,
                                                    'tipo': 'conto',
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
                                     
                          }),

                          
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
