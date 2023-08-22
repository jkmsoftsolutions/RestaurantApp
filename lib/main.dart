import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/views/auth_screen/login_screen.dart';
import 'package:emart_seller/views/home_screen/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

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

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   // Map<dynamic, dynamic> user = new Map();
//   var isLggedin = false;
//   // check user
//   // _getUser() async {
//   //   print("++++++++++++++++++++ ");
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   dynamic userData = (prefs.getString('user'));
//   //   if (userData != null) {
//   //     setState(() {
//   //       user = jsonDecode(userData) as Map<dynamic, dynamic>;
//   //       Navigator.pushReplacement(
//   //           context, MaterialPageRoute(builder: (_) => Home()));
//   //     });
//   //   } else {
//   //     Navigator.pushReplacement(
//   //         context, MaterialPageRoute(builder: (context) => LoginScreen()));
//   //   }
//   // }

//   checkUser() async {
//     auth.authStateChanges().listen((User? user) {
//       if (user == null && mounted) {
//         isLggedin = false;
//       } else {
//         isLggedin = true;
//       }
//       setState(() {
//         (isLggedin)
//             ? Navigator.pushReplacement(
//                 context, MaterialPageRoute(builder: (_) => Home()))
//             : Navigator.pushReplacement(context,
//                 MaterialPageRoute(builder: (context) => LoginScreen()));
//       });
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     Timer(const Duration(seconds: 5), () {
//       //_getUser();
//       checkUser();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: golden,
//       body: Center(
//         child: Column(
//           children: [
//             Align(
//                 alignment: Alignment.topLeft,
//                 child: Image.asset("assets/icons/back_splac.png", width: 300)),
//             20.heightBox,
//             applogoWidget(),
//             10.heightBox,
//             //  Text("${appname.text}")
//             // appname.text.fontFamily(bold).size(22).white.make(),
//             // 5.heightBox,
//             // appversion.text.white.make(),
//             // const Spacer(),
//             // credits.text.white.fontFamily(semibold).make(),
//             // 30.heightBox,
//           ],
//         ),
//       ),
//     );

//     // Scaffold(
//     //     backgroundColor: Colors.white,
//     //     body: Container(
//     //       decoration: BoxDecoration(
//     //           //splash_black.gif
//     //           //spashScreen2.gif
//     //           image: DecorationImage(
//     //               image: NetworkImage("https://i.stack.imgur.com/AfStP.gif"),
//     //               fit: BoxFit.contain)),
//     //     ));
//   }
// }

// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({Key? key}) : super(key: key);

// //   @override
// //   State<SplashScreen> createState() => _SplashScreenState();
// // }

// // class _SplashScreenState extends State<SplashScreen> {
// //   //creating method to change screen

// //   changeScreen() {
// //     Future.delayed(const Duration(seconds: 5), () {
// //       //using getX
// //       //Get.to(() => const LoginScreen());

// //       auth.authStateChanges().listen((User? usser) {
// //         // ignore: unnecessary_null_comparison
// //         if (User == null && mounted) {
// //           Get.to(() => const LoginScreen());
// //         } else {
// //           Get.to(() => const Home());
// //         }
// //       });
// //     });
// //   }

// //   @override
// //   void initState() {
// //     changeScreen();
// //     super.initState();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: golden,
// //       body: Center(
// //         child: Column(
// //           children: [
// //             Align(
// //                 alignment: Alignment.topLeft,
// //                 child: Image.asset("assets/icons/splac.png", width: 300)),
// //             // 20.heightBox,
// //             // applogoWidget(),
// //             // 10.heightBox,
// //             // appname.text.fontFamily(bold).size(22).white.make(),
// //             // 5.heightBox,
// //             // appversion.text.white.make(),
// //             // const Spacer(),
// //             // credits.text.white.fontFamily(semibold).make(),
// //             // 30.heightBox,
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
