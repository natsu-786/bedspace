import 'package:bedspace/auth_service.dart';
import 'package:bedspace/pages/login_screen.dart';
import 'package:bedspace/pages/main_screen.dart';
import 'package:bedspace/providers/product.dart';
import 'package:bedspace/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());


}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(

      providers: [
        ChangeNotifierProvider.value(value:  auth_service(),),
        ChangeNotifierProvider.value(value:  product(),),
        ChangeNotifierProvider.value(value:  products(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Al Shaheen',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:   main_screen(),
        routes: {
          login_screen.routename : (ctx)=>  login_screen(),
          main_screen.routename : (ctx)=>  main_screen(),


        },
      ),
    );
  }
}