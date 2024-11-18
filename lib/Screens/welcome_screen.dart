import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:life_jyoti/Screens/map_screen.dart';
import 'package:life_jyoti/Screens/onboard_screen.dart';
import 'package:life_jyoti/misc/auth_provider.dart';
import 'package:life_jyoti/misc/location_provider.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome-screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    bool _validPhoneNumber = false;
    var _phoneNumberController = TextEditingController();
    void showButtomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, StateSetter myState) {
            return Container(
              height: 100000,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOGIN',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Enter Your Phone Number To Procced',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          prefixText: '+91',
                          labelText: '10 digit Mobile Number',
                        ),
                        autofocus: true,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        controller: _phoneNumberController,
                        onChanged: (value) {
                          if (value.length == 10) {
                            myState(() {
                              _validPhoneNumber = true;
                            });
                          } else {
                            myState(() {
                              _validPhoneNumber = false;
                            });
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AbsorbPointer(
                              absorbing: _validPhoneNumber ? false : true,
                              // ignore: deprecated_member_use
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _validPhoneNumber
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey,
                                ),
                                child: auth.loading
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : Text(
                                        _validPhoneNumber
                                            ? 'CONTINUE'
                                            : 'ENTER PHONE NUMBER',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                onPressed: () {
                                  myState(() {
                                    auth.loading = true;
                                  });
                                  String number =
                                      '+91${_phoneNumberController.text}';
                                  auth
                                      .verifyPhone(
                                    context: context,
                                    number: number,
                                  )
                                      .then((value) {
                                    _phoneNumberController.clear();
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ).whenComplete(() {
        setState(() {
          auth.loading = false;
          _phoneNumberController.clear();
        });
      });
    }

    final locationData = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Positioned(
                right: 0.0,
                top: 10,
                child: SizedBox(
                  height: 5,
                  child: TextButton(
                    child: Text(
                      'SKIP',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              Column(
                children: [
                  Expanded(child: OnBoardScreen()),
                  Text('Ready to order from your nearest shop ?'),
                  SizedBox(
                    height: 30,
                  ),
                  // ignore: deprecated_member_use
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: locationData.loading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            'SET DELIVERY LOCATION',
                            style: TextStyle(color: Colors.white),
                          ),
                    onPressed: () async {
                      setState(() {
                        locationData.loading = true;
                      });

                      await locationData.getCurrentPosition();
                      if (locationData.permissionAllowed == true) {
                        Navigator.pushReplacementNamed(context, MapScreen.id);
                        setState(() {
                          locationData.loading = false;
                        });
                      } else {
                        print('Permission Not Allowed');
                        setState(() {
                          locationData.loading = false;
                        });
                      }
                    },
                  ),

                  TextButton(
                    child: RichText(
                      text: TextSpan(
                        text: 'Already a customer ?',
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        auth.screen = 'Login';
                      });
                      showButtomSheet(context);
                    },
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
