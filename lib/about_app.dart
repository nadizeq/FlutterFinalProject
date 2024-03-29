import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:settings_ui/settings_ui.dart';


class AboutPageApp extends StatefulWidget{
  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPageApp>{
 
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Information'),
        ),
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
        ),
      body: SettingsList(
        sections: [
          SettingsSection(
            titlePadding: const EdgeInsets.all(20),
            title: 'About Us',
            tiles: [
              

              SettingsTile(
                title: 'Introduction',
                subtitle: 'This app can return the list, adding post and view post detail. Sorting function is not available yet',
                subtitleMaxLines: 2,
                leading: const Icon(Icons.language),
                onPressed: (BuildContext context) {},
              ),
              const SettingsTile(
                title: 'Author',
                subtitle: 'Develop by N',
                leading: Icon(Icons.person),
                
              ),

              /*SettingsTile.switchTile(
                title: 'Use System Theme',
                leading: const Icon(Icons.phone_android),
                switchValue: isSwitched,
                onToggle: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),*/
            ],
          ),
          
        ],
      ),
    );
  }

}