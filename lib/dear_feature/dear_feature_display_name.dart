import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayUserName extends Cubit <String>{

  DisplayUserName() : super ('');

  void textInput (String textUserName)=> emit (textUserName);
}