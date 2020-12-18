import 'dart:math';

import 'package:Confidence/abas/biblioteca.dart';
import 'package:Confidence/abas/comentarios.dart';
import 'package:Confidence/abas/inicio.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with AutomaticKeepAliveClientMixin<HomePage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        margin: EdgeInsets.only(top: 24.0),
        child: DefaultTabController(
        length: 3,
         child: NestedScrollView(          
           headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
             return <Widget> [
               SliverAppBar(
                elevation: 50,
                backgroundColor: Color(0xff0f1b1b),                  
                toolbarHeight: 30, 
                floating: true,
                snap: true,
                pinned: false,                 
                flexibleSpace: FlexibleSpaceBar(                 
                  collapseMode: CollapseMode.none,
                  centerTitle: true,
                  titlePadding: EdgeInsets.zero,
                  title: Text(
                        "Eu te conto",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontStyle: FontStyle.italic,                          
                        )
                    ),             
                ),
                 actions: [                
                   IconButton(
                     icon: Icon(Icons.search_rounded),
                     color: Colors.grey,
                     onPressed: (){}
                     ),
                   IconButton(
                     icon: Icon(Icons.account_circle_sharp,
                      color: Colors.orange
                     ),
                     color: Colors.grey,
                     onPressed: (){}
                      )
                 ],   
              ),
               SliverPersistentHeader(               
                delegate: _SliverAppBarDelegate(                 
                  TabBar(                                    
                    labelColor: Colors.orangeAccent,                    
                    indicatorColor: Colors.transparent,                  
                    unselectedLabelColor: Colors.grey,                                     
                    tabs:                      
                    [
                      Tab(                
                        //child: CircleAvatar(child: Icon(Icons.local_library_outlined), backgroundColor: Color(0xff0f1b1b),),                               
                        icon: Icon(Icons.local_library_outlined, ),                      
                      ),
                      Tab(      
                        //child: CircleAvatar(child: Icon(Icons.mode_outlined), backgroundColor: Color(0xff0f1b1b),),                  
                        icon: Icon(Icons.mode_outlined, )                       
                      ),
                      Tab(   
                        //child: CircleAvatar(child: Icon(Icons.mode_comment_outlined), backgroundColor: Color(0xff0f1b1b),),                     
                        icon: Icon(Icons.mode_comment_outlined),                     
                      )
                    ],
                  ),
                ),
                pinned: true, 
              ),             
             ];
           },
            body: Container(
              margin: EdgeInsets.zero,
              child: TabBarView(
                children: [
                  Inicio(),
                  Biblioteca(),
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
      padding: EdgeInsets.only(top: 8, bottom: 4),   
      color:  Color(0xff0f1b1b),     
      child: _tabBar,     
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}