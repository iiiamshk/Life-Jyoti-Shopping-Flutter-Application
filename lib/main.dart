import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:life_jyoti/Screens/cart_screen.dart';
import 'package:life_jyoti/Screens/home_screen.dart';
import 'package:life_jyoti/Screens/landing_screen.dart';
import 'package:life_jyoti/Screens/login_screen.dart';
import 'package:life_jyoti/Screens/main_screen.dart';
import 'package:life_jyoti/Screens/map_screen.dart';
import 'package:life_jyoti/Screens/product_details_screen.dart';
import 'package:life_jyoti/Screens/product_list_screen.dart';
import 'package:life_jyoti/Screens/profile_screen.dart';
import 'package:life_jyoti/Screens/profile_update_screen.dart';
import 'package:life_jyoti/Screens/vendor_home_screen.dart';
import 'package:life_jyoti/Screens/welcome_screen.dart';
import 'package:life_jyoti/SplashScreen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:life_jyoti/misc/auth_provider.dart';
import 'package:life_jyoti/misc/cart_provider.dart';
import 'package:life_jyoti/misc/coupon_provider.dart';
import 'package:life_jyoti/misc/location_provider.dart';
import 'package:life_jyoti/misc/order_provider.dart';
import 'package:life_jyoti/misc/store_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => StoreProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CouponProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  late final DocumentSnapshot document;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.pink[300], fontFamily: 'Lato'),
      title: 'LIFE:JYOTI',
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        MapScreen.id: (context) => MapScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        LandingScreen.id: (context) => LandingScreen(),
        MainScreen.id: (context) => MainScreen(),
        VendorHomeScreen.id: (context) => VendorHomeScreen(),
        ProductListScreen.id: (context) => ProductListScreen(),
        ProductDetalisScreen.id: (context) => ProductDetalisScreen(
              document: document,
            ),
        CartScreen.id: (context) => CartScreen(
              document: document,
            ),
        ProfileScreen.id: (context) => ProfileScreen(),
        UpdateProfileScreen.id: (context) => UpdateProfileScreen(),
      },
      builder: EasyLoading.init(),
    );
  }
}
