import 'dart:convert';
import 'package:finalflutterproject/post_detail.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'about_app.dart';
import 'create_post.dart';
import 'favourite.dart';
import 'main.dart';

class PostPageApp extends StatefulWidget{
  const PostPageApp ({required this.channel,
  Key? key}) : super(key:key);


  final WebSocketChannel channel;

  State<StatefulWidget> createState() {
    return PostPageState(channel);
  }
}

class PostPageState extends State<PostPageApp>{

  PostPageState(this.channel);
  WebSocketChannel channel;
  Color _originalFavColor = Colors.black;

  
 

  
  dynamic decodedResults;
  List _post = [];
  String textTitle = "";
  String textDescription= "";
  String textImage = "";
  String statusIcon = "false";
  String textID = "";
  List _allpost = [];
  //List _postFav = [];

   @override
  initState() {
    super.initState();
    widget.channel.stream.listen((results) {
      decodedResults = jsonDecode(results);
      if(decodedResults['type'] == 'all_posts') {
        _post = decodedResults['data']['posts'];
        _allpost = _post;
      }
      setState(() {
      });
    });
    _getPost();
  }

//"limit":10

  void _getPost(){
    widget.channel.sink.add('{"type":"get_posts","data":{}}');
  }

  @override
  void dispose(){
    super.dispose();
  }

  showPopupMenu(){
    
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(25.0, 25.0, 0.0, 0.0),  //position where you want to show the menu on screen
      items: [
        const PopupMenuItem<String>(
            child: Text('About'), value: 'About'),
        const PopupMenuItem<String>(
            child: Text('Sign Out'), value: 'Sign out'),
        
      ],
      elevation: 8.0,
    )
    .then<void>((String? itemSelected) {

      if (itemSelected == null) return;

      if(itemSelected == "About"){

        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutPage()));
      
      }else if(itemSelected == "Sign out"){
        print('Sign Out is clicked');
        
        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()));
      }else{
        //code here
      }

    });
}

  @override
  Widget build(BuildContext context) {

    Padding pad10 = const Padding(padding: EdgeInsets.all(10),);

    Padding pad5 = const Padding(padding: EdgeInsets.all(5),);
    
    return WillPopScope(onWillPop:() async => false,
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:AppBar(
        
        title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            const Text('Exercise 2'),
            IconButton(
              icon: const Icon(Icons.sort_by_alpha),
              onPressed: (){
                // ignore: avoid_print
                print('sort is clicked');
              },
            ),
            IconButton(
              icon: const Icon(Icons.favorite),
              color: Colors.red,
              onPressed: (){
                // ignore: avoid_print
                print('favourite is clicked');
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavouritePageApp()));

              },
            ),
            IconButton(
              icon: const Icon(Icons.settings_applications_outlined),
              onPressed: (){
                // ignore: avoid_print
                print('Setting is clicked');
                showPopupMenu();
              },
            ),
          ],
        ),
        ),
        
      ),
      body: Container(

        decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.red.shade100,
                  Colors.blue,
                ],
              )
          ),
        
          child: ListView.builder(
            itemCount: _post.length+1,
            itemBuilder: (context,index){

              return index == 0 ? _searchBar() : _listItem(index-1);

          })

      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreatePostPageApp(channel: channel,)));
        },
        ),
    )
    );


  }
  _searchBar(){
    return Padding(padding: EdgeInsets.all(8.0),
    child: TextField(
      decoration: const InputDecoration(
        hintText: 'Search by title...',
      ),
      onChanged: (text){
        //so that search result can display the title even though user enter lowercase
        text = text.toLowerCase();
        setState(() {
          _post = _allpost.where((e){
            var postTitle = e["title"].toLowerCase();
            return postTitle.contains(text);
          }).toList();
        });
        
      },
      onEditingComplete: (){
        FocusScope.of(context).unfocus();
      },
    ),
    );
  }
    _listItem(index){
      return Column(
            children: [
              const Padding(padding: EdgeInsets.all(10)),
              Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(
                horizontal: 10,vertical: 6),
                child: InkWell(
                  
                  child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment:CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: Image.network("${_post[index]["image"]}",errorBuilder: (_1,_2,_3){return SizedBox.shrink();},),
                        //fit: BoxFit.fill,),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(padding: const EdgeInsets.only(left: 20,right:8),
                              child: Text(_post[index]["title"],
                              style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                              ),
                              
                              
                              ),
                              ),
                              const Padding(padding: EdgeInsets.all(5)),
                              Padding(padding: const EdgeInsets.only(left: 20,right:8),
                              child: Text(_post[index]["description"],
                              style: const TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              ),
                              ),
                              const Padding(padding: EdgeInsets.all(5)),
                              Padding(padding: const EdgeInsets.only(left: 20,right:8),
                              child: Text(_post[index]["date"],
                              style: const TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic
                              ),
                              
                              ),
                              ),

                              Padding(padding: const EdgeInsets.only(left: 20,right:8),
                              child: Text(_post[index]["author"],
                              style: const TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic
                              ),
                              
                              ),
                              ),
                            ],),)
                            ),

                            Expanded(child: Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: (){

                                      textID = _post[index]["_id"];
                                      print(textID);
                                      widget.channel.sink.add('{"type":"delete_post","data":{"postId": "$textID"}}');

                                      
                                    }, icon: const Icon(
                                      Icons.delete_sharp)
                                  ),
                                  const Padding(padding: EdgeInsets.all(10)),
                                  IconButton(
                                    color: _originalFavColor,
                                    onPressed: (){
                                      setState(() {
                                        //_postFav.add(_post[index]);
                                        textID = _post[index]["_id"];
                                      print(textID);
                                      
                                      if (_post[index]["_id"] == textID){
                                        if(_originalFavColor == Colors.black){
                                        _originalFavColor = Colors.red;
                                      }

                                      else{
                                        _originalFavColor = Colors.black;
                                      }
                                      }

                                      
                                      });
                                    }, icon: const Icon(
                                      Icons.favorite)
                                  ),
                                ],
                              ),
                              )
                            )
                    ],
                  ),
                ),
                  onTap: (){

                    textTitle = _post[index]["title"];
                    textDescription = _post[index]["description"];
                    textImage = _post[index]["image"];
                    

                    print(_post[index]["image"]);
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PostDetailPageApp(getTitle: textTitle,
                        getDesc:textDescription,
                        getImageUrl: textImage)),
                        );
                    
                    //Navigator.of(context).pushNamed(PostDetailPageApp, arguments: jsonEncode(_post[index]["_id"]));
                    
                   /* Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostDetailPage()));*/
                  },
                )
            ),

              
          ],);
    }
}


class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: AboutPageApp(),
    );
  }
}