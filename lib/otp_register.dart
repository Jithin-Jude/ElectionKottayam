import 'dart:convert';

import 'package:amfk/constants.dart';
import 'package:amfk/dashboard_aro.dart';
import 'package:amfk/dashboard_booth_manager.dart';
import 'package:amfk/dashboard_sector_officer.dart';
import 'package:amfk/loader.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'raised_gradient_button.dart';

class OtpRegister extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OtpLoginState();
  }
}

class _OtpLoginState extends State<OtpRegister> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController phoneNumberForOtp = TextEditingController(text: '');
  TextEditingController otpText = TextEditingController(text: '');

  bool visibilityTag = true;
  var dat;
  var otp;

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  void displaySnackBar(String message){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 3),
        ));
  }

  void sentOtp(){
    _loginapi();
  }
  Future<Null> _loginapi() async {
    var data = {"phone":phoneNumberForOtp.text };
    var url = Constants.URL_IOS;
    // print((data));
    var response = await request(url, json.encode(data));
    //print(response);
  }

  Future<Map> request(var url, var data) async {
    http.Response response=await http.post(url,headers:{ "Content-Type":"application/x-www-form-urlencoded" } ,
        body: {"phone":phoneNumberForOtp.text },
        encoding: Encoding.getByName("utf-8"));
    List res=response.body.split("\n");
    print("yoo"+res[0]);
    if(res[0].toString().compareTo("<!DOCTYPE html>")==1) {

      print(response.body);

      dat = jsonDecode(response.body);
      // print("USER TYPE : "+dat[0]["uid"]);

      if(dat[0]["success"]==100){
        setState(() {
          displaySnackBar("Success..Please Wait until We Contact You..");

        });

        }
        else{
          displaySnackBar("Invalid Login..Contact 9516666000..");
      }
      }
      else{
        displaySnackBar("Invalid Credentials");
      }


    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Login via OTP"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xff34A2AA),
      ),
      body: Container(
        child: Center(child:Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              visibilityTag ? Padding(
                padding: const EdgeInsets.only(top:100.0),
                child: Column(children:<Widget>[Text(
                  "Enter your phone number for OTP verification",
                  style: TextStyle(color: Colors.black)
                  , textAlign: TextAlign.center,),Padding(
                    padding: const EdgeInsets.only(top:10.0),
                    child: Text(
                    "Format: 9516666000, without country code",
                    style: TextStyle(color: Colors.grey,fontSize: 12.0)
                    , textAlign: TextAlign.center,),
                  )],),
              ) : Padding(
                padding: const EdgeInsets.only(top:100.0),
                child: Text(
                  "Enter OTP for verification",
                  style: TextStyle(color: Colors.grey)
                  , textAlign: TextAlign.center,),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 30)
              ),
              visibilityTag ? Container(
                width: 250,
                child: TextFormField(
                  controller: phoneNumberForOtp,
                  decoration: new InputDecoration(
                    labelText: "Phone number",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide: new BorderSide(
                      ),
                    ),
                    //fillColor: Colors.green
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 13,
                  textAlign: TextAlign.center,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [BlacklistingTextInputFormatter(RegExp("[ ,;.N/#*)(-]")),],
                ),
              ) : Container(
                width: 150,
                child: TextFormField(
                  controller: otpText,
                  decoration: new InputDecoration(
                    labelText: "Enter OTP",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide: new BorderSide(
                      ),
                    ),
                    //fillColor: Colors.green
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [BlacklistingTextInputFormatter(RegExp("[ ,;.N/#*)(-]")),],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 30)
              ),
              visibilityTag ? RaisedGradientButton(
                child: Text('Sent OTP',
                  style: TextStyle(color: Colors.white),
                ),

                gradient: LinearGradient(
                  colors: <Color>[Color(0xff0BBFD6), Color(0xff5ACCC1)],
                ),
                width: 150,
                height: 40,
                borderRadius: 20,
                onPressed: (){
                  check().then((internet) {
                    if (internet != null && internet) {
                      // Internet Present Case
                      sentOtp();
                    }else{
                      // No-Internet Case
                      displaySnackBar("No network connection");
                    }
                  });
                },
              ) : RaisedGradientButton(
                child: Text('verify OTP',
                  style: TextStyle(color: Colors.white),
                ),

                gradient: LinearGradient(
                  colors: <Color>[Color(0xff0BBFD6), Color(0xff5ACCC1)],
                ),
                width: 150,
                height: 40,
                borderRadius: 20,
                onPressed: (){
                  check().then((internet) {
                    if (internet != null && internet) {
                      // Internet Present Case
                      verifyOtp();
                    }else{
                      // No-Internet Case
                      displaySnackBar("No network connection");
                    }
                  });
                },
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Future verifyOtp() async {
    if(otpText.text==otp) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('saved_uid', dat[0]["uid"]);
      prefs.setString('saved_token', dat[0]["token"]);
      prefs.setBool('login', true);

      final savedUid = prefs.getString('saved_uid') ?? '';
      final savedToken = prefs.getString('saved_token') ?? '';
      // print("UID"+savedUid);
      //
      //
      // print("UID"+savedToken);



        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new Loader()));

    }
    else{
      displaySnackBar("Wrong OTP...");
    }
  }
}