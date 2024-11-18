import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_jyoti/widgets/products/bottom_sheet_container.dart';

class ProductDetalisScreen extends StatelessWidget {
  static const String id = 'product-details-screen';
  final DocumentSnapshot document;
  ProductDetalisScreen({required this.document});
  @override
  Widget build(BuildContext context) {
    String offer = ((document['comparedPrice'] - document['price']) /
            document['comparedPrice'] *
            100)
        .toStringAsFixed(0);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.search))
        ],
      ),
      bottomSheet: BottomSheetContainer(document),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(.3),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, bottom: 2, top: 2),
                    child: Text(document['brand']),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              document['productName'],
              maxLines: 2,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              document['quantity'],
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  '\u20B9${document['price'].toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                if (document['comparedPrice'] > 0)
                  Text(
                    '\u20B9${document['comparedPrice'].toStringAsFixed(0)}',
                    style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 14),
                  ),
                SizedBox(
                  width: 10,
                ),
                if (document['comparedPrice'] > 0)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, bottom: 3, top: 3),
                      child: Text(
                        '$offer% OFF',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(19.0),
              child: Hero(
                  tag: 'product${document['productName']}',
                  child: Image.network(document['productImage'])),
            ),
            Divider(
              color: Colors.grey[300],
              thickness: 5,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  'About This Product',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            Divider(
              color: Colors.grey[400],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
              child: ExpandableText(document['description'],
                  expandText: 'view more',
                  collapseText: 'view less',
                  maxLines: 3,
                  style: TextStyle(color: Colors.black87, fontSize: 15)),
            ),
            Divider(
              color: Colors.grey[400],
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  'Other Product Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            Divider(
              color: Colors.grey[400],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SKU : ${document['sku']}',
                      style: TextStyle(color: Colors.black87, fontSize: 16)),
                  SizedBox(
                    height: 5,
                  ),
                  Text('Seller : ${document['shopName']}',
                      style: TextStyle(color: Colors.black87, fontSize: 16)),
                ],
              ),
            ),
            SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
