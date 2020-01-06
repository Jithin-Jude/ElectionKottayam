import 'package:amfk/loader.dart';
import 'package:amfk/otp_login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'model_issue.dart';
import 'raised_gradient_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'package:connectivity/connectivity.dart';

class CategoryItems extends StatefulWidget {
  final String requestCategory;
  CategoryItems({Key key, @required this.requestCategory}) : super(key: key);

  @override
  _CategoryItemsState createState() => _CategoryItemsState(requestCategory);
}

class _CategoryItemsState extends State<CategoryItems> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String savedUid;
  String savedToken;

  String requestCategory;
  _CategoryItemsState(this.requestCategory);

  List<ModelIssue> modelIssue = new List<ModelIssue>();
  String screenTitle;

  void onChanged(bool value, int index){
    setState(() {
        modelIssue[index].select = value;
        //print(modelIssue[index].issueName+" : "+modelIssue[index].select.toString());
    });
  }

  @override
  void initState() {

    getSavedData();

    if(requestCategory == "POLLING_MACHINE"){
      screenTitle = "Polling Machine";

      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Control Unit", "11:00 AM", "Issue regarding Control Unit(Default value 1)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Balloting Units", "11:00 AM", "Issue regarding Balloting Units(Default value 1)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","VVPAT", "11:00 AM", "Issue regarding VVPAT(Default value 1)", "pending", false));

    }else if(requestCategory == "POLLING_MATERIALS"){
      screenTitle = "Extra Polling Materials";

      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Register of Voters", "11:00 AM", "Form 17A", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Copy of list of Contesting Candidates", "11:00 AM", "Form 7A", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Ballot Papers", "11:00 AM", "For Tendered Votes", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Signature of Candidates/Agents", "11:00 AM", "Photocopy", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Indelible Ink", "11:00 AM", "2 phials of 10cc", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Common Address tags", "11:00 AM", "For Polling Machine", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Special Tag", "11:00 AM", "Tag", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Green Paper Seals", "11:00 AM", "For EVM", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Strip Seal", "11:00 AM", "Seal", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Rubber Stamp", "11:00 AM", "With Arrow Cross Mark", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Stamp Pad", "11:00 AM", "Purple", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Metal seal", "11:00 AM", "For Presiding Officer", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Match Box", "11:00 AM", "For Sealing Purpose", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Presiding Officer Diary", "11:00 AM", "Documentation Purpose", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Envelope made of thick black paper", "11:00 AM", "For Sealing Printed Paper Slips of Mock Poll", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Plastic Box", "11:00 AM", "For Black Paper Envelope Sealing", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Pink Paper Seal", "11:00 AM", "For Sealing Plastic Box", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Forms or Declaration by Elector", "11:00 AM", "Under rule 49MA", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Operational Manual", "11:00 AM", "VVPAT", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Mock Poll Slip Stamp", "11:00 AM", "Stamp", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Poster", "11:00 AM", "On how to Cast Vote on EVM & VVPAT", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Brochure for Presiding Officer", "11:00 AM", "On use of EVM & VVPAT", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Troubleshooting", "11:00 AM", "On use of EVM & VVPAT", "pending", false));

    }else if(requestCategory == "FORMS"){
      screenTitle = "Extra Forms";

      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","List of Contesting Candidates", "11:00 AM", "Candidates List", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","List of Challenged Votes", "11:00 AM", "Form 14", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","List of Blind and Infirm voters", "11:00 AM", "Form 14A", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","List of Tendered Votes", "11:00 AM", "Form 17B", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Account of Votes Recorded", "11:00 AM", "Form", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Record of Paper Seals used", "11:00 AM", "Form", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Receipt book", "11:00 AM", "For deposit of Challenged Votes fee", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Letter to SHO", "11:00 AM", "Format", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Declaration by the Presiding Officer", "11:00 AM", "Before the Commencement of Poll and at the end of the Poll (Part I to IV)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Declaration by Elector", "11:00 AM", "Age Declaration", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","List of electors who voted", "11:00 AM", "After giving Declaration / Refused to give declaration", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Declaration", "11:00 AM", "By the companion of Blind and Infirm voter", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Entry passes", "11:00 AM", "For Polling Agents", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Format for Presiding Officer’s additional 16-point report", "11:00 AM", "To be submitted to Constituency Observer/ Returning Officer", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Visit Sheet", "11:00 AM", "Visit Records", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Receipts of Return of Election Records and Materials", "11:00 AM", "After Poll", "pending", false));

    }else if(requestCategory == "ENVELOPES"){
      screenTitle = "Extra Envelopes";

      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For smaller envelopes", "11:00 AM", "Statutory Covers (SE-8)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For marked copy of electoral rolls", "11:00 AM", "(SE-8)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For other copies of electoral rolls", "11:00 AM", "(SE-8)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For tendered ballot paper and tendered voters list", "11:00 AM", "Envelope", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For declaration by the Presiding Officer before and after the poll", "11:00 AM", "Envelope", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For account of votes recorded", "11:00 AM", "Form 17C (SE-5)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For list of challenged votes", "11:00 AM", "(SE-5)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For unused and spoiled paper seals", "11:00 AM", "(SE-5)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For appointment letters of polling agents", "11:00 AM", "(SE-6)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For list of blind and infirm voters", "11:00 AM", "(SE-5)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For Presiding Officer’s diary report", "11:00 AM", "(SE-6)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For election duty certificate", "11:00 AM", "(SE-5)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For receipt book and cash forfeited", "11:00 AM", "(SE-6)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For declaration of companions", "11:00 AM", "(SE-5)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For smaller envelopes (others)", "11:00 AM", "(SE-7)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For Register of Voters having signatures of voters", "11:00 AM", "17A (SE-8)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For other relevant papers", "11:00 AM", "(SE-5)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For smaller envelopes", "11:00 AM", "(SE-8)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Cover for Presiding Officer’s brief record under rule 40", "11:00 AM", "(SE-6)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Plain envelopes", "11:00 AM", "(SE-7)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Plain envelopes", "11:00 AM", "(SE-8)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For unused ballot papers", "11:00 AM", "(SE-7)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For any other paper that the RO has decided to keep in the sealed cover", "11:00 AM", "Envelope", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Cover for unused and damaged special tags", "11:00 AM", "(SE-7)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Cover for unused and damaged strip seal", "11:00 AM", "(SE-7)", "pending", false));

    }else if(requestCategory == "STATIONERY"){
      screenTitle = "Extra Stationery";

      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Ordinary Pencil", "11:00 AM", "Required", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Ball Pen", "11:00 AM", "Required", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Blank Paper(sheets)", "11:00 AM", "Required", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Pins(pieces)", "11:00 AM", "Required", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Sealing Wax(Sticks)", "11:00 AM", "Required", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Voting Compartment", "11:00 AM", "Required", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Gum Paste", "11:00 AM", "Required", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Blade", "11:00 AM", "Required", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Candle Sticks", "11:00 AM", "Required", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Thin Twine Thread", "11:00 AM", "Required", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Metal Rule", "11:00 AM", "Required", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Carbon Paper", "11:00 AM", "Required", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Cloth or Rag for removing oil etc", "11:00 AM", "Required", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Packing Paper Sheets", "11:00 AM", "Required", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Cup/Empty Tin/Plastic Box for holding indelible ink bottle", "11:00 AM", "Required", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Drawing Pins(pieces)", "11:00 AM", "Required", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Check Lists", "11:00 AM", "Required", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Rubber Bands", "11:00 AM", "Required", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Cello Tape", "11:00 AM", "Required", "pending", false));

    }else if(requestCategory == "BASIC_FACILITIES"){
      screenTitle = "Basic Facilities";

      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Table", "11:00 AM", "Required", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Chair", "11:00 AM", "Required", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Lights", "11:00 AM", "Required", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Electricity", "11:00 AM", "Power Failure(Default value 1)", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Ramp", "11:00 AM", "For PwD", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Restroom", "11:00 AM", "Facility Required", "pending", false));

    }else if(requestCategory == "FOOD_AND_WATER"){
      screenTitle = "Food & Water";

      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Dinner", "11:00 AM", "22/04/19, Not received till 9:00pm", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Breakfast", "11:00 AM", "23/04/19, Not received till 8:00am", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Lunch", "11:00 AM", "23/04/19, Not received till 1:00pm", "pending", false));
      modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Drinking Water", "11:00 AM", "Quantity required in litres", "pending", false));

    }

    super.initState();
  }

  void getSavedData() async{
    await getSharedPrefrence();
  }

  getSharedPrefrence() async{
    final prefs = await SharedPreferences.getInstance();
    savedUid = prefs.getString('saved_uid') ?? '';
    savedToken = prefs.getString('saved_token') ?? '';
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

  Future<Null> _loginapi(var data) async {
    var url = Constants.URL_REQUEST;
    //print("SENDING TO SERVER"+json.encode(data));
    var response = await request(url, data);
    //print(response);
  }

  Future<Map> request(var url, var data) async {
    http.Response response = await http.post(url,headers:{ "Content-Type":"application/x-www-form-urlencoded" } ,
        body: data,
        encoding: Encoding.getByName("utf-8"));
    List res = response.body.split("\n");
    //print("yoo"+res[0]);
    if(res[0].toString().compareTo("<!DOCTYPE html>")==1) {
      var dat;
    //  print("---------------------"+response.body);

      dat = jsonDecode(response.body);

      if(dat[0]["success"]==100){
        showAlertDialog("Submitted", "Your grievance is successfully submitted.");
        displaySnackBar(dat[0]["message"]);
      }
      else
        {
          if(dat[0]["message"]=="Invalid Credentials"){
            SharedPreferences preferences = await SharedPreferences.getInstance();
            preferences.clear();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new OtpLogin()
            )
            );
          }
          else
          displaySnackBar(dat[0]["message"]);
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

  void updateDatabase(){

    bool selectFlag = false;

    for(int j = 0; j < modelIssue.length; j++){
      if(modelIssue[j].select){
        selectFlag = true;
      }
    }

    if(selectFlag){

      var request="[";
      int k = 0;

      for(int j = 0; j < modelIssue.length; j++){
        if(modelIssue[j].select) {
          ++k;
          var jis={};
         // print("ISSUE NAME : "+modelIssue[j].issueName+" : "+modelIssue[j].issueDescription);
          jis["request_name"] = modelIssue[j].issueName;
          jis["description"] = modelIssue[j].issueDescription+"\ncount : "+modelIssue[j].issueCount.toString();
          if(k==1)
            request+=""+json.encode(jis);
          else
            request+=","+json.encode(jis);

        }
      }
      request+="]";
   //   print(modelIssue.toString());
     // print("UID : "+savedUid);
      //print("TOKEN : "+savedToken);

      var data = {};
      data["uid"] = savedUid;
      data["token"] = savedToken;
      data["request"] = request;
      //String str = json.encode(data);
 //     print("REQUEST : "+data.toString());
      _loginapi(data);
    }else{
      displaySnackBar("Please select some issues");
    }
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
  Widget build(BuildContext context) {

    return
      Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomPadding: true,
          appBar: AppBar(
            centerTitle: true,
            title:  Text(screenTitle, textAlign: TextAlign.center),
            backgroundColor: Color(0xff34A2AA),
            elevation: 0,
          ),
          body: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10,bottom: 20),
                color: Color(0xff34A2AA),
                child : Row(
                  children: <Widget>[
                    Expanded(
                      child: Text("Item", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16),),
                    ),
                    Expanded(
                      child: Text("Description", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16),),
                    ),
                    Expanded(
                      child: Text("Count", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16),),
                    ),
                    Expanded(
                      child: Text("Select", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16),),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: new ListView.builder(
                      itemCount: modelIssue.length,
                      itemBuilder: (BuildContext ctxt, int Index) {
                        //return Text(requests[Index]);
                        return Card(
                              child: Padding(
                                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                          child: Text(modelIssue[Index].issueName, textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold),)
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 8)
                                      ),
                                      Expanded(
                                          child: Text(modelIssue[Index].issueDescription, textAlign: TextAlign.left,)
                                      ),
                                      Column(
                                        children: <Widget>[
                                          RawMaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                modelIssue[Index].issueCount++;
                                              //  print(modelIssue[Index].issueCount);
                                              });
                                            },
                                            child: new Icon(
                                              Icons.add_circle_outline,
                                              color: Color(0xff34A2AA),
                                              size: 30.0,
                                            ),
                                            shape: new CircleBorder(),
                                            elevation: 2.0,
                                            fillColor: Colors.white,
                                            padding: const EdgeInsets.all(0.0),
                                          ),
                                          Text(modelIssue[Index].issueCount.toString(), textAlign: TextAlign.center,),
                                          RawMaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                if(modelIssue[Index].issueCount > 1){
                                                  modelIssue[Index].issueCount--;
                                                 // print(modelIssue[Index].issueCount);
                                                }
                                              });
                                            },
                                            child: new Icon(
                                              Icons.remove_circle_outline,
                                              color: Color(0xff34A2AA),
                                              size: 30.0,
                                            ),
                                            shape: new CircleBorder(),
                                            elevation: 2.0,
                                            fillColor: Colors.white,
                                            padding: const EdgeInsets.all(0.0),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Checkbox(value: modelIssue[Index].select, onChanged: (bool value){onChanged(value, Index);},),
                                      ),
                                    ],
                                  ),
                              ),
                        );
                      }
                  )
              ),
              Container(
                height: 100,
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 0),
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
                      margin: EdgeInsets.only(top: 18, left: 50, right: 50),
                      child: RaisedGradientButton(
                          child: Text('Submit',
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
                                updateDatabase();
                              }else{
                                // No-Internet Case
                                displaySnackBar("Not network connection");
                              }
                            });
                          }
                      ),
                    ),
                  ],
                ),
              )
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