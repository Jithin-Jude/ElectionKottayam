import 'dart:convert';

import 'package:amfk/constants.dart';
import 'package:amfk/dashboard_aro.dart';
import 'package:amfk/dashboard_booth_manager.dart';
import 'package:amfk/dashboard_sector_officer.dart';
import 'package:amfk/loader.dart';
import 'package:amfk/login.dart';
import 'package:amfk/otp_register.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'raised_gradient_button.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OtpLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OtpLoginState();
  }
}

class _OtpLoginState extends State<OtpLogin> {

  Timer _timer;
  int _start = 60;
  
  bool resendOtpBtn;

  bool loading;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController phoneNumberForOtp = TextEditingController(text: '');
  TextEditingController otpText = TextEditingController(text: '');

  bool visibilityTag = true;
  var dat;
  var otp;
  var phoneNUmber;

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
  @override
  void initState() {
    setState(() {
      resendOtpBtn = false;
      loading = false;
    });
    getOtp();
    getPhoneNumber();
    super.initState();
    getSavedData();

  }
  void getSavedData() async{
    await getSharedPrefrence();
  }
  getSharedPrefrence() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("login") ?? false) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => new Loader()));
    }
  }
  void showAlertDialog( ){
    String title = "Forgot Password?";
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

  bool isOtpGood(){
    String otp = otpText.text.toString();
    if(otp.isEmpty){
      return false;
    }else{
      return true;
    }
  }

  bool isPhoneNumberGood(){
    String phno = phoneNumberForOtp.text.toString();
    if(phno.isEmpty){
      return false;
    }else{
      return true;
    }
  }

  void sendOtp(){
    if(isPhoneNumberGood()){
      setPhoneNumber(phoneNumberForOtp.text.toString());
      _loginapi();
    }else{
      displaySnackBar("Please enter a phone number");
      setState(() {
        loading = false;
      });
    }
  }

  void reSendOtp()async {
    String phno = getPhoneNumber().toString();
    var data = {"phone":phno};
    var response = await requestResendOtp(Constants.URL_RESEND, json.encode(data));
  }
  Future<Null> _loginapi() async {
    var data = {"phone":phoneNumberForOtp.text };
    var url = Constants.URL_VERIFY;
    // print((data));
    var response = await request(url, json.encode(data));
    //print(response);
  }

  void saveLoginCredits() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('saved_uid', dat[0]["uid"]);
    prefs.setString('saved_token', dat[0]["token"]);
  }

  Future<Map> request(var url, var data) async {
    http.Response response=await http.post(url,headers:{ "Content-Type":"application/x-www-form-urlencoded" } ,
        body: {"phone":phoneNumberForOtp.text },
        encoding: Encoding.getByName("utf-8"));
    List res=response.body.split("\n");
    //print("yoo"+res[0]);
    if(res[0].toString().compareTo("<!DOCTYPE html>")==1) {

      //print(response.body);

      dat = jsonDecode(response.body);
      // print("USER TYPE : "+dat[0]["uid"]);

      if(dat[0]["success"]==100){
        startTimer();
        setState(() {
          loading = false;
          visibilityTag = false;
          otp=dat[0]["otp"];
          saveLoginCredits();
          setOtp(otp);
          setOtpStatusAsToEnter();
          displaySnackBar("Success..Please Check Registered Mobile Number for OTP..");
          /*startTimer();
          setState(() {
            resendOtpBtn = true;
          });*/
        });

        }
        else{
          displaySnackBar("Not Registered. Please provide registered mobile number for Login. Contact Support for more Help.");
          setState(() {
            loading = false;
          });
        }
      }
      else{
        displaySnackBar("Invalid Credentials");
        setState(() {
          loading = false;
        });
      }


    }

  Future<Map> requestResendOtp(var url, var data) async {
    http.Response response=await http.post(url,headers:{ "Content-Type":"application/x-www-form-urlencoded" } ,
        body: {"phone":phoneNUmber },
        encoding: Encoding.getByName("utf-8"));
    List res=response.body.split("\n");
    //print("yoo"+res[0]);
    if(res[0].toString().compareTo("<!DOCTYPE html>")==1) {
      //print("PHONE_NUMBER============================"+phoneNUmber);

      //print("RESPONSE====================================="+response.body);

      dat = jsonDecode(response.body);
      // print("USER TYPE : "+dat[0]["uid"]);

      if(dat[0]["success"]==100){
        setState(() {
          visibilityTag = false;
          _start = 60;
          resendOtpBtn = false;
          otp=dat[0]["otp"];
          setOtp(otp);
          setOtpStatusAsToEnter();
          displaySnackBar("Success..Please Check Registered Mobile Number for OTP..");
          /*startTimer();
          setState(() {
            resendOtpBtn = true;
          });*/
        });
        startTimer();

      }
      else{
        displaySnackBar("Not Registered. Please provide registered mobile number for Login. Contact Support for more Help.");
      }
    }
    else{
      displaySnackBar("Invalid Credentials");
    }


  }



  @override
  Widget build(BuildContext context) {
    getSharedVariables();

    return Scaffold(
      key: _scaffoldKey,

      body: loading ? SpinKitFadingCircle(
        color: Color(0xff37C1D3),
        size: 100.0,
      ) : Container(
    height: double.infinity,
    width: double.infinity,
    child: Center(
    child: ListView(
    children: <Widget>[
    Container(
    child: Image.asset('assets/images/new_logo_new.png', height: 270, width: 270,),
    ),
    Container(
        child: Center(
          child:Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              visibilityTag ? Padding(
                padding: const EdgeInsets.only(top:10.0),
                child: Column(children:<Widget>[Text(
                  "Enter your phone number for OTP verification",
                  style: TextStyle(color: Colors.black)
                  , textAlign: TextAlign.center,),Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: Text(
                    "Format: 95XXXXX000, without country code",
                    style: TextStyle(color: Colors.grey,fontSize: 12.0)
                    , textAlign: TextAlign.center,),
                ),Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: Text(
                    "Please use the number given to District Administration",
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
                  maxLength: 10,
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
                child: Text('Send OTP',
                  style: TextStyle(color: Colors.white),
                ),

                gradient: LinearGradient(
                  colors: <Color>[Color(0xff0BBFD6), Color(0xff5ACCC1)],
                ),
                width: 150,
                height: 40,
                borderRadius: 20,
                onPressed: (){
                  setState(() {
                    loading = true;
                  });
                  check().then((internet) {
                    if (internet != null && internet) {
                      // Internet PreSend Case
                      sendOtp();
                    }else{
                      // No-Internet Case
                      displaySnackBar("No network connection");
                      setState(() {
                        loading = false;
                      });
                    }
                  });
                },
              ) : RaisedGradientButton(
                child: Text('Verify OTP',
                  style: TextStyle(color: Colors.white),
                ),

                gradient: LinearGradient(
                  colors: <Color>[Color(0xff0BBFD6), Color(0xff5ACCC1)],
                ),
                width: 130,
                height: 40,
                borderRadius: 20,
                onPressed: (){
                  check().then((internet) {
                    if (internet != null && internet) {
                      // Internet PreSend Case
                      verifyOtp();
                    }else{
                      // No-Internet Case
                      displaySnackBar("No network connection");
                    }
                  });
                },
              ),
              Padding(
                  padding: EdgeInsets.only(top: 20)
              ),
              visibilityTag ? Container(): resendOtpBtn ? OutlineButton(
                child: Text("Click here\nto resend OTP", textAlign: TextAlign.center,),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                borderSide: BorderSide(color: Color(0xff5ACCC1)),
                onPressed: (){
                    reSendOtp();
                },
              ) : Text("You can rerequest OTP in "+"$_start"+" Seconds"),
            ],
          ),
        ),
        ),
      ),Container(
      margin: EdgeInsets.only(top: 5, left: 20, right: 20),
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
                          builder: (context) => Login()),
                    );
                  },
                  child: new Text("Alternate Login")
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
    ]
    )
    )
      )
    );
  }

  Future verifyOtp() async {
    //print("========BEFORE==========JITHIN OTP"+otp);
    getOtp();
    //print("========AFTER===========JITHIN OTP"+otp);
    if(isOtpGood()){
      if(otpText.text==otp) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('login', true);

        final savedUid = prefs.getString('saved_uid') ?? '';
        final savedToken = prefs.getString('saved_token') ?? '';
        // print("UID"+savedUid);
        //
        //
        // print("UID"+savedToken);

        setOtpStatusAsNotToEnter();

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new Loader()));

      }
      else{
        displaySnackBar("Wrong OTP...");
      }
    }else{
      displaySnackBar("Please enter OTP");
    }
  }
  //==========================OTP Shared Preferences============================

  setOtpStatusAsToEnter() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("otp_status", "to_enter");
  }

  setOtpStatusAsNotToEnter() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("otp_status", "not_to_enter");
  }

  getSharedVariables() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String OtpStatus = pref.getString('otp_status');
    if(OtpStatus =="to_enter"){
      setState(() {
        visibilityTag = false;
      });
    }else{
      setState(() {
        visibilityTag = true;
      });
    }
  }

  setOtp(String givenOtp) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("otp", givenOtp);
  }

  getOtp() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    otp = pref.getString('otp');
    //print("=====================JITHIN OTP"+otp);
  }

  setPhoneNumber(String givenPhno) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("phone", givenPhno);
  }

  getPhoneNumber() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    phoneNUmber = pref.getString('phone');
    print("NUMBER======================================="+phoneNUmber);
    if(phoneNUmber != ""){
        startTimer();
    }
    //print("PHONE_________"+phoneNUmber);
  }
  //=================================TIMER======================================
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        oneSec,
            (Timer timer) => setState(() {
          if (_start <= 1) {
            resendOtpBtn = true;
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        }));
  }
}