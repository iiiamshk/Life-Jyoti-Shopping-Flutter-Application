import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:life_jyoti/Screens/map_screen.dart';
import 'package:life_jyoti/Screens/profile_update_screen.dart';
import 'package:life_jyoti/Screens/welcome_screen.dart';
import 'package:life_jyoti/misc/auth_provider.dart';
import 'package:life_jyoti/misc/location_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  static const String id = 'profile-screen';

  String capitalize(String na) {
    return "${na[0].toUpperCase()}${na.substring(1)}";
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<AuthProvider>(context);
    var locationData = Provider.of<LocationProvider>(context);
    User? user = FirebaseAuth.instance.currentUser;
    userDetails.getUserDetails();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'LIFE : JYOTI',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'MY ACCOUNT',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  color: Colors.redAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                userDetails.snapshot['firstName'] != null
                                    ? capitalize(
                                        userDetails.snapshot['firstName'][0])
                                    : 'G',
                                style: TextStyle(
                                    fontSize: 50, color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 70,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    userDetails.snapshot['firstName'] != null
                                        ? '${userDetails.snapshot['firstName']} ${userDetails.snapshot['lastName']} '
                                        : 'Update Your Name',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                  if (userDetails.snapshot['email'] != null)
                                    Text(
                                      '${userDetails.snapshot['email']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.white),
                                    ),
                                  Text(
                                    user!.phoneNumber.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (userDetails.snapshot != null)
                          Container(
                            color: Colors.white,
                            child: ListTile(
                              tileColor: Colors.white,
                              leading: Icon(
                                Icons.location_on,
                                color: Colors.redAccent,
                              ),
                              title: Text(userDetails.snapshot['location']),
                              subtitle: Text(
                                userDetails.snapshot['location'],
                                maxLines: 1,
                              ),
                              trailing: SizedBox(
                                width: 80,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.redAccent),
                                  ),
                                  child: Text(
                                    'Change',
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                  onPressed: () {
                                    EasyLoading.show(status: 'Please Wait...');
                                    locationData
                                        .getCurrentPosition()
                                        .then((value) {
                                      if (value != null) {
                                        EasyLoading.dismiss();
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
                                        EasyLoading.dismiss();
                                        print('Permission not allowed');
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 3.0,
                  child: IconButton(
                    onPressed: () {
                      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                        context,
                        settings: RouteSettings(name: UpdateProfileScreen.id),
                        screen: UpdateProfileScreen(),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                    icon: Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            ListTile(
              leading: Icon(
                Icons.history,
              ),
              title: Text('My Orders'),
              horizontalTitleGap: 2,
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.comment_outlined,
              ),
              title: Text('My Rating & Reviews'),
              horizontalTitleGap: 2,
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.notifications_none_outlined,
              ),
              title: Text('Notifications'),
              horizontalTitleGap: 2,
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: ListTile(
                leading: Icon(
                  Icons.power_settings_new_outlined,
                ),
                title: Text('Log Out'),
                horizontalTitleGap: 2,
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: WelcomeScreen.id),
                    screen: WelcomeScreen(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
