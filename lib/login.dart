import 'package:amfk/loader.dart';
import 'package:amfk/otp_register.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'raised_gradient_button.dart';
import 'dashboard_booth_manager.dart';
import 'dashboard_sector_officer.dart';
import 'dashboard_aro.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'package:connectivity/connectivity.dart';
import 'otp_login.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController userNameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  String text;

  void displaySnackBar(String message){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 3),
        ));
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  void validateLogin(){
    String uname = userNameController.text.toString();
    String pword = passwordController.text.toString();
    if(uname.isEmpty || pword.isEmpty){
      displaySnackBar("Please enter username and password");
    }else{
      _loginapi();
    }
  }

  Future<Null> _loginapi() async {
    var data = {"username":userNameController.text , "password":passwordController.text};
    var url = Constants.URL_LOGIN;
   // print((data));
    var response = await request(url, json.encode(data));
    //print(response);
  }

  Future<Map> request(var url, var data) async {
    http.Response response=await http.post(url,headers:{ "Content-Type":"application/x-www-form-urlencoded" } ,
        body: { "username":userNameController.text , "password":passwordController.text},
        encoding: Encoding.getByName("utf-8"));
    List res=response.body.split("\n");
    print("yoo"+res[0]);
    if(res[0].toString().compareTo("<!DOCTYPE html>")==1) {
      var dat;
      print(response.body);

      dat = jsonDecode(response.body);
   // print("USER TYPE : "+dat[0]["uid"]);

    if(dat[0]["success"]==100){

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
      displaySnackBar("Invalid credentials");
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
   if(prefs.getBool("login")?? false){
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new Loader()));

   }
    }
  void showAlertDialog( ){
    String title="Forgot Password?";
    String message="Contact Election Kottayam Customer Care";
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
              Icon(Icons.call, size: 50, color: Color(0xff34A2AA),),
              Padding(padding: EdgeInsets.all(5),),
              Text(message, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),),
            ],
          ),
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Call Now"),
            onPressed: () {
              launch("tel://+919516666000");
            },
          ),
        ],
      );
    },
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: ListView(
            children: <Widget>[
              Container(
                height: 270,
                width: 270,
                child: Image.asset('assets/images/new_logo_new.png', height: 270, width: 270,),
              ),
              /*Padding(
                padding: const EdgeInsets.only(top:15.0),
                child: Container(
                  child: Center(
                    child: Text("ELECTION KOTTAYAM - 2019",
                        style: TextStyle(color: Color(0xff37C1D3), fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                  ),
                ),
              ),*/
              Container(
                margin: EdgeInsets.only(top: 10, left: 50, right: 50),
                child: TextField(
                  controller: userNameController,
                  style: new TextStyle(
                      fontSize: 20.0,
                      height: 1.0,
                      color: Colors.black
                  ),
                  decoration: new InputDecoration(
                    hintText: 'User name',
                    hintStyle: TextStyle(fontSize: 14),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey,
                          width: 0.5, style: BorderStyle.solid ),
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: Icon(
                        Icons.confirmation_number,
                        color: Color(0xff37C1D3),
                      ), // icon is 48px widget.
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, left: 50, right: 50),
                child: new Column(
                  children: <Widget>[
                    TextFormField(
                      obscureText: _obscureText,
                      controller: passwordController,
                      style: new TextStyle(
                          fontSize: 20.0,
                          height: 1.0,
                          color: Colors.black
                      ),
                      decoration: const InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(fontSize: 14),
                          border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey,
                              width: 0.5, style: BorderStyle.solid ),
                          ),
                          prefixIcon: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Icon(
                            Icons.lock_outline,
                            color: Color(0xff37C1D3),
                          ), // icon is 48px widget.
                        ),
                      ),
                    ),
                    FlatButton(
                        onPressed: _toggle,
                        child: new Text(_obscureText ? "Show" : "Hide"))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, left: 50, right: 50),
                child: RaisedGradientButton(
                    child: Text('LOGIN',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),

                    gradient: LinearGradient(
                      colors: <Color>[Color(0xff0BBFD6), Color(0xff5ACCC1)],
                    ),
                    height: 50,
                    borderRadius: 5.0,
                    onPressed: (){
                      check().then((internet) {
                        if (internet != null && internet) {
                          // Internet Present Case
                          validateLogin();
                        }else{
                          // No-Internet Case
                          displaySnackBar("No network connection");
                        }
                      });

                    }
                ),
              ),Container(
                margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                            onPressed: (){showAlertDialog();},
                            child: new Text("Need help?")
                        ),
                        FlatButton(
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OtpLogin()),
                              );
                            },
                            child: new Text("Login via OTP")
                        ),
                      ],
                    )
                  ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20, left: 50, right: 50),
                  child: SizedBox(
                    child: new Center(
                      child: new Container(
                        margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                        height: 1.5,
                        decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                              colors: [Color(0xff0BBFD6), Color(0xff5ACCC1)],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(0.5, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp
                          ),
                        ),
                      ),
                    ),
                  )
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: Center(
                  child: Text("Developed by Amal Jyothi College of Engineering",
                      style: TextStyle(color: Colors.black, fontSize: 12)
                  ),
                ),
              )
            ],
          ),
        ),),
    );
  }

}
