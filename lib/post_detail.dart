import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class PostDetailPageApp extends StatefulWidget{

  
  PostDetailPageApp ({required this.getTitle,
  required this.getDesc, required this.getImageUrl,
  Key? key}) : super(key:key);


  final String getTitle;
  final String getDesc;
  final String getImageUrl;

  State<StatefulWidget> createState() {
    return PostDetailPageState(getTitle,getDesc,getImageUrl);
  }
  
   
  
}

class PostDetailPageState extends State<PostDetailPageApp>{

  
  PostDetailPageState(this.getTitle,this.getDesc,this.getImageUrl);
  String getTitle;
  String getDesc;
  String getImageUrl;
  
  @override
  Widget build(BuildContext context) {
    Padding pad10 = const Padding(padding: EdgeInsets.all(10),);

    Container postImage = Container(
      width: 250.0,
      height: 170.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(getImageUrl),fit: BoxFit.fill),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Post Details Page'),
        ),
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
        ),
      body: Container(
        child: Center(
          child: Column(
          children: [
            pad10,
            postImage,
            Text(widget.getTitle,style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              ),
            ),
            Text(widget.getDesc,style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              ),
            ),
          ],
          ),
        ),),
    );
  }
}

/*class PostPage extends StatelessWidget{
    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.amber),
      home: PostPageApp(),
    );
  }
}*/