import 'package:amfk/loader.dart';
import 'package:amfk/otp_login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'about.dart';
import 'model_issue.dart';
import 'login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'sector_officer_request_history.dart';
import 'package:connectivity/connectivity.dart';

class DashboardSectorOfficer extends StatefulWidget {
  var dataFromServer;
  DashboardSectorOfficer({Key key, @required this.dataFromServer}) : super(key: key);
  @override
  _DashboardSectorOfficerState createState() => _DashboardSectorOfficerState(dataFromServer);
}

class _DashboardSectorOfficerState extends State<DashboardSectorOfficer> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var dataFromServer;
  _DashboardSectorOfficerState(this.dataFromServer);

  List<ModelIssue> modelIssue = new List<ModelIssue>();

  Choice _selectedChoice = choices[0]; // The app's "state".

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(()  {
      _selectedChoice = choice;
      if(_selectedChoice.title == "Request history"){
        check().then((internet) {
          if (internet != null && internet) {
            // Internet Present Case
            Navigator.of(context)
                .push(
                MaterialPageRoute(builder: (context) => new SectorOfficerRequestHistory()
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
  await getSharedPrefrence();
}
getSharedPrefrence() async{
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

   // print("DATA_FROM_SERVER : "+dataFromServer[0]["0"].toString());
    //print("LENGTH : "+dataFromServer[0]["0"].length.toString());

    if(dataFromServer[0]["success"]==200){
      showToast("Invalid Credentials...");
      logoff();
    }else{
      for(int i = 0; i < dataFromServer[0]["0"].length; i++){
        modelIssue.add(new ModelIssue(dataFromServer[0]["0"][i]["rid"], dataFromServer[0]["0"][i]["phone"], "S_140",dataFromServer[0]["0"][i]["booth_name"],dataFromServer[0]["0"][i]["rname"],
            dataFromServer[0]["0"][i]["time"], dataFromServer[0]["0"][i]["description"],
            "pending", true));
      }
    }
    super.initState();
  }
  void loaderload(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new Loader()));

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
          title:  Text('Requests : SO', textAlign: TextAlign.center),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Text(modelIssue[Index].boothName, style: TextStyle( color: Color(0xff34A2AA),fontWeight: FontWeight.bold, fontSize: 16),),
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
                                    Padding(
                                      padding: EdgeInsets.only(left: 30),
                                    ),
                                    Container(
                                        child: Expanded(
                                            child: Text(modelIssue[Index].issueDescription)
                                        )
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        child: Icon(Icons.call, color: Color(0xff34A2AA),),
                                      ),
                                      onTap: () => launch("tel://"+modelIssue[Index].phoneNumber),
                                    ),
                                  ],
                                ),
                              ],
                            )
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