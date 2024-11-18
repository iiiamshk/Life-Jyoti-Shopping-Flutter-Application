import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:life_jyoti/widgets/cart/counter.dart';

class CartCard extends StatelessWidget {
  final DocumentSnapshot document;
  CartCard({required this.document});

  @override
  Widget build(BuildContext context) {
    double saving = document['comparedPrice'] - document['price'];
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 16.0, color: Colors.grey.shade300),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      document['productImage'],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 201,
                          child: Text(
                            document['productName'],
                            maxLines: 2,
                          )),
                      Text(
                        document['quantity'],
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 19,
                      ),
                      if (document['comparedPrice'] > 0)
                        Text(
                          document['comparedPrice'].toString(),
                          style:
                              TextStyle(decoration: TextDecoration.lineThrough),
                        ),
                      Text(
                        document['price'].toStringAsFixed(0),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0.0,
              bottom: 0.0,
              child: CounterForCard(document),
            ),
            if (saving > 0)
              Positioned(
                  child: CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          '\u20B9 ${saving.toStringAsFixed(0)}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'SAVED',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
          ],
        ),
      ),
    );
  }
}
