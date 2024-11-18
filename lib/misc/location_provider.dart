import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  double latitude = 26.148043;
  double longitude = 91.731377;
  bool permissionAllowed = false;
  var selectedAddress;
  var selectedLocation;
  bool loading = false;

  Future<Position> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    this.latitude = position.latitude;
    this.longitude = position.longitude;

    final List<Placemark> placemarks =
        await placemarkFromCoordinates(this.latitude, this.longitude);

    final addresses =
        "${placemarks.reversed.last.locality} ${placemarks.reversed.last.administrativeArea} ${placemarks.reversed.last.name} ${placemarks.reversed.last.isoCountryCode} ${placemarks.reversed.last.postalCode} ";
    this.selectedLocation = "${placemarks.reversed.last.locality}";
    this.selectedAddress = addresses;

    this.permissionAllowed = true;
    notifyListeners();

    return position;
  }

  void onCameraMove(CameraPosition cameraPosition) async {
    this.latitude = cameraPosition.target.latitude;
    this.longitude = cameraPosition.target.longitude;
    notifyListeners();
  }

  Future<void> getMoveCamera() async {
    final List<Placemark> placemarks =
        await placemarkFromCoordinates(this.latitude, this.longitude);
    final addresses =
        "${placemarks.reversed.last.locality} ${placemarks.reversed.last.administrativeArea} ${placemarks.reversed.last.name} ${placemarks.reversed.last.isoCountryCode} ${placemarks.reversed.last.postalCode} ";
    final location = "${placemarks.reversed.last.administrativeArea}";
    this.selectedAddress = addresses;
    this.selectedLocation = location;
    notifyListeners();
    print("$selectedAddress");
  }

  Future<void> savePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', this.latitude);
    prefs.setDouble('longitude', this.longitude);
    prefs.setString('address', this.selectedAddress);
    prefs.setString('location', this.selectedLocation);
  }
}
