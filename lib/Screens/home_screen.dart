import 'package:flutter/material.dart';
import 'package:life_jyoti/widgets/image_slider.dart';
import 'package:life_jyoti/widgets/my_appbar.dart';
import 'package:life_jyoti/widgets/shops/meat_shop.dart';
import 'package:life_jyoti/widgets/top_pick_store.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-Screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [MyAppBar()];
        },
        body: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.only(top: 0.0),
            children: [
              ImageSlider(),
              TopPickStore(),
              MeatShop(),
              
            ],
          ),
        ),
      ),
    );
  }
}
