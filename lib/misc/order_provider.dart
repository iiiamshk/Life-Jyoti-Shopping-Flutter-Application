import 'package:flutter/cupertino.dart';

class OrderProvider with ChangeNotifier {
  late String status;
  filterOrder(status) {
    this.status = status;
    notifyListeners();
  }
}
