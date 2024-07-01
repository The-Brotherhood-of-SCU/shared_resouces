import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_resource/pages/main_page.dart';

import 'lib/assets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = SharedPreferences.getInstance();
  prefs.then((value) {
    preferences=value;
    myAccount=value.getString(ACCOUNT_Str);
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple,brightness: Brightness.dark),
      useMaterial3: true,
    ),
      home: myAccount==null? const LoginPage():const Main(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key,});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool isSuccess=false;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('共享资料'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("   "+"Login",textScaler: TextScaler.linear(1.5),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(controller: controller,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.account_circle),
                      labelText: "Account"
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:ElevatedButton(onPressed: ()async{
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder){
                    myAccount=controller.text;
                    return Main();
                  }));
                }, child: const Text("Login"),),
              ),



            ],
          ),
        ),
      ),
    );
  }
}