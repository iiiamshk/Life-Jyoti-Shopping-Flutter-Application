import 'package:flutter/material.dart';
import 'package:life_jyoti/widgets/categorises_widget.dart';
import 'package:life_jyoti/widgets/products/best_selling_products.dart';
import 'package:life_jyoti/widgets/products/featured_products.dart';
import 'package:life_jyoti/widgets/products/recently_added_products.dart';
import 'package:life_jyoti/widgets/vendor_appbar.dart';
import 'package:life_jyoti/widgets/vendor_banner.dart';

class VendorHomeScreen extends StatelessWidget {
  static const String id = 'vendor-screen';

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            VendorAppBar(),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.only(bottom: 51),
          child: ListView(
            physics: NeverScrollableScrollPhysics(), 
            shrinkWrap: true,
            children: [
              //vendor Banner
              VendorBanner(),
              //vendor Categories
              VendorCategories(), //culprit of app crash
              //Featured Products
              FeaturedProducts(),   
              //Best Selling Products
              BestSellingProducts(), 
              //Recently Added Products
              RecentlyAddedProducts(), 
            ],
          ),
        ),
      ),
    );
  }
}
