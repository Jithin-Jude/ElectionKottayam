import 'dart:convert';

import 'package:amfk/constants.dart';
import 'package:amfk/loader.dart';
import 'package:amfk/otp_login.dart';
import 'package:amfk/raised_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about.dart';
import 'model_issue_booth.dart';
import 'login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'aro_request_history.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

class DashboardAro extends StatefulWidget {
  var dataFromServer;
  DashboardAro({Key key, @required this.dataFromServer}) : super(key: key);
  @override
  _DashboardAroState createState() => _DashboardAroState(dataFromServer);
}
var savedUid;
var savedToken;

class _DashboardAroState extends State<DashboardAro> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var dataFromServer;
  _DashboardAroState(this.dataFromServer);

  List<ModelIssue> modelIssue = new List<ModelIssue>();

  Choice _selectedChoice = choices[0]; // The app's "state".

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() async {
      _selectedChoice = choice;
      if(_selectedChoice.title == "Request history"){
        check().then((internet) {
          if (internet != null && internet) {
            // Internet Present Case
            Navigator.of(context)
                .push(
                MaterialPageRoute(builder: (context) => new AroRequestHistory()
                )
            );
          }else{
            // No-Internet Case
            displaySnackBar("Not network connection");
          }
        });
      }else if(_selectedChoice.title == "About"){
        Navigator.of(context)
            .push(
            MaterialPageRoute(builder: (context) => new About()
            )
        );
      }else if(_selectedChoice.title == "Logout"){
       logoff();
      }
    });
  }
  void logoff() async{
    await getLSharedPrefrence();
  }
  getLSharedPrefrence() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new OtpLogin()
    )
    );
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        fontSize: 18,
        textColor:Colors.white,
        backgroundColor: Color(0xff34A2AA));
  }

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

  @override
  void initState() {

    super.initState();
    getSavedData();
    //print("DATA_FROM_SERVER : "+dataFromServer[0]["0"].toString());
   // print("LENGTH : "+dataFromServer[0]["0"].length.toString());

    if(dataFromServer[0]["success"]==200){
      showToast("Invalid Credentials...");
      logout();
          }else{
      for(int i = 0; i < dataFromServer[0]["0"].length; i++){
        modelIssue.add(new ModelIssue(dataFromServer[0]["0"][i]["rid"], dataFromServer[0]["0"][i]["phone"], dataFromServer[0]["0"][i]["sname"],dataFromServer[0]["0"][i]["booth_name"],dataFromServer[0]["0"][i]["rname"],
            dataFromServer[0]["0"][i]["time"], dataFromServer[0]["0"][i]["description"],
            "pending",dataFromServer[0]["0"][i]["bphone"], true));
      }
    }
  }
  void logout() async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new OtpLogin()
    )
    );

  }
  void getSavedData() async{
    await getSharedPrefrence();
  }
  getSharedPrefrence() async{
    final prefs = await SharedPreferences.getInstance();
    savedUid = prefs.getString('saved_uid') ?? '';
    savedToken = prefs.getString('saved_token') ?? '';
  }
  void loaderload(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new Loader()));

  }
  void showAlertDialogResolved(String title, String message,String rid,int index){
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
          FlatButton(
            child: new Text("Yes"),
            onPressed: () {
              Navigator.of(context).pop();

              _resolveapi(rid,index,1);

            },
          ),
          FlatButton(
            child: new Text("No"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
    );
  }
  Future<Null> _resolveapi(String rid,index,int type) async {
    var data = {"uid":savedUid , "token":savedToken, "rid":rid};
    var url;
    if(type==1)
      url = Constants.URL_RESOLVE;
    else
      url = Constants.URL_CANCEL;
    //print(("DATA TO SERVER="+data.toString()));
    var response = await request(url, json.encode(data),rid,index);
    //print(response);
  }

  Future<Map> request(var url, var data,var rid,var index) async {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    http.Response response=await http.post(url,headers:{ "Content-Type":"application/x-www-form-urlencoded" } ,
        body: { "uid":savedUid , "token":savedToken, "rid":rid},
        encoding: Encoding.getByName("utf-8"));
    List res=response.body.split("\n");
    //print("yoo"+res[0]);
    if(res[0].toString().compareTo("<!DOCTYPE html>")==1) {
      var dat;
      //print("RESPONSE FROM SERVER-->"+response.body.toString());

      dat = jsonDecode(response.body);
    //  print("USER TYPE : "+dat[0]["user_type"]);

      if(dat[0]["success"]==100) {
       // print("SSUCCESSSSSSSSSS");
        setState(() {
          modelIssue.removeAt(index);
        });
      }
      else{

        Fluttertoast.showToast(
            msg: "Invalid Credentials...",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            textColor:Colors.black,
            backgroundColor: Color(0xFF3E4D)
        );


      }


    }
  }
  @override
  Widget build(BuildContext context) {

    bool visibilityTag;
    if(modelIssue.length == 0){
      visibilityTag = false;
    }else{
      visibilityTag = true;
    }

    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title:  Text('Requests : ARO', textAlign: TextAlign.center),
          leading: new IconButton(
            icon: new Icon(Icons.refresh),
            onPressed: (){
              check().then((internet) {
                if (internet != null && internet) {
                  // Internet Present Case
                  loaderload();
                }else{
                  // No-Internet Case
                  displaySnackBar("Not network connection");
                }
              });
            },
          ),
          backgroundColor: Color(0xff34A2AA),
          actions: <Widget>[
            PopupMenuButton<Choice>(
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.skip(0).map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10,bottom: 20),
              color: Color(0xff34A2AA),
              child : Row(
                children: <Widget>[
                  Expanded(
                    child: Text("Item", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18),),
                  ),
                  Expanded(
                    child: Text("Description", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18),),
                  ),
                  Expanded(
                    child: Text("Call", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18),),
                  ),
                ],
              ),
            ),
            visibilityTag ? Expanded(
                child: new ListView.builder(
                    itemCount: modelIssue.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      //return Text(requests[Index]);
                      return Card(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Text(modelIssue[Index].sectorName.toString()+" : "+modelIssue[Index].boothName.toString(), style: TextStyle( color: Color(0xff34A2AA),fontWeight: FontWeight.bold, fontSize: 16),),
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Text(modelIssue[Index].issueName, style: TextStyle(fontWeight: FontWeight.bold),),
                                            Text(modelIssue[Index].issueReportTime.toString().replaceAll("+0530", "")),
                                          ],
                                        ),
                                    ),
                                    Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(modelIssue[Index].issueDescription, textAlign: TextAlign.left,),
                                        )
                                    ),

                                  ],
                                ), Container(
                                    margin: EdgeInsets.only(top: 18),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        RaisedGradientButton(
                                          child: Text('Call Booth Officer',
                                            style: TextStyle(color: Colors.white),
                                          ),

                                          gradient: LinearGradient(
                                            colors: <Color>[Color(0xff0BBFD6), Color(0xff5ACCC1)],
                                          ),
                                          width: 150,
                                          height: 40,
                                          borderRadius: 20,
                                          onPressed: () => launch("tel://"+modelIssue[Index].boothPhone),
                                        ),
                                        Padding(padding: EdgeInsets.only(left: 5)),
                                        RaisedGradientButton(
                                          child: Text('Call Sector Officer',
                                            style: TextStyle(color: Colors.white),
                                          ),

                                          gradient: LinearGradient(
                                            colors: <Color>[Color(0xff0BBFD6), Color(0xff5ACCC1)],
                                          ),
                                          width: 150,
                                          height: 40,
                                          borderRadius: 20,
                                          onPressed: () => launch("tel://"+modelIssue[Index].phoneNumber),
                                        ),
                                      ],
                                    )
                                ),Padding(
                                  padding: const EdgeInsets.only(top:9.0),
                                  child: RaisedGradientButton
                                    (
                                      child: Text("Resolved", style: TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center,),
                                      gradient: LinearGradient(
                                        colors: <Color>[Colors.green, Colors.green],
                                      ),
                                      width: 300,
                                      height: 40,
                                      borderRadius: 20,
                                      onPressed: (){
                                        showAlertDialogResolved("Resolved", "Are you sure your grievance is Resolved ?",modelIssue[Index].rId,Index);
                                      },
                                      ),
                                )
                              ],
                            ),
                          )
                      );
                    }
                )
            ) : Expanded(
                child: Center(
                  child: Text("No requests available"),
                )
            ),
          ],
        )
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Request history', icon: Icons.directions_car),
  const Choice(title: 'About', icon: Icons.directions_bike),
  const Choice(title: 'Logout', icon: Icons.power_settings_new),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128.0, color: textStyle.color),
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}