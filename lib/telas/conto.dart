import 'package:Confidence/telas/comentarios_conto.dart';
import 'package:Confidence/widgets/novo_comentario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Conto extends StatefulWidget {
  String id;
  Conto(this.id);

  @override
  _ContoState createState() => _ContoState();
}

class _ContoState extends State<Conto> {
  List<DocumentSnapshot> comentariosLista = List();
  TextEditingController comentarioController = TextEditingController();
  bool curtido= false;

  Future recuperarConto() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('contos')
        .doc(widget.id)
        .collection('comentarios')
        .orderBy('data')
        .get();

    setState(() {
      comentariosLista = querySnapshot.docs;
    });
  }

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

  User user;

  usuarioLogado()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    print(user.uid);
  }

  @override
  void initState() {
    super.initState();
    recuperarConto();
    usuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff0f1b1b),
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('contos')
                .doc(widget.id)
                .snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(
                        backgroundColor: Color(0xffb34700),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xffb34700))),
                  );
                  break;
                default:
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text(
                        'Não existem contos',
                        style: TextStyle(fontSize: 32, color: Colors.grey),
                      ),
                    );
                  } else {
                    Map<String, dynamic> dados = Map();

                    dados['titulo'] = snapshot.data['titulo'];
                    dados['texto'] = snapshot.data['texto'];
                    dados['imagem'] = snapshot.data['imagem'];
                    dados['categoria'] = snapshot.data['categoria'];
                    dados['comentarios'] = snapshot.data['comentarios'];
                    dados['curtidas'] = snapshot.data['curtidas'];
                    dados['autor'] = snapshot.data['autor'];
                    dados['data'] = snapshot.data['data'];
                    initializeDateFormatting('pt_BR');
                    var formatador = DateFormat('d/M/y H:m');
                    String dataFormatada = formatador.format(dados['data'].toDate());

                    return Container(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 8, right: 8),
                        child: SingleChildScrollView(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(padding: EdgeInsets.only(top: 64),
                                  child: Text(
                                  dados['titulo'],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'em ',
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.grey, fontSize: 14.0),
                                    ),
                                    Text(
                                      dados['categoria'],
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.blue, fontSize: 18.0),
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
                                dados['imagem'] == null
                                    ? Container()
                                    : Image.network(
                                        dados['imagem'],
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  dados['texto'],
                                  style: TextStyle(
                                      color: Colors.grey[400], fontSize: 14.0),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          dados['curtidas'].length.toString(),
                                          style: TextStyle(
                                              color: Color(0xffb34700),
                                              fontSize: 18.0),
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              Icons.thumb_up_alt_outlined,
                                              color: Color(0xffb34700),
                                            ),
                                            onPressed: () {
                                              print('tamanho da lista de curtidas: ' + dados['curtidas'].length.toString() );
                                              if(dados['curtidas'].length == 0){
                                                List<dynamic> curtidos = List();
                                                curtidos = dados['curtidas'];
                                                curtidos.add(user.uid);

                                                FirebaseFirestore.instance.collection('contos').doc(widget.id).update(
                                                  {
                                                    'curtidas' : curtidos
                                                  }
                                                );
                                              }else{
                                                for(dynamic idCurtidas in dados['curtidas']){
                                                if (idCurtidas == user.uid){
                                                  setState(() {
                                                    curtido = true;
                                                  });
                                                } 
                                              }
                                              print('curtido resultado: ' + curtido.toString());
                                              if(curtido == false){
                                                List<dynamic> curtidos = List();
                                                curtidos = dados['curtidas'];
                                                curtidos.add(user.uid);

                                                FirebaseFirestore.instance.collection('contos').doc(widget.id).update(
                                                  {
                                                    'curtidas' : curtidos
                                                  }
                                                );
                                              }else{
                                                List<dynamic> curtidos = List();
                                                curtidos = dados['curtidas'];
                                                curtidos.remove(user.uid);

                                                FirebaseFirestore.instance.collection('contos').doc(widget.id).update(
                                                  {
                                                    'curtidas' : curtidos
                                                  }
                                                );
                                              }
                                              curtido = false;
                                              
                                             
                                              }
                                              
                                            }
                                            ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          comentariosLista.length.toString(),
                                          style: TextStyle(
                                              color: Color(0xffb34700),
                                              fontSize: 18.0),
                                        ),
                                        IconButton(
                                            icon: Icon(
                                                Icons.mode_comment_outlined,
                                                color: Color(0xffb34700)),
                                            onPressed: () {}),
                                      ],
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.more_vert_outlined,
                                          color: Color(0xffb34700),
                                        ),
                                        onPressed: () {
                                          dados['autor'] != user.uid ?
                                          showDialog(
                                              context: (context),
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Denunciar',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  content: TextField(
                                                    cursorColor:
                                                        Color(0xffb34700),
                                                    controller:
                                                        comentarioController,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    maxLength: 140,
                                                    decoration: InputDecoration(
                                                      counterStyle: TextStyle(
                                                          color: Colors.black),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0)),
                                                      labelText: 'motivo',
                                                      labelStyle: TextStyle(
                                                          color: Colors.black),
                                                      
                                                    ),
                                                  ),
                                                  actions: [
                                                    FlatButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:
                                                            Text('Cancelar')),
                                                    FlatButton(
                                                        onPressed: () {
                                                          if (comentarioController
                                                              .text
                                                              .isNotEmpty) {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'denuncias')
                                                                .add({
                                                              'autor': dados[
                                                                  'autor'],
                                                              'texto': dados[
                                                                  'texto'],
                                                              'idConto':
                                                                  snapshot
                                                                      .data
                                                                      .reference
                                                                      .id,
                                                              'motivo':
                                                                  comentarioController
                                                                      .text,
                                                              'tipo': 'conto',
                                                              'data': DateTime.now(),
                                                              'status' : 'ativo',
                                                            });
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }
                                                        },
                                                        child: Text('Enviar')),
                                                  ],
                                                );
                                              }
                                              ) : excluirConto( snapshot.data.reference.id );
                                              
                                        }),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                comentariosLista.length == 0
                                    ? Container()
                                    : Text(
                                        'Comentarios',
                                        style: TextStyle(
                                            color: Color(0xffb34700),
                                            fontSize: 18.0),
                                      ),
                                SizedBox(
                                  height: 8,
                                ),
                                comentariosLista == null
                                    ? Container()
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: comentariosLista
                                            .map((doc) => ComentariosConto(
                                                doc, dados['autor'])) 
                                            .toList(),
                                      ),
                                Container(
                                  //margin: EdgeInsets.all(4),
                                  padding: EdgeInsets.all(8),
                                  color: Color(0xff262626),                                 
                                  width: MediaQuery.of(context).size.width,
                                  child: NovoComentario(
                                      snapshot.data.reference.id, dados['titulo']),
                                ),
                              ],
                            ),
                          ),
                        ));
                  }
              }
            })
            );
  }
}
