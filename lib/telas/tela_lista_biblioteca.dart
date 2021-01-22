import 'dart:ui';
import 'package:Confidence/telas/conto.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


// ignore: must_be_immutable
class TelaListaBiblioteca extends StatefulWidget {
  List<QueryDocumentSnapshot> listaContos;

  TelaListaBiblioteca(this.listaContos);

  @override
  _TelaListaBibliotecaState createState() => _TelaListaBibliotecaState();
}

class _TelaListaBibliotecaState extends State<TelaListaBiblioteca> {

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

  AdmobInterstitial interstitialAd;

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

  AdmobBanner getBanner(AdmobBannerSize size) {
      return AdmobBanner(
        adUnitId: 'ca-app-pub-1685263058686351/7371676645',
        adSize: size,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          handleEvent(event, args, 'Banner');
        },
      );
    }

  @override
  void initState() {
    super.initState();
    usuarioLogado();
    recuperarContoSalvo();
    interstitialAd = AdmobInterstitial(
      adUnitId: 'ca-app-pub-1685263058686351/2685507935',
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );
    interstitialAd.load();
   
  }

  void showInterstitial() async {
    if (await interstitialAd.isLoaded) {
      interstitialAd.show();
    } else {
      print("Interstitial ainda não foi carregado...");
    }
  }

  @override
  void dispose() {
    super.dispose();
    interstitialAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
          padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
          itemCount: widget.listaContos.length,
          separatorBuilder: (context, index) => Divider(
                height: 1.0,
                color: Colors.grey[800],
                //thickness: 1.0,
              ),
          itemBuilder: (context, index) {
             initializeDateFormatting('pt_BR');
             var formatadorData = DateFormat('d/M/y');
             var formatadorHora = DateFormat('H:mm');
             String dataFormatada = formatadorData.format( widget.listaContos[index]['data'].toDate() );
             String horaFormatada = formatadorHora.format( widget.listaContos[index]['data'].toDate() );
 
               return Container(   
                  color: Color(0xff0f1b1b),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Container(
                        padding: EdgeInsets.only(left: 12, right: 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                        height: 16,
                      ),
                      
                      Text(
                        widget.listaContos[index]['titulo'],
                        maxLines: 2,
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
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
                    
                      SizedBox(
                        height: 4,
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
                            widget.listaContos[index]['categoria'],
                            maxLines: 1,
                            style: TextStyle(color: Colors.blue[800], fontSize: 14.0),
                          ),

                        
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),

                      

                      /*
                      Image.network(
                        widget.listaContos[index]['imagem'],
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      */

                      GestureDetector(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.listaContos[index]['texto'],
                              maxLines: 6,
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 14.0),
                            ),
                            Text(
                              'ver mais',
                              style: TextStyle(color: Colors.blue[800], fontSize: 14.0),
                            ),
                          ],
                        ),
                        onTap: () {
                          showInterstitial();                                         
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Conto(widget.listaContos[index].reference.id)));
                         
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      user != null ?
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

                          Container(
                           child:  StreamBuilder(
                                    stream: FirebaseFirestore.instance.collection('contos').doc( widget.listaContos[index].reference.id ).collection('comentarios').snapshots(),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.none:
                                        case ConnectionState.waiting:
                                          return Container(
                                            
                                            child: Row(
                                                children: [
                                                  Text(
                                                    '0',
                                                    textAlign: TextAlign.justify,
                                                    style: TextStyle(
                                                        color: Color(0xffb34700), fontSize: 18.0),
                                                  ),

                                                  IconButton(
                                                      icon: Icon(Icons.mode_comment_outlined,
                                                          color: Color(0xffb34700)),
                                                      onPressed: () {}),
                                                ],
                                              )
                                            /*
                                            Center(
                                            child: CircularProgressIndicator(
                                                backgroundColor: Color(0xffb34700),
                                                valueColor:
                                                    AlwaysStoppedAnimation<Color>(Color(0xffb34700))),
                                            )
                                            */
                                          );
                                          break;
                                        default:
                                          if (!snapshot.hasData) {
                                            return Row(
                                                children: [
                                                  Text(
                                                    '0',
                                                    textAlign: TextAlign.justify,
                                                    style: TextStyle(
                                                        color: Color(0xffb34700), fontSize: 18.0),
                                                  ),

                                                  IconButton(
                                                      icon: Icon(Icons.mode_comment_outlined,
                                                          color: Color(0xffb34700)),
                                                      onPressed: () {}),
                                                ],
                                              );
                                          } else {                                        
                                            return Row(
                                                children: [
                                                  Text(
                                                    snapshot.data.docs.length.toString(),
                                                    textAlign: TextAlign.justify,
                                                    style: TextStyle(
                                                        color: Color(0xffb34700), fontSize: 18.0),
                                                  ),

                                                  IconButton(
                                                      icon: Icon(Icons.mode_comment_outlined,
                                                          color: Color(0xffb34700)),
                                                      onPressed: () {}),
                                                ],
                                              );
                                          }
                                        }
                                    }
                                  ),
                         ),

                          /*
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
                          */

                          user != null ? IconButton(
                                  icon: Icon(
                                      listaSalvos.contains(widget.listaContos[index].reference.id) == false ? Icons.bookmark_border_sharp : Icons.bookmark_sharp,
                                      color: Color(0xffb34700)),
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
                      ) 
                      
                      : 

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

                          Container(
                           child:  StreamBuilder(
                                    stream: FirebaseFirestore.instance.collection('contos').doc( widget.listaContos[index].reference.id ).collection('comentarios').snapshots(),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.none:
                                        case ConnectionState.waiting:
                                          return Container(
                                            
                                            child: Row(
                                                children: [
                                                  Text(
                                                    '0',
                                                    textAlign: TextAlign.justify,
                                                    style: TextStyle(
                                                        color: Color(0xffb34700), fontSize: 18.0),
                                                  ),

                                                  IconButton(
                                                      icon: Icon(Icons.mode_comment_outlined,
                                                          color: Color(0xffb34700)),
                                                      onPressed: () {}),
                                                ],
                                              )
                                            /*
                                            Center(
                                            child: CircularProgressIndicator(
                                                backgroundColor: Color(0xffb34700),
                                                valueColor:
                                                    AlwaysStoppedAnimation<Color>(Color(0xffb34700))),
                                            )
                                            */
                                          );
                                          break;
                                        default:
                                          if (!snapshot.hasData) {
                                            return Row(
                                                children: [
                                                  Text(
                                                    '0',
                                                    textAlign: TextAlign.justify,
                                                    style: TextStyle(
                                                        color: Color(0xffb34700), fontSize: 18.0),
                                                  ),

                                                  IconButton(
                                                      icon: Icon(Icons.mode_comment_outlined,
                                                          color: Color(0xffb34700)),
                                                      onPressed: () {}),
                                                ],
                                              );
                                          } else {                                        
                                            return Row(
                                                children: [
                                                  Text(
                                                    snapshot.data.docs.length.toString(),
                                                    textAlign: TextAlign.justify,
                                                    style: TextStyle(
                                                        color: Color(0xffb34700), fontSize: 18.0),
                                                  ),

                                                  IconButton(
                                                      icon: Icon(Icons.mode_comment_outlined,
                                                          color: Color(0xffb34700)),
                                                      onPressed: () {}),
                                                ],
                                              );
                                          }
                                        }
                                    }
                                  ),
                         ),

                          /*
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
                          */

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
                          ],
                        ),
                      ),

                      index != 0 && index % 6 == 0 ?
                        Column(
                          children: [
                              SizedBox(
                                  height: 12,
                                ),

                                Divider(
                                  height: 1.0,
                                  color: Colors.grey[800],
                                  //thickness: 1.0,
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

                          ],
                        ) : Container(),
                     
                    ],
                  ),
                );
            
            
          }),
    );
  }
}
