import 'dart:convert';

import 'package:amfk/login.dart';
import 'package:amfk/otp_login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model_issue.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';

class SectorOfficerRequestHistory extends StatefulWidget {
  @override
  _SectorOfficerRequestHistoryState createState() => _SectorOfficerRequestHistoryState();
}
var savedUid;
var savedToken;

class _SectorOfficerRequestHistoryState extends State<SectorOfficerRequestHistory> {

  List<ModelIssue> modelIssue = new List<ModelIssue>();

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
    _loginapi();

  }
  Future<Null> _loginapi() async {
    var data = {"uid":savedUid , "token":savedToken};
    var url = Constants.URL_HISTORY;
    print((data));
    var response = await request(url, json.encode(data));
    print("jijijijisjisjisjisjisjisjisjisjsijsijisjsijisjisjisj"+response.toString());
  }

  Future<Map> request(var url, var data) async {
    http.Response response=await http.post(url,headers:{ "Content-Type":"application/x-www-form-urlencoded" } ,
        body: { "uid":savedUid , "token":savedToken},
        encoding: Encoding.getByName("utf-8"));
    List res=response.body.split("\n");
     print("yoo>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+res[0]);
    if(res[0].toString().compareTo("<!DOCTYPE html>")==1) {
      var dat;

      dat = jsonDecode(response.body);

      if(dat[0]["success"]==100){

        setState(() {
          for(int i = 0; i < dat[0]["0"].length; i++){
            modelIssue.add(new ModelIssue("0", dat[0]["0"][i]["phone"], dat[0]["0"][i]["sname"],dat[0]["0"][i]["booth_name"],dat[0]["0"][i]["rname"],
                dat[0]["0"][i]["time"], dat[0]["0"][i]["description"],
                dat[0]["0"][i]["resolved_by"], true));
          }
          print("USER LENGTH : "+modelIssue.length.toString());
        });
        }
      else{showToast("Invalid Credentials...");
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new OtpLogin()
      )
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
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title:  Text('Resolved requests', textAlign: TextAlign.center),
          backgroundColor: Color(0xff34A2AA),
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
                    child: Text("Status", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18),),
                  ),
                ],
              ),
            ),
            visibilityTag ? Expanded(
                child: new ListView.builder(
                    itemCount: modelIssue.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      //return Text(requests[Index]);

                      String resolvedGuy;
                      if(modelIssue[Index].issueStatus=="0"){
                        resolvedGuy = "PO";
                      }else{
                        resolvedGuy = "ARO";
                      }

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
                                        )
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 30),
                                    ),
                                    Container(
                                        child: Expanded(
                                            child: Text(modelIssue[Index].issueDescription)
                                        )
                                    ),
                                    // TODO: content should be replaced
                                    Expanded(
                                        child: Text("Resloved\nby "+resolvedGuy, textAlign: TextAlign.left,)
                                    ),
                                  ],
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