import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:life_jyoti/Screens/login_screen.dart';
import 'package:life_jyoti/Screens/main_screen.dart';
import 'package:life_jyoti/misc/auth_provider.dart';
import 'package:life_jyoti/misc/location_provider.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map-screen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng currentLocation;
  late final GoogleMapController _mapController;
  bool _locating = false;
  bool _loggedIn = false;
  User? user;

  @override
  void initState() {
    //check user logged in or not,while opening map screen
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
    if (user != null) {
      setState(() {
        _loggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    final _auth = Provider.of<AuthProvider>(context);

    setState(() {
      currentLocation = LatLng(locationData.latitude, locationData.longitude);
    });

    void onCreated(GoogleMapController controller) {
      setState(() {
        _mapController = controller;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLocation,
                zoom: 14.4746,
              ),
              zoomControlsEnabled: false,
              minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              mapToolbarEnabled: true,
              onCameraMove: (CameraPosition position) {
                setState(() {
                  _locating = true;
                });
                locationData.onCameraMove(position);
              },
              onMapCreated: onCreated,
              onCameraIdle: () {
                setState(() {
                  _locating = false;
                });
                locationData.getMoveCamera();
              },
            ),
            Center(
              child: Container(
                height: 50,
                margin: EdgeInsets.only(bottom: 40),
                child: Image.asset('assets/Images/marker.png',
                    color: Colors.black),
              ),
            ),
            Center(
              child: SpinKitPulse(
                color: Colors.black54,
                size: 100.0,
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _locating
                        ? LinearProgressIndicator(
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 20),
                      child: TextButton.icon(
                        onPressed: () {
                          locationData.getCurrentPosition();
                        },
                        icon: Icon(
                          Icons.location_searching,
                          color: Theme.of(context).primaryColor,
                        ),
                        label: Flexible(
                          child: Text(
                            _locating
                                ? 'Locating...'
                                : locationData.selectedLocation == null
                                    ? 'Locating...'
                                    : locationData.selectedLocation,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        _locating
                            ? ' '
                            : locationData.selectedAddress == null
                                ? ''
                                : locationData.selectedLocation,
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: AbsorbPointer(
                          absorbing: _locating ? true : false,
                          child: ElevatedButton(
                              onPressed: () {
                                //save address in shared preferences
                                locationData.savePrefs();
                                if (_loggedIn == false) {
                                  Navigator.pushNamed(context, LoginScreen.id);
                                } else {
                                  setState(() {
                                    _auth.latitude = locationData.latitude;
                                    _auth.longitude = locationData.longitude;
                                    _auth.address =
                                        locationData.selectedAddress;
                                    _auth.location =
                                        locationData.selectedLocation;
                                  });
                                  _auth.updateUser(
                                    id: user!.uid,
                                    number: user!.phoneNumber,
                                  );
                                  Navigator.pushNamed(context, MainScreen.id);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _locating
                                    ? Colors.grey
                                    : Theme.of(context).primaryColor,
                              ),
                              child: Text(
                                'CONFIRM LOCATION',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
