import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class CreatePostPageApp extends StatefulWidget{
  
  CreatePostPageApp ({required this.channel,
  Key? key}) : super(key:key);


  final WebSocketChannel channel;

  State<StatefulWidget> createState() {
    return CreatePostPageState(channel);
  }
  
}

class CreatePostPageState extends State<CreatePostPageApp>{

  CreatePostPageState(this.channel);
  WebSocketChannel channel;

  final _txtTitle = TextEditingController();
  final _txtDesc = TextEditingController();
  final _txtImageUrl = TextEditingController();
  bool _validateUsrInput = false;

  /*final _channel = WebSocketChannel.connect(
  Uri.parse('ws://besquare-demo.herokuapp.com'),
  );*/
  

  void checkConnect () async{
    channel.stream.listen((event) { 
      print(event);
    });
  } 

  @override
  void initState(){
    _txtTitle.addListener(_enableORdisableBtn);
    _txtDesc.addListener(_enableORdisableBtn);
    _txtImageUrl.addListener(_enableORdisableBtn);
    super.initState();
  }

  //the function below with either disable or enable the button to work
  void _enableORdisableBtn(){
    setState(() {
      if (_txtTitle.text.isNotEmpty && _txtDesc.text.isNotEmpty && _txtImageUrl.text.isNotEmpty ){
        _validateUsrInput = true;
      }

      else{
        _validateUsrInput = false;
      }
    });
  }

  void _sendMessage(){
    if(_txtTitle.text.isNotEmpty && _txtDesc.text.isNotEmpty && _txtImageUrl.text.isNotEmpty){
      channel.sink.add('{"type":"create_post","data":{"title":"$_txtTitle.text","description":"$_txtDesc.text","image":"$_txtImageUrl.text"}}');
      //checkConnect();
    }
  }

  @override
  void dispose(){
    _txtDesc.dispose();
    _txtImageUrl.dispose();
    _txtTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppBar header = AppBar(
      title: const Center(
        child: Text("Adding Post",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    Padding pad10 = const Padding(padding: EdgeInsets.all(10),);

    Padding pad5 = const Padding(padding: EdgeInsets.all(5),);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: header,
      body: Container(
        decoration: BoxDecoration(
          gradient:LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.red.shade100,
                  Colors.blue,
                ],
              ) 
        ),
        child: Column(
          children:[
            pad10,
            const Text('Title:',
            style: TextStyle(fontSize: 15,
            fontWeight: FontWeight.bold,
            ),),
            pad5,
            TextField(
              controller: _txtTitle,
              decoration: const InputDecoration(
                hintText: 'Enter title of the post',
                border: OutlineInputBorder(),
                 icon: Icon(Icons.title),),
            ),
            pad10,
            const Text('Description:',
            style: TextStyle(fontSize: 15,
            fontWeight: FontWeight.bold,
            ),),
            pad5,
            TextField(
              controller: _txtDesc,
              decoration: const InputDecoration(
                hintText: 'Enter description for this post',
                border: OutlineInputBorder(),
                 icon: Icon(Icons.description_outlined),),
            ),
            pad10,
            const Text('Image link:',
            style: TextStyle(fontSize: 15,
            fontWeight: FontWeight.bold,
            ),),
            pad5,
            TextField(
              controller: _txtImageUrl,
              decoration: const InputDecoration(
                hintText: 'Enter URL of the image to be displayed',
                border: OutlineInputBorder(),
                 icon: Icon(Icons.image_rounded),),
            ),

            pad10,pad10,

            Column (
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed:(){
                     Navigator.of(context).pop();
                    
                  }, child: const Text('Back',
                    style: TextStyle(color: Colors.black,
                    fontWeight: FontWeight.bold),
                  )
                  )
                ),

                pad5,
                Expanded(
                  child: OutlinedButton(onPressed: !_validateUsrInput? null : (){
                    if(_validateUsrInput){
                        print('Hello');
                      _sendMessage();
                      
                    }
                  }, child: const Text('Submit Post',
                    style: TextStyle(color: Colors.black,
                    fontWeight: FontWeight.bold),
                  )
                  )
                ),
                ],
              ),

              
            ],),
          ],),
      ),

    );
  }

}