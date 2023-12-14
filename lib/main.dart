import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/views/auth_screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyApo_LXvkjDA1vLVt_x8naMvEnFOAgn2wo",
            authDomain: "emart-dd54c.firebaseapp.com",
            projectId: "emart-dd54c",
            storageBucket: "emart-dd54c.appspot.com",
            messagingSenderId: "503258272064",
            appId: "1:503258272064:web:41b67b0a743f042df72aa5"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

// guddu
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initSatate() {
    super.initState();
    checkUser();
  }

  var isLggedin = false;
  checkUser() async {
    auth.authStateChanges().listen((User? user) {
      if (user == null && mounted) {
        isLggedin = false;
      } else {
        isLggedin = true;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      home: LoginPage(),
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      )),
    );
  }
}
