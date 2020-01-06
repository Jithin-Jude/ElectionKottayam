import 'package:amfk/login.dart';
import 'package:amfk/otp_login.dart';
import 'package:flutter/material.dart';
import 'raised_gradient_button.dart';
import 'dashboard_booth_manager.dart';
import 'dashboard_sector_officer.dart';
import 'dashboard_aro.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

var savedUid;
var savedToken;
class Loader extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoaderState();
  }
}

class _LoaderState extends State<Loader> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController userNameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  String text;


  Future<Null> _loginapi() async {
    var data = {"uid":savedUid , "token":savedToken};
    var url = Constants.URL_REFRESH;
   // print((data));
    var response = await request(url, json.encode(data));
    //print(response);
  }

  Future<Map> request(var url, var data) async {
    http.Response response=await http.post(url,headers:{ "Content-Type":"application/x-www-form-urlencoded" } ,
        body: { "uid":savedUid , "token":savedToken},
        encoding: Encoding.getByName("utf-8"));
    List res=response.body.split("\n");
    //print("yoo"+res[0]);
    if(res[0].toString().compareTo("<!DOCTYPE html>")==1) {
      var dat;
     // print(response.body);

      dat = jsonDecode(response.body);
    //print("USER TYPE : "+dat[0].toString());

      if(dat[0]["success"]==100){


       // print("UID"+savedUid);
        //print("UID"+savedToken);


        if(dat[0]["user_type"] == "0"){
          //print("BM");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new DashboardBoothManager(dataFromServer : dat)));
        }
        else if(dat[0]["user_type"] == "1"){
          //print("SO");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new DashboardSectorOfficer(dataFromServer : dat)));
        }
        else if(dat[0]["user_type"] == "2"){
         // print("ARO");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new DashboardAro(dataFromServer : dat)));
        }
      }
      else{
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Invalid credentials'),
          duration: Duration(seconds: 3),
        ));
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new OtpLogin()
        )
        );
      }


    }
  }

  @override
  void initState() {
    super.initState();

    getSavedData();

  }
  void getSavedData() async{
    await getSharedPrefrence();
  }
  getSharedPrefrence() async{
    final prefs = await SharedPreferences.getInstance();
    savedUid = prefs.getString('saved_uid') ?? '';
    savedToken = prefs.getString('saved_token') ?? '';
    //print("CHECK---------"+savedUid.toString()+"---------"+savedToken.toString());
    _loginapi();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      body: Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: EdgeInsets.all(15.0),
            child: SpinKitPouringHourglass(
              color: Color(0xff37C1D3),
              size: 100.0,
            )
        ),
      ),);
  }
}