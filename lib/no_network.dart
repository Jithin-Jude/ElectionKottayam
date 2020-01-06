import 'package:flutter/material.dart';

class NoNetwork extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NoNetworkState();
  }
}

class _NoNetworkState extends State<NoNetwork> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.signal_cellular_connected_no_internet_4_bar, size: 80, color: Color(0xff34A2AA),),
              Padding(
                padding: EdgeInsets.all(30),
                child: Text("No network connection. Check your internet connection and try again!",
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey),)
              ),
            ],
          ),
      ),
    );
  }
}