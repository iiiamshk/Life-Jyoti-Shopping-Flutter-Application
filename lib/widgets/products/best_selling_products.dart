import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:life_jyoti/misc/product_service.dart';
import 'package:life_jyoti/misc/store_provider.dart';
import 'package:life_jyoti/widgets/products/product_card_widget.dart';
import 'package:provider/provider.dart';

class BestSellingProducts extends StatefulWidget {
  @override
  _BestSellingProductsState createState() => _BestSellingProductsState();
}

class _BestSellingProductsState extends State<BestSellingProducts> {
  @override
  void initState() {
    BestSellingProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProductServices _services = ProductServices();
    var _store = Provider.of<StoreProvider>(context);
    return FutureBuilder<QuerySnapshot>(
      future: _services.products
          .where('published', isEqualTo: true)
          .where('collection', isEqualTo: 'Best Selling')
          .where('sellerUid', isEqualTo: _store.storeDetails['uid'])
          .orderBy('productName')
          .limitToLast(10)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (!snapshot.hasData) {
          return Container();
        }
        if (snapshot.data!.docs.isEmpty) {
          return Container();
        }

        return Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 20, left: 8, right: 8),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: 56,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      'Best Selling',
                      style: TextStyle(
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(3.0, 3.0),
                              blurRadius: 3.0,
                              color: Colors.black,
                            ),
                          ],
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 21),
                    ),
                  ),
                ),
              ),
            ),
            new ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return new ProductCard(document);
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
