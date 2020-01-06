import 'dart:convert';

import 'package:amfk/login.dart';
import 'package:amfk/model_booth.dart';
import 'package:amfk/otp_login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model_issue.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';


class BoothManagerRequestHistory extends StatefulWidget {
  @override
  _BoothManagerRequestHistoryState createState() => _BoothManagerRequestHistoryState();
}
var savedUid;
var savedToken;

class _BoothManagerRequestHistoryState extends State<BoothManagerRequestHistory> {

  List<booth> boothList = new List<booth>();

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
    //print((data));
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
    //  print(response.body);

      dat = jsonDecode(response.body);
     // print("USER TYPE : "+dat[0]["user_type"]);

      if(dat[0]["success"]==100){

      setState(() {
        for(int i = 0; i < dat[0]["0"].length; i++){
          boothList.add(new booth("0", dat[0]["phone"], dat[0]["officer_name"], dat[0]["0"][i]["rname"],dat[0]["0"][i]["time"], dat[0]["0"][i]["description"],dat[0]["0"][i]["resolved_by"]));
         // print("JIS========="+boothList[i].issueStatus.toString());
        }
      });


      }else{
        showToast("Invalid Credentials...");
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
    if(boothList.length == 0){
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
                    itemCount: boothList.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      //return Text(requests[Index]);
                      String resolvedGuy;
                      if(boothList[Index].issueStatus=="0"){
                        resolvedGuy = "PO";
                      }else{
                        resolvedGuy = "ARO";
                      }
                      return Card(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text(boothList[Index].rname, style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                                        Text(boothList[Index].time.toString().replaceAll("+0530", ""), textAlign: TextAlign.left,),
                                      ],
                                    )
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 2)
                                ),
                                Expanded(
                                    child: Text(boothList[Index].description, textAlign: TextAlign.left,)
                                ),
                                Expanded(
                                    child: Text("Resloved\nby "+resolvedGuy, textAlign: TextAlign.left,)
                                ),
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