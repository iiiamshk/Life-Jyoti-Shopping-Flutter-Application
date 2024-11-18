import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_jyoti/misc/product_model.dart';
import 'package:life_jyoti/misc/store_provider.dart';
import 'package:life_jyoti/widgets/Search_card.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:map_launcher/map_launcher.dart';

class VendorAppBar extends StatefulWidget {
  @override
  _VendorAppBarState createState() => _VendorAppBarState();
}

class _VendorAppBarState extends State<VendorAppBar> {
  static List<Product> products = [];
  late String offer;
  late String shopName;
  late DocumentSnapshot document;
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("products")
        .get()
        .then((QuerySnapshot querySnapshoot) {
      querySnapshoot.docs.forEach((doc) {
        document = doc;

        setState(() {
          offer = ((doc['comparedPrice'] - doc['price']) /
                  doc['comparedPrice'] *
                  100)
              .toStringAsFixed(0);

          products.add(Product(
            brand: doc['brand'],
            price: doc['price'],
            comparedPrice: doc['comparedPrice'],
            quantity: doc['quantity'],
            category: doc['category']['maincategory'],
            image: doc['productImage'],
            productName: doc['productName'],
            shopName: doc['shopName'],
            document: doc,
          ));
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    products.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _store = Provider.of<StoreProvider>(context);

    mapLauncher() async {
      GeoPoint location = _store.storeDetails['location'];
      final availableMaps = await MapLauncher.installedMaps;

      await availableMaps.first.showMarker(
        coords: Coords(location.latitude, location.longitude),
        title: '${_store.storeDetails['shopname']} is here ',
      );
    }

    return SliverAppBar(
      floating: true,
      snap: true,
      iconTheme: IconThemeData(color: Colors.white),
      expandedHeight: 255,
      flexibleSpace: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(top: 86),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(_store.storeDetails['imageUrl']),
                  ),
                ),
                child: Container(
                  color: Colors.grey.withOpacity(0.5),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Text(
                          _store.storeDetails['dialog'],
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        Text(
                          _store.storeDetails['address'],
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        Text(
                          _store.storeDetails['email'],
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        Text(
                          'Distance : ${_store.distance}Km',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.white),
                            Icon(Icons.star, color: Colors.white),
                            Icon(Icons.star, color: Colors.white),
                            Icon(Icons.star_half, color: Colors.white),
                            Icon(Icons.star_outline, color: Colors.white),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '(3.5)',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                onPressed: () {
                                  launch(
                                      'tel: ${_store.storeDetails['mobile']}');
                                },
                                icon: Icon(
                                  Icons.phone,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                onPressed: () {
                                  mapLauncher();
                                },
                                icon: Icon(
                                  Icons.map,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              shopName = _store.storeDetails['shopname'];
            });
            showSearch(
              context: context,
              delegate: SearchPage<Product>(
                  items: products,
                  searchLabel: 'Search people',
                  suggestion: Center(
                    child: Text('Filter product by name, category or brand'),
                  ),
                  failure: Center(
                    child: Text('No product found :('),
                  ),
                  filter: (product) => [
                        product.productName,
                        product.price.toString(),
                        product.category,
                        product.brand,
                        //filters for search
                      ],
                  builder: (product) => shopName != product.shopName
                      ? Container()
                      : SearchCard(
                          offer: offer,
                          product: product,
                          document: product.document,
                          key: null,
                        )),
            );
          },
          icon: Icon(CupertinoIcons.search),
        ),
      ],
      title: Text(
        _store.storeDetails['shopname'],
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
