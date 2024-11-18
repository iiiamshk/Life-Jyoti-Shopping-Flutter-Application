import 'package:flutter/material.dart';
import 'package:life_jyoti/misc/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CodToggleSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _cart = Provider.of<CartProvider>(context);

    return Container(
      color: Colors.white,
      child: ToggleSwitch(
          inactiveBgColor: Colors.grey.shade300,
          activeFgColor: Colors.grey.shade700,
          activeBgColor: [Theme.of(context).primaryColor],
          cornerRadius: 20,
          labels: [
            "Pay Online",
            "Cash On Delivery",
          ],
          onToggle: (index) {
            _cart.getPaymentMethod(index);
          } // Do something with index
          ),
    );
  }
}
