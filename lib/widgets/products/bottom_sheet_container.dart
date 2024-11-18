import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:life_jyoti/widgets/products/add_to_cart_widget.dart';
import 'package:life_jyoti/widgets/products/save_for_later_widget.dart';

class BottomSheetContainer extends StatefulWidget {
    
   final DocumentSnapshot document;
  BottomSheetContainer(this.document);

  @override
  _BottomSheetContainerState createState() => _BottomSheetContainerState();
}

class _BottomSheetContainerState extends State<BottomSheetContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(flex:1, child: SaveForLater(widget.document)),
          Flexible(flex:1, child: AddToCartWidget(widget.document)),
        ],
      ),
    );
  }
}