import 'package:Confidence/telas/conto.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// ignore: must_be_immutable
class MeusComentarios extends StatefulWidget {
  List<QueryDocumentSnapshot> listaComentarios;

  MeusComentarios(this.listaComentarios);

  @override
  _MeusComentariosState createState() => _MeusComentariosState();
}

class _MeusComentariosState extends State<MeusComentarios> {
  int comentariosNum;
  int comentarioNovoNum;

  String autor;

  recuperarUsuario() {
    setState(() {
      autor = FirebaseAuth.instance.currentUser.uid;
    });
  }

 
  excluirComentario(String idConto, String idComentario, index) async {
    
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('contos')
        .doc(idConto)
        .get();
      comentariosNum = documentSnapshot.data()['comentarios'];
      comentarioNovoNum = comentariosNum - 1;
    print('numero de comentarios : ' + comentariosNum.toString());
    print('numero de comentarios : ' + comentarioNovoNum.toString());

    if (comentariosNum != null) {
      print('comentariosNãoNum');
      String idConto = widget.listaComentarios[index]['conto'];
      String idComentario = widget.listaComentarios[index].reference.id;
      print('idConto : ' + idConto);
      print('idComentario : ' + idComentario);

      FirebaseFirestore.instance
          .collection('comentarios')
          .doc(autor)
          .collection('comentarios')
          .doc(idComentario)
          .delete();

      FirebaseFirestore.instance
          .collection('contos')
          .doc(idConto)
          .collection('comentarios')
          .doc(idComentario)
          .delete();

      FirebaseFirestore.instance
          .collection('contos')
          .doc(idConto)
          .update({'comentarios': comentarioNovoNum});

      Navigator.of(context).pop();
    } else if (comentariosNum == null) {
      print('comentariosNum');
      String idConto = widget.listaComentarios[index]['conto'];
      String idComentario = widget.listaComentarios[index].reference.id;
      print('idConto : ' + idConto);
      print('idComentario : ' + idComentario);
      FirebaseFirestore.instance
          .collection('comentarios')
          .doc(autor)
          .collection('comentarios')
          .doc(idComentario)
          .delete();
      Navigator.of(context).pop();
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
        adUnitId: 'ca-app-pub-1685263058686351/5515669493',
        adSize: size,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          handleEvent(event, args, 'Banner');
        },
      );
    }

  @override
  void initState() {
    super.initState();
    recuperarUsuario();
    interstitialAd = AdmobInterstitial(
        adUnitId: 'ca-app-pub-1685263058686351/9299001831',
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
    return ListView.separated(
      itemCount: widget.listaComentarios.length,
      separatorBuilder: (context, index) => Divider(
        height: 1.0,
        color: Colors.grey[800],
        thickness: 1.0,
      ),
      itemBuilder: (context, index) {
        initializeDateFormatting('pt_BR');
        var formatadorData = DateFormat('d/M/y');
        var formatadorHora = DateFormat('H:mm');
        String dataFormatada = formatadorData.format(widget.listaComentarios[index]['data'].toDate());
        String horaFormatada = formatadorHora.format(widget.listaComentarios[index]['data'].toDate());

        return Container(
          
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Container(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       GestureDetector(
                          child: Text(
                            widget.listaComentarios[index]['titulo'],
                            maxLines: 3,
                            style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                          ),
                          onTap: () {
                            showInterstitial();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    Conto(widget.listaComentarios[index]['conto'])));
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          widget.listaComentarios[index]['texto'],
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                        ),
                        
                        Row(
                          children: [

                            Text(
                              dataFormatada.toString() + ' às ' + horaFormatada.toString(),
                              style: TextStyle(
                                color: Color(0xffb34700),
                              ),
                            ),

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
                                                      String idConto = widget.listaComentarios[index]['conto'];
                                                      String idComentario = widget.listaComentarios[index].reference.id;

                                                      excluirComentario(idConto, idComentario, index);
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
                    ],
                  ),
                ),

                index != 0 && index % 4 == 0 ?
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
      },
    );
  }
}
