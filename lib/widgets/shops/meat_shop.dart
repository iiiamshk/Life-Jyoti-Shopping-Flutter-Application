import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:life_jyoti/Screens/vendor_home_screen.dart';
import 'package:life_jyoti/misc/store_provider.dart';
import 'package:life_jyoti/misc/store_service.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class MeatShop extends StatefulWidget {
  @override
  _MeatShopState createState() => _MeatShopState();
}

class _MeatShopState extends State<MeatShop> {
  @override
  Widget build(BuildContext context) {
    StoreServices _storeServices = StoreServices();
    final _storeData = Provider.of<StoreProvider>(context);
    _storeData.getUserLocationData(context);

    String getDistance(location) {
      var distance = Geolocator.distanceBetween(_storeData.userLatitude,
          _storeData.userLongitude, location.latitude, location.longitude);
      var distanceInKm = distance / 1000;
      return distanceInKm.toStringAsFixed(2);
    }

    return Container(
      child: StreamBuilder(
        stream: _storeServices.getMeatStore(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
          if (!snapShot.hasData)
            return Center(child: Center(child: CircularProgressIndicator()));
          else
            return Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 20),
                      child: Row(
                        children: [
                          Text(
                            'Meat Store\'s For You',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: snapShot.data!.docs
                            .map((DocumentSnapshot document) {
                          if (double.parse(
                                getDistance(document['location']),
                              ) <=
                              10) {
                            return InkWell(
                              onTap: () {
                                _storeData.getSelectedStore(
                                  document,
                                  getDistance(document['location']),
                                );
                                PersistentNavBarNavigator
                                    .pushNewScreenWithRouteSettings(
                                  context,
                                  settings:
                                      RouteSettings(name: VendorHomeScreen.id),
                                  screen: VendorHomeScreen(),
                                  withNavBar: true,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  width: 80,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 80,
                                        width: 80,
                                        child: Card(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.network(
                                              document['imageUrl'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 33,
                                        child: Text(
                                          document['shopname'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        '${getDistance(document['location'])}Km',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
        },
      ),
    );
  }
}
