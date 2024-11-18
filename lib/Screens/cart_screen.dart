import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:life_jyoti/Screens/map_screen.dart';
import 'package:life_jyoti/Screens/profile_screen.dart';
import 'package:life_jyoti/misc/auth_provider.dart';
import 'package:life_jyoti/misc/cart_provider.dart';
import 'package:life_jyoti/misc/cart_services.dart';
import 'package:life_jyoti/misc/coupon_provider.dart';
import 'package:life_jyoti/misc/location_provider.dart';
import 'package:life_jyoti/misc/order_services.dart';
import 'package:life_jyoti/misc/store_service.dart';
import 'package:life_jyoti/misc/user_services.dart';
import 'package:life_jyoti/widgets/cart/cart_list.dart';
import 'package:life_jyoti/widgets/cart/cod_toggle.dart';
import 'package:life_jyoti/widgets/cart/coupon_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  static const String id = 'cart-screen';
  final DocumentSnapshot document;
  CartScreen({required this.document});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  StoreServices _store = StoreServices();
  OrderServices _orderServices = OrderServices();
  CartServices _cartServices = CartServices();
  UserServices _userServices = UserServices();
  User? user = FirebaseAuth.instance.currentUser;
  late DocumentSnapshot doc;
  var textStyle = TextStyle(color: Colors.grey);
  int deliveryFee = 20;
  String _location = '';
  String _address = '';
  bool _loading = false;
  bool _checkingUser = false;
  double discount = 0;

  @override
  void initState() {
    getPrefs();
    _store.getShopDetails(widget.document['sellerUid']).then((value) {
      setState(() {
        doc = value;
      });
    });
    super.initState();
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? location = prefs.getString('location');
    String? address = prefs.getString('address');

    setState(() {
      _location = location!;
      _address = address!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    var _cartProvider = Provider.of<CartProvider>(context);
    var userDetails = Provider.of<AuthProvider>(context);
    var _coupon = Provider.of<CouponProvider>(context);
    userDetails.getUserDetails().then((value) {
      double subTotal = _cartProvider.subTotal;
      double discountRate = _coupon.discountRate / 100;
      setState(() {
        discount = subTotal * discountRate;
      });
    });
    var _payable = _cartProvider.subTotal + deliveryFee - discount;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[200],
      bottomSheet: userDetails.snapshot == null
          ? Container()
          : Container(
              height: 140,
              color: Colors.blueGrey[900],
              child: Column(
                children: [
                  Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                'Deliver to this address : ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              )),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _loading = false;
                                  });
                                  locationData
                                      .getCurrentPosition()
                                      .then((value) {
                                    if (value != null) {
                                      PersistentNavBarNavigator
                                          .pushNewScreenWithRouteSettings(
                                        context,
                                        settings:
                                            RouteSettings(name: MapScreen.id),
                                        screen: MapScreen(),
                                        withNavBar: false,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino,
                                      );
                                    } else {
                                      setState(() {
                                        _loading = false;
                                      });
                                      print('Permission not allowed');
                                    }
                                  });
                                },
                                child: _loading
                                    ? CircularProgressIndicator()
                                    : Text(
                                        'Change',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 13),
                                      ),
                              ),
                            ],
                          ),
                          Text(
                            userDetails.snapshot['firstName'] != null
                                ? '${userDetails.snapshot['firstName']} ${userDetails.snapshot['lastName']} : $_location, $_address'
                                : '$_location, $_address',
                            maxLines: 3,
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '\u20B9 ${_payable.toStringAsFixed(0)}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '(Including all of Taxes)',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          // ignore: deprecated_member_use
                          ElevatedButton(
                              child: _checkingUser
                                  ? CircularProgressIndicator()
                                  : Text(
                                      'CHECKOUT',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent),
                              onPressed: () {
                                EasyLoading.show(status: 'Please Wait...');
                                _userServices
                                    .getuserById(user!.uid)
                                    .then((value) {
                                  if (value['firstName'] == null) {
                                    EasyLoading.dismiss();
                                    //need to confirm username before placing order.
                                    PersistentNavBarNavigator
                                        .pushNewScreenWithRouteSettings(
                                      context,
                                      settings:
                                          RouteSettings(name: ProfileScreen.id),
                                      screen: ProfileScreen(),
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.cupertino,
                                    );
                                  } else {
                                    EasyLoading.show(status: 'Please Wait...');
                                    _saveOrder(
                                        _cartProvider, _payable, _coupon);
                                  }
                                });
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBozIsSxrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.document['shopName'],
                    style: TextStyle(fontSize: 17),
                  ),
                  Row(
                    children: [
                      Text(
                        '${_cartProvider.cartQty} ${_cartProvider.cartQty > 1 ? 'items,' : 'item,'}',
                        style: TextStyle(fontSize: 10),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        'To Pay : \u20B9 ${_payable.toStringAsFixed(0)}',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ];
        },
        body: doc == null
            ? Center(child: CircularProgressIndicator())
            : _cartProvider.cartQty > 0
                ? SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 80),
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                ListTile(
                                  tileColor: Colors.white,
                                  leading: Container(
                                    height: 60,
                                    width: 60,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        doc['imageUrl'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  title: Text(doc['shopname']),
                                  subtitle: Text(
                                    doc['address'],
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black54),
                                  ),
                                ),
                                CodToggleSwitch(),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey[800],
                          ),
                          CartList(
                            document: widget.document,
                          ),
                          //Coupon Card
                          CouponWidget(doc['uid']),
                          //Bill Detail card
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 4, left: 4, top: 4, bottom: 80),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Billing Details',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text('Basket Value',
                                                  style: textStyle)),
                                          Text(
                                            '\u20B9 ${_cartProvider.subTotal.toStringAsFixed(0)}',
                                            style: textStyle,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      if (discount > 0)
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Text('Discount',
                                                    style: textStyle)),
                                            Text(
                                              '\u20B9 ${discount.toStringAsFixed(0)}',
                                              style: textStyle,
                                            ),
                                          ],
                                        ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text('Delivery Fee ',
                                                  style: textStyle)),
                                          Text(
                                            '\u20B9 $deliveryFee',
                                            style: textStyle,
                                          ),
                                        ],
                                      ),
                                      Divider(color: Colors.grey),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Total Amount Payable',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(
                                            '\u20B9 ${_payable.toStringAsFixed(0)}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(.3),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Total Saving',
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                ),
                                              ),
                                              Text(
                                                '\u20B9 ${_cartProvider.saving.toStringAsFixed(0)}',
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(child: Text('Cart Empty, Continue Shopping')),
      ),
    );
  }

  _saveOrder(CartProvider cartProvider, payable, CouponProvider coupon) {
    _orderServices.saveOrder({
      'products': cartProvider.cartList,
      'userId': user?.uid,
      'deliveryFee': deliveryFee,
      'total': payable,
      'discount': discount.toStringAsFixed(0),
      'cod': cartProvider.cod,
      'discountCode': coupon.document == null ? null : coupon.document['title'],
      'seller': {
        'shopName': widget.document['shopName'],
        'sellerUid': widget.document['sellerUid'],
      },
      'timestamp': DateTime.now().toString(),
      'orderStatus': 'Ordered',
      'deliveryBoy': {
        'name': '',
        'phone': '',
        'location': '',
      }
    }).then((value) {
      //after submitting order,need to clear cart list.
      _cartServices.deleteCart().then((value) {
        _cartServices.checkData().then((value) {
          EasyLoading.showSuccess('Your order is submitted');
          Navigator.pop(context); //close cart screen
        });
      });
    });
  }
}
