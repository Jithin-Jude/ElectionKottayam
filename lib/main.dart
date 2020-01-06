import 'package:amfk/otp_login.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'no_network.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

void main()  async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  // Set default home.

  // Get result of the login function.
  check().then((internet) {
    if (internet != null && internet) {
      // Internet Present Case
      runApp(new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: OtpLogin(),
      ));
    }else{
      // No-Internet Case
      runApp(new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: NoNetwork(),
      ));
    }
  });
}
