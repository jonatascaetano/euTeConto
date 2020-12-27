import 'package:Confidence/abas/biblioteca.dart';
import 'package:Confidence/abas/comentarios.dart';
import 'package:Confidence/abas/inicio.dart';
import 'package:Confidence/abas/salvos.dart';
import 'package:Confidence/telas/novo_conto.dart';
import 'package:Confidence/widgets/search.dart';
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

  @override
  void initState() {
    super.initState();
    usuarioLogado();
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
                          color: Colors.white,
                          fontSize: 24.0,
                          //fontStyle: FontStyle.italic,                          
                        )
                    ),
                  )          
                ),
                 actions: [                
                   IconButton(
                     icon: Icon(Icons.search_rounded),
                     color: Colors.white,
                     onPressed: ()async{
                       String retorno = await showSearch(
                         context: context,
                         delegate: Search(),
                        );
                        print(retorno);
                      }
                     ),

                     user != null ? IconButton(
                     icon: Icon(Icons.add_comment_outlined),
                     color: Color(0xffb34700),
                     onPressed: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> NovoConto())
                        );
                      }
                     ) : Container(),

                    user != null ?  IconButton(
                     icon: Icon(Icons.exit_to_app),
                     color: Colors.red,
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
                    labelColor: Color(0xffff6600),                    
                    indicatorColor: Colors.transparent,                  
                    unselectedLabelColor: Color(0xffb34700),                                                         
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
            color: Colors.black,
            width: 1.0
          )
        ),
        color:  Color(0xff0f1b1b), 
      ),
      padding: EdgeInsets.only(top: 8, bottom: 4),   
         
      child: _tabBar 
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}