import 'package:finalflutterproject/post_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class FavouritePageApp extends StatefulWidget{
  FavouritePageApp ({required this.channel, required this.postfavlist, Key?key}) : super(key: key);

  final WebSocketChannel channel;
  List postfavlist = [];
  
  State<StatefulWidget> createState(){
    return FavouritePageState(this.channel,this.postfavlist);
  }
}

class FavouritePageState extends State<FavouritePageApp>{

  FavouritePageState(this.channel,this.postfavlist);
  WebSocketChannel channel;
  List postfavlist = [];

  String textTitle = "";
  String textDescription= "";
  String textImage = "";

  void retrieveCard () => widget.channel.sink.add('{"type":"get_posts"}');
  Future <void> refresh () async {
    setState(() {
      retrieveCard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Favourite Page'),),
      body: Container(
        // decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //         begin: Alignment.topRight,
        //         end: Alignment.bottomLeft,
        //         colors: [
        //           Colors.red.shade100,
        //           Colors.blue,
        //         ],
        //       )
        //   ),
        child:ListView.builder(
                itemCount: postfavlist.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
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
                          child: Image.network("${postfavlist[index]["image"]}",errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Container(
                                      width: 100,
                                      height: 100,
                                      child: Image.asset('images/404.png'));
                                },),
                          //fit: BoxFit.fill,),
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(padding: const EdgeInsets.only(left: 20,right:8),
                                child: Text(postfavlist[index]["title"],
                                style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                                ),
                                
                                
                                ),
                                ),
                                const Padding(padding: EdgeInsets.all(5)),
                                Padding(padding: const EdgeInsets.only(left: 20,right:8),
                                child: Text(postfavlist[index]["description"],
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
                                child: Text(postfavlist[index]["date"],
                                style: const TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic
                                ),
                                
                                ),
                                ),

                                Padding(padding: const EdgeInsets.only(left: 20,right:8),
                                child: Text(postfavlist[index]["author"],
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      //Delete post
                                      onPressed: (){

                                        /*textID = _post[index]["_id"];
                                        
                                        widget.channel.sink.add('{"type":"delete_post","data":{"postId": "$textID"}}');*/
                                      }, 
                                      icon: const Icon(
                                        Icons.delete_sharp)
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                    child: ElevatedButton(
                                      
                                      onPressed: (){
                                        setState(() {
                                          postfavlist.remove(postfavlist[index]);
                                          refresh();
                                        });
                                      },
                                      
                                      child: postfavlist.contains(postfavlist[index])? 
                                      const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      ) : const Icon(
                                        Icons.favorite,
                                        color: Colors.black,)
                                      ),
                                      ),

                                    const Padding(padding: EdgeInsets.all(10)),
                                    
                                  ],
                                ),
                                )
                              )
                      ],
                    ),
                  ),
                    onTap: (){

                      textTitle = postfavlist[index]["title"];
                      textDescription = postfavlist[index]["description"];
                      textImage = postfavlist[index]["image"];
                    
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PostDetailPageApp(getTitle: textTitle,
                        getDesc:textDescription,
                        getImageUrl: textImage)),
                        );
                    },
                  )
              ),

                
            ],);
                },
              ),
          
      ),
    );
  }
}