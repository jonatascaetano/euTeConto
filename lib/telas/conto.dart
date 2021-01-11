import 'package:Confidence/telas/comentarios_conto.dart';
import 'package:Confidence/widgets/novo_comentario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:admob_flutter/admob_flutter.dart';

const String testDevice = 'ca-app-pub-1685263058686351~7553174892';

// ignore: must_be_immutable
class Conto extends StatefulWidget {
  String id;
  Conto(this.id);

  @override
  _ContoState createState() => _ContoState();
}

class _ContoState extends State<Conto> {
  List<DocumentSnapshot> comentariosLista = List();
  TextEditingController comentarioController = TextEditingController();
  GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();
  bool curtido= false;

  
  recuperarComentariosConto(){
    FirebaseFirestore.instance
        .collection('contos')
        .doc(widget.id)
        .collection('comentarios')
        .orderBy('data')
        .snapshots().listen((event) {
          comentariosLista = event.docs;
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

  atualizarCurtida(List<dynamic> curtidasRecebida) {
    print(
        'tamanho da lista de curtidas: ' + curtidasRecebida.length.toString());
    if (curtidasRecebida.length == 0) {
      List<dynamic> curtidos = List();
      curtidos = curtidasRecebida;
      curtidos.add(user.uid);

      FirebaseFirestore.instance
          .collection('contos')
          .doc(widget.id)
          .update({'curtidas': curtidos});
    } else {
      for (dynamic idCurtidas in curtidasRecebida) {
        if (idCurtidas == user.uid) {
         curtido = true;
        }
      }
      print('curtido resultado: ' + curtido.toString());
      if (curtido == false) {
        List<dynamic> curtidos = List();
        curtidos = curtidasRecebida;
        curtidos.add(user.uid);

        FirebaseFirestore.instance
            .collection('contos')
            .doc(widget.id)
            .update({'curtidas': curtidos});
      } else {
        List<dynamic> curtidos = List();
        curtidos = curtidasRecebida;
        curtidos.remove(user.uid);

        FirebaseFirestore.instance
            .collection('contos')
            .doc(widget.id)
            .update({'curtidas': curtidos});
      }
      curtido = false;
    }
  }

  inserirComentario(BuildContext context, id, titulo){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context){
        return BottomSheet(
          onClosing: (){},
          builder: (context){            
              return Container(
                child: SingleChildScrollView(
                child: Container(
                padding: EdgeInsets.all(8),
                color: Color(0xff262626),                                 
                width: MediaQuery.of(context).size.width,
                child: Padding(padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: NovoComentario(id, titulo),
                ),
              ),
              ),
              );
          },
        );
      }
      );
  }
  
  User user;

  usuarioLogado()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    print(user.uid);
  }

  
  AdmobBanner getBanner(AdmobBannerSize size) {
    return AdmobBanner(
      adUnitId: 'ca-app-pub-1685263058686351/9146098791',
      adSize: size,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        handleEvent(event, args, 'Banner');
      },
    );
  }

  AdmobBanner getMiniBanner(AdmobBannerSize size) {
    return AdmobBanner(
      adUnitId: 'ca-app-pub-1685263058686351/5155463457',
      adSize: size,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        handleEvent(event, args, 'Banner');
      },
    );
  }


  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        print('Novo $adType Ad carregado!');
        break;
      case AdmobAdEvent.opened:
        print('Admob $adType Ad aberto!');
        break;
      case AdmobAdEvent.closed:
        print('Admob $adType Ad fechado!');
        break;
      case AdmobAdEvent.failedToLoad:
        print('Admob $adType falhou ao carregar. :(');
        break;
      default:
    }
  }
  


  @override
  void initState() {
    super.initState();
    Admob.initialize();
    recuperarComentariosConto();
    usuarioLogado();


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
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
                    dados['idConto'] = snapshot.data.reference.id;
                    initializeDateFormatting('pt_BR');
                     var formatadorData = DateFormat('d/M/y');
                     var formatadorHora = DateFormat('H:mm');
                    String dataFormatada = formatadorData.format(dados['data'].toDate());
                    String horaFormatada = formatadorHora.format(dados['data'].toDate());

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
                                      style: TextStyle(color: Colors.blue[800], fontSize: 14.0),
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: 4,
                                ),

                                Text(
                                  dataFormatada.toString() + ' às ' + horaFormatada.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xffb34700),
                                  ),
                                ),


                                /*        
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
                                */ 
                                 SizedBox(
                                  height: 12,
                                ),

                                Container(                                
                                  child: getMiniBanner(AdmobBannerSize.BANNER),
                                ),     

                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  dados['texto'],
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 14.0),
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
                                              atualizarCurtida(dados['curtidas']);
                                              
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
                                         user  == null ? showDialog(
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
                                              ) : dados['autor'] != user.uid ?
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
                                  height: 12,
                                ),
                                
                                Container(                                
                                  child: getBanner(AdmobBannerSize.MEDIUM_RECTANGLE),
                                ),
                               
                                SizedBox(
                                  height: 12,
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
                                        children: comentariosLista.reversed.toList()
                                            .map((doc) => ComentariosConto(doc, dados['autor'])).toList(),
                                      ),
                                user != null ?
                                GestureDetector(
                                  child: Padding(padding: EdgeInsets.only(bottom: 16),
                                    child: Text(
                                          'Comentar',
                                          style: TextStyle(
                                              color: Color(0xffb34700),
                                              fontSize: 18.0),
                                        ),
                                  ),
                                  onTap: (){                                  
                                   inserirComentario(context, snapshot.data.reference.id, dados['titulo']);
                                  },
                                ) : Container()
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
