import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:life_jyoti/Screens/landing_screen.dart';
import 'package:life_jyoti/Screens/main_screen.dart';
import 'package:life_jyoti/misc/location_provider.dart';
import 'package:life_jyoti/misc/user_services.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late String smsOtp;
  late String verificationId;
  String error = '';
  UserServices _userServices = UserServices();
  bool loading = false;
  LocationProvider locationData = LocationProvider();
  String? screen;
  double? latitude;
  double? longitude;
  String? address;
  String? location;
  String? firstName;
  String? lastName;
  String? email;
  late DocumentSnapshot snapshot;

  Future<void> verifyPhone({
    required BuildContext context,
    required String number,
  }) async {
    this.loading = true;
    notifyListeners();
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      this.loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      this.loading = false;
      print(e.code);
      this.error = e.toString();
      notifyListeners();
    };

    final PhoneCodeSent smsOtpSend = (String veriId, int? resendToken) async {
      this.verificationId = veriId;
      //open dialog to enter recived OTP SMS
      smsOtpDialog(context, number);
    };
    try {
      _auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: smsOtpSend,
          codeAutoRetrievalTimeout: (String veriId) {
            this.verificationId = veriId;
          });
    } catch (e) {
      this.error = e.toString();
      this.loading = false;
      notifyListeners();
      print(e);
    }
  }

  Future smsOtpDialog(BuildContext context, String number) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text('Verification Code'),
              SizedBox(
                height: 8,
              ),
              Text(
                'Enter 6-digit OTP recived as SMS',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          content: Container(
            height: 85,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 6,
              onChanged: (value) {
                this.smsOtp = value;
              },
            ),
          ),
          actions: [
            TextButton(
                child: Text('Done'),
                onPressed: () async {
                  try {
                    PhoneAuthCredential phoneAuthCredential =
                        PhoneAuthProvider.credential(
                      verificationId: verificationId.toString(),
                      smsCode: smsOtp.toString(),
                    );
                    final User? user =
                        (await _auth.signInWithCredential(phoneAuthCredential))
                            .user;

                    if (user != null) {
                      this.loading = false;
                      notifyListeners();
                      _userServices.getuserById(user.uid).then((snapShot) {
                        if (snapShot.exists) {
                          //user data already exists
                          if (this.screen == 'Login') {
                            //need to check user data already exitsts in db or not.
                            //if its 'login', no new data , so no need to update .
                            if (snapShot['address'] != null) {
                              Navigator.pushReplacementNamed(
                                  context, MainScreen.id);
                            }
                            Navigator.pushReplacementNamed(
                                context, LandingScreen.id);
                          } else {
                            //need to update new selected address
                            print(
                                '${locationData.latitude}:${locationData.longitude}');
                            updateUser(
                              id: user.uid,
                              number: user.phoneNumber.toString(),
                            );
                            Navigator.pushReplacementNamed(
                                context, MainScreen.id);
                          }
                        } else {
                          //user data does not exists
                          //will create new data in db
                          _createUser(
                              id: user.uid,
                              number: user.phoneNumber.toString());
                          Navigator.pushReplacementNamed(
                              context, LandingScreen.id);
                        }
                      });
                    } else {
                      print('Login Failed');
                    }
                  } catch (e) {
                    this.error = 'Invalid OTP';
                    Navigator.of(context).pop();
                  }
                }),
          ],
        );
      },
    ).whenComplete(() {
      this.loading = false;
      notifyListeners();
    });
  }

  void _createUser({
    String? id,
    String? number,
  }) {
    _userServices.createUser({
      'id': id,
      'firstName': null,
      'lastName': lastName,
      'number': number,
      'email': email,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'address': this.address,
      'location': this.location,
    });
    this.loading = false;
    notifyListeners();
  }

  Future<bool> updateUser({
    String? id,
    String? number,
  }) async {
    try {
      _userServices.updateUserData({
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'number': number,
        'email': email,
        'latitude': this.latitude,
        'longitude': this.longitude,
        'address': this.address,
        'location': this.location,
      });
      this.loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error $e');
      return false;
    }
  }

  getUserDetails() async {
    DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get();
    this.snapshot = result;
    notifyListeners();

    return result;
  }
}
