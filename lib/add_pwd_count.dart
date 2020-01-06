import 'dart:convert';

import 'package:amfk/constants.dart';
import 'package:amfk/login.dart';
import 'package:amfk/otp_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'raised_gradient_button.dart';
import 'package:amfk/loader.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';


class AddPwdCount extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddPwdCountState();
  }
}

class _AddPwdCountState extends State<AddPwdCount> {
  String savedUid;
  String savedToken;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController pwdCount = new TextEditingController();

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  void showAlertDialog(String title, String message){
    // flutter defined function
    showDialog(context: context, builder: (BuildContext context) {


      // return object of type Dialog
      return AlertDialog(
        content: Container(
          height: 150,
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.check_circle_outline, size: 50, color: Color(0xff34A2AA),),
              Padding(padding: EdgeInsets.all(5),),
              Text(message, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),),
            ],
          ),
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new Loader()));
            },
          ),
        ],
      );
    },
    );
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
  }

  void validatePwdCount(){
    String pwdCountValue = pwdCount.text.toString();
    if(pwdCountValue.isEmpty){
      displaySnackBar("Please enter PwD count");
    }else{
      _loginapi();
    }
  }
  Future<Null> _loginapi() async {
    var data = {"pwd_count":pwdCount.text , "uid":savedUid , "token":savedToken};
    var url = Constants.URL_PWD;
   //
    //
    // print((data));
    var response = await request(url, json.encode(data));
    //print(response);
  }

  Future<Map> request(var url, var data) async {
    http.Response response=await http.post(url,headers:{ "Content-Type":"application/x-www-form-urlencoded" } ,
        body: {"pwd_count":pwdCount.text , "uid":savedUid , "token":savedToken},
        encoding: Encoding.getByName("utf-8"));
    List res=response.body.split("\n");
    //print("yoo"+res[0]);
    if(res[0].toString().compareTo("<!DOCTYPE html>")==1) {
      var dat;
      print(response.body);

      dat = jsonDecode(response.body);
      //print("USER TYPE : "+dat[0]["uid"]);

      if(dat[0]["success"]==100){

        showAlertDialog("Done", "PwD count submitted");

      }
      else{
        displaySnackBar("Invalid credentials");
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new OtpLogin()
        )
        );
      }


    }
  }
  void displaySnackBar(String message){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 3),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add PwD count"),
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
              Padding(
                padding: const EdgeInsets.only(top:100.0),
                child: Text(
                  "Submit PwD count only after the completion of election. Enter Total Count of PwD in the Box below, Enter 0 and Submit if the total number is Zero.",
                  style: TextStyle(color: Colors.grey)
                  , textAlign: TextAlign.center,),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 30)
              ),
              Container(
                width: 102,
                child: TextFormField(
                    controller: pwdCount,
                    decoration: new InputDecoration(
                    labelText: "PwD count",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide: new BorderSide(
                      ),
                    ),
                    //fillColor: Colors.green
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 3,
                  textAlign: TextAlign.center,
                  autofocus: true,
                    textInputAction: TextInputAction.done,
                  inputFormatters: [BlacklistingTextInputFormatter(RegExp("[ ,;.N/#*)(+-]")),],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 30)
              ),
              RaisedGradientButton(
                child: Text('Submit PwD count',
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
                    validatePwdCount();
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
}