import 'package:Confidence/abas/biblioteca.dart';
import 'package:Confidence/abas/comentarios.dart';
import 'package:Confidence/abas/inicio.dart';
import 'package:Confidence/abas/salvos.dart';
import 'package:Confidence/telas/novo_conto.dart';
import 'package:Confidence/widgets/search.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with AutomaticKeepAliveClientMixin<HomePage>{


  User user;

  usuarioLogado()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    print(user.uid);
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

  @override
  void initState() {
    super.initState();
    usuarioLogado();
    interstitialAd = AdmobInterstitial(
      adUnitId: 'ca-app-pub-1685263058686351/3168067128',
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
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        margin: EdgeInsets.only(top: 24.0),
        child: DefaultTabController(
        length: 4,
         child: NestedScrollView(          
           headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
             return <Widget> [
               SliverAppBar(
                backgroundColor: Color(0xff0f1b1b),                  
                toolbarHeight: 40.0,
                floating: false,
                pinned: false,
                snap: false,              
                flexibleSpace: FlexibleSpaceBar(                             
                  titlePadding: EdgeInsets.zero,
                  title: Padding(padding: EdgeInsets.only(left: 16, bottom: 8),
                    child: Text(
                        "Eu te conto",
                        style: TextStyle(
                          color: Color(0xffb34700), // Colors.white,
                          fontSize: 24.0,
                          //fontStyle: FontStyle.italic,                          
                        )
                    ),
                  )          
                ),
                 actions: [                
                   IconButton(
                     icon: Container(
                       child: Icon(Icons.search_rounded),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black38, 
                      ),
                     ),                    
                     color: Color(0xffb34700), // Colors.grey[600], //Colors.white,
                     onPressed: ()async{
                       String retorno = await showSearch(
                         context: context,
                         delegate: Search(),
                        );
                        print(retorno);
                      }
                     ),

                     user != null ? IconButton(
                     icon: Container(
                       child: Icon(Icons.add_comment_outlined),
                       decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black38, 
                      ),
                     ),
                     color: Color(0xffb34700), // Colors.grey[600], //Color(0xffb34700),
                     onPressed: (){
                        showInterstitial();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> NovoConto() )
                        );
                      }
                     ) : Container(),

                    user != null ?  IconButton(
                     icon: Container(
                       width: 30,
                       height: 30,
                       child: Icon(Icons.exit_to_app),
                       decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black38, 
                      ),
                     ),
                     color: Color(0xffb34700), //Colors.grey[600],
                     onPressed: (){
                       FirebaseAuth.instance.signOut().then((_){
                         setState(() {
                           usuarioLogado();
                         });
                       });
                     }
                     ) : Container()
                 ],   
              ),
               SliverPersistentHeader(               
                delegate: _SliverAppBarDelegate(                 
                  TabBar(                                    
                    labelColor: Color(0xffb34700), //Colors.white, //Color(0xffb34700),                    
                    indicatorColor: Color(0xffb34700), // Colors.white,                                      
                    unselectedLabelColor: Colors.grey[600], //Color(0xffb34700),                                                         
                    tabs:                      
                    [
                      Tab(                                             
                        icon: Icon(Icons.local_library_outlined, ),                      
                      ),
                      Tab(                    
                        icon: Icon(Icons.mode_outlined, )                       
                      ),
                      Tab(                    
                        icon: Icon(Icons.bookmark_border, )                       
                      ),
                      Tab(   
                        icon: Icon(Icons.mode_comment_outlined),                     
                      )
                    ],
                  ),
                ),
                pinned: true,
                floating: false,                
              ),             
             ];
           },
            body: Container(
              margin: EdgeInsets.zero,
              child: TabBarView(
                children: [
                  Inicio(),
                  Biblioteca(),
                  Salvos(),
                  Comentarios(),                 
                ]
                ),
                )
            )
         ),
      )
    );
  }
   @override
  bool get wantKeepAlive => true;
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;


  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container( 
      
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[800],
            width: 1.0,
          )
        ),
        color: Color(0xff0f1b1b), 
      ),
      //padding: EdgeInsets.only(top: 8, bottom: 4),   
       
      //color: Color(0xff0f1b1b),
      //color: Color(0xff602040),
      child: _tabBar 
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}