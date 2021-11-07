import 'package:finalflutterproject/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dear_feature/dear_feature_display_name.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Name Page',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: BlocProvider(create: (context)=>DisplayUserName(),
      child: const MyHomePage(title: 'User Name Page'),),
      
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final myController = TextEditingController();
  bool _validateUsrInput = false;

  final _channel = WebSocketChannel.connect(
  Uri.parse('ws://besquare-demo.herokuapp.com'),
  );
  
  @override
  void initState(){
    super.initState();
    myController.addListener(_enableORdisableBtn);
    BackButtonInterceptor.add(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    // ignore: avoid_print
    print("BACK BUTTON!"); // Do some stuff.
    return true;
  }

  void _enableORdisableBtn(){
    setState(() {
      if (myController.text.isNotEmpty){
        _validateUsrInput = true;
      }

      else{
        _validateUsrInput = false;
      }
    });
  }

  void _sendMessage(){
    if(myController.text.isNotEmpty){
      _channel.sink.add('{ "type": "sign_in", "data": {"name": "$myController.text"}}');

      //checkConnect();
    }
  }

  @override
  void dispose (){
    myController.dispose();
    _channel.sink.close();
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {

    
    Text headings = 
    const Text('User Name',
    style: TextStyle(fontWeight: FontWeight.bold,
    fontSize: 20),);

    Padding pad10 = const Padding(padding: EdgeInsets.all(10),);

    return WillPopScope(onWillPop:() async => false,
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(
          child: Text(widget.title),
        )
      ),
      body:Column(
          children: <Widget>[
            pad10,
            Center(child: headings,),
            pad10,
            BlocBuilder<DisplayUserName, String>(
              builder: (context, state) {
                return  TextField(
                  controller: myController,
                  onEditingComplete: (){
                    context.read<DisplayUserName>().textInput(myController.text.toString());
                    FocusScope.of(context).unfocus();
                  },
              style: const TextStyle(
                
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              decoration: const InputDecoration(
                
                contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                hintText: 'Enter username',
                helperText:
                'Just enter your username and get ready to organize your life',
                helperMaxLines: 2,
                border: OutlineInputBorder(),
                icon: Icon(Icons.person),
              ),
                      
              );
              },
            ),

            
            pad10,
            BlocBuilder<DisplayUserName, String>(builder: (context,text){
              return Text('Welcome $text');
            }),
            
            pad10,
            BlocBuilder<DisplayUserName,String>(
              builder: (context,username){
                return Column(children: [
               Row(children: [
                //5th row
                 Expanded(
                  
                  child: OutlinedButton(
                    child: const Text(
                      'ENTER TO THE APP',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'NotoSans',
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400),
                    ),
                    onPressed:!_validateUsrInput? null : () {

                      if(_validateUsrInput){
                        _sendMessage();
                        
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PostPageApp(channel: _channel)),
                        );

                        /*Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreatePostPageApp(channel: _channel)),
                        );*/
                      /*Navigator.push(
                      context,MaterialPageRoute(builder: (context) => PostPage()),
                      );*/
                      }
                    },
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        side: const BorderSide(
                          width: 1.0,
                          color: Colors.black,
                          style: BorderStyle.solid,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                  ),
                )
              ]),
            ]);
              },),
            
            
          
          ],
        ),
      
    ),);
  }
}



// ignore: use_key_in_widget_constructors
/*class CreatePostPage extends StatelessWidget{
    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: CreatePostPageApp(),
    );
  }
}*/
