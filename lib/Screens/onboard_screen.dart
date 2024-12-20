import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:life_jyoti/misc/constants.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

final _controller = PageController(
  initialPage: 0,
);

int _currentPage = 0;

List<Widget> _pages = [
  Column(
    children: [
      Expanded(
        child: Image.asset('assets/Images/enteraddress.png'),
      ),
      Text('Set Your Delivery Location',
          style: kPageViewTextStyle, textAlign: TextAlign.center),
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('assets/Images/deliverfood.png')),
      Text('Quick Deliver to your Doorstep',
          style: kPageViewTextStyle, textAlign: TextAlign.center),
    ],
  ),
  Column(
    children: [
      Expanded(
        child: Image.asset('assets/Images/orderfood.png'),
      ),
      Text('Order online from Your Favourite Store',
          style: kPageViewTextStyle, textAlign: TextAlign.center),
    ],
  ),
];

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: _pages,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          DotsIndicator(
            dotsCount: _pages.length,
            position: _currentPage,
            decorator: DotsDecorator(
                size: const Size.square(9.0),
                activeSize: const Size(18.0, 9.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                activeColor: Theme.of(context).primaryColor),
          )
        ],
      ),
    );
  }
}
