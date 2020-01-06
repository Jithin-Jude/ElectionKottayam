import 'package:amfk/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'model_issue.dart';
import 'raised_gradient_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';

class Search extends StatefulWidget {

  @override
  _CategoryItemsState createState() => _CategoryItemsState();
}

class _CategoryItemsState extends State<Search> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController search = new TextEditingController();

  String savedUid;
  String savedToken;

  String requestCategory;

  List<ModelIssue> modelIssue = new List<ModelIssue>();
  List<ModelIssue> boothList = new List<ModelIssue>();
  String screenTitle;

  void onChanged(bool value, int index){
    setState(() {
      modelIssue[index].select = value;
      //print(modelIssue[index].issueName+" : "+modelIssue[index].select.toString());
    });
  }
void populate(){
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Sign Board-Parking for PwD", "10:30 AM", "Parking for Persons with Disability (PwD) coming on wheelchairs or other vehicles (to be visible from the road)", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Sign Board-Queue signs", "11:00 AM", "After entrance arrow sign marks indicating the queue", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Sign Board-Polling personnel signs", "11:30 AM", "Arrow mark indicating the polling personnel", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Sign Board-Male/Female toilets sign", "11:30 AM", "Signage for Male/Female toilets", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Sign Board-PwD toilets sign", "11:30 AM", "Signage for toilets for PwD voters", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Sign Board-Drinking water signs", "11:30 AM", "Signage indicating drinking water", "pending", false));


  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Table", "10:30 AM", "Tables of 4’ x 2.5’ with provision for 3 people to sit", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","BLO", "11:00 AM", "BLO with booth slips required", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","NSS/NSC volunteer", "11:30 AM", "NSS / NSC volunteers (1 male 1 female) to guide and assist the voters (especially the PwDs) entering the polling station", "pending", false));

  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Toilet", "10:30 AM", "Toilet related issues.", "pending", false));


  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Dinner", "10:30 AM", "Dinner for 22/04/19 - 9:00pm", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Breakfast ", "10:30 AM", "Breakfast for 23/04/19 - 8:00am", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Lunch", "10:30 AM", "Lunch for 23/04/19 - 1:00pm", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Drinking Water", "10:30 AM", "Drinking water required", "pending", false));

  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Entrance/Exit issue", "10:30 AM", "Separate entrance and exit for the polling station required", "pending", false));

  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Fan", "10:30 AM", "Requires more Fan.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Lights", "10:30 AM", "Requires more Lights.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Electricity", "10:30 AM", "Electricity connection with two plug points required", "pending", false));

  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Chair", "10:30 AM", "Requires more chairs.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Table", "10:30 AM", "Requires more tables.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Ramp", "10:30 AM", "Requires more ramp.", "pending", false));

  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Control Unit", "10:30 AM", "Issue regarding Control Unit", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Balloting Units", "10:30 AM", "Issue regarding Balloting Units", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","VVPAT", "10:30 AM", "Issue regarding VVPAT", "pending", false));

  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Register of Voters", "10:30 AM", "Issue regarding polling materials(Form 17A)", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Copy of list of Contesting Candidates", "10:30 AM", "Issue regarding Copy of list of Contesting Candidates (Form 7A)", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Ballot Papers spacing issue", "10:30 AM", "Issue regarding Ballot Papers (for tendered votes)", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Photocopy of signature of Candidates/Agents", "10:30 AM", "Issue regarding Photocopy of signature of Candidates/Agents", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Indelible Ink", "10:30 AM", "Issue regarding Indelible Ink(2 phials of 10cc)", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Common Address tags", "10:30 AM", "Issue regarding Common Address tags for Balloting Unit, Control Unit and VVPAT", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Special Tag", "10:30 AM", "Special Tag required", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Green Paper Seals for EVM", "10:30 AM", "Issue regarding Green Paper Seals for EVM", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Strip Seal", "10:30 AM", "Issue regarding Strip Seal", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Rubber Stamp with Arrow Cross Mark", "10:30 AM", "Issue regarding Rubber Stamp with Arrow Cross Mark", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Stamp Pad", "10:30 AM", "Issue regarding Stamp Pad (purple)", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Metal seal for Presiding Officer", "10:30 AM", "Issue regarding Metal seal for Presiding Officer", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Match Box", "10:30 AM", "Match Box required", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Presiding Officer diary", "10:30 AM", "Issue regarding Presiding Officer diary", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Envelope made of thick black paper", "10:30 AM", "Envelope made of thick black paper (for sealing printed paper slips of Mock Poll) required", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Plastic Box for Black paper envelope sealing", "10:30 AM", "Issue regarding Plastic Box for Black paper envelope sealing", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Pink Paper seal for sealing Plastic Box", "10:30 AM", "Issue regarding Pink Paper seal for sealing Plastic Box", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Forms for declaration by elector under rule 49MA", "10:30 AM", "Issue regarding Forms for declaration by elector under rule 49MA", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Operational Manual of VVPAT", "10:30 AM", "Issue regarding Operational Manual of VVPAT", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Mock Poll Slip Stamp", "10:30 AM", "Issue regarding Mock Poll Slip Stamp", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Poster on How to cast vote on EVM & VVPAT", "10:30 AM", "Issue regarding Poster on How to cast vote on EVM & VVPAT", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Brochure for Presiding Officer on use of EVM & VVPAT", "10:30 AM", "Issue regarding Brochure for Presiding Officer on use of EVM & VVPAT", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Troubleshooting on use of EVM & VVPAT", "10:30 AM", "Issue regarding Troubleshooting on use of EVM & VVPAT", "pending", false));

  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","List of Contesting Candidates", "10:30 AM", "Issue regarding List of Contesting Candidates.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","List of Challenged Votes", "10:30 AM", "Issue regarding List of Challenged Votes (Form 14)", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","List of Blind and Infirm voters", "10:30 AM", "Issue regarding List of Blind and Infirm voters (Form 14A)", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","List of Tendered Votes", "10:30 AM", "Issue regarding List of Tendered Votes (Form 17B)", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Account of Votes Recorded", "10:30 AM", "Issue regarding Account of Votes Recorded", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Record of Paper Seals used", "10:30 AM", "Issue regarding Record of Paper Seals used", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Receipt book for deposit of challenged votes fee", "10:30 AM", "Issue regarding Receipt book for deposit of challenged votes fee.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Letter to SHO", "10:30 AM", "Issue regarding Letter to SHO", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Declaration by the Presiding Officer before the commencement of poll and at the end of the poll", "10:30 AM", "Issue regarding Declaration by the Presiding Officer before the commencement of poll and at the end of the poll (Part I to IV)", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Declaration by Elector about age", "10:30 AM", "Issue regarding Declaration by Elector about age", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","List of electors who voted after giving Declaration/Refused to give declaration", "10:30 AM", "Issue regarding List of electors who voted after giving Declaration / Refused to give declaration", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Declaration by the companion of Blind and Infirm voter", "10:30 AM", "Issue regarding Declaration by the companion of Blind and Infirm voter", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Entry passes for Polling Agents", "10:30 AM", "Issue regarding Entry passes for Polling Agents", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Format for Presiding Officer’s additional 16-point report to be submitted to constituency observer/ Returning Office", "10:30 AM", "Issue regarding Format for Presiding Officer’s additional 16-point report to be submitted to constituency observer/ Returning Officer", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Visit Sheet", "10:30 AM", "Issue regarding Visit Sheet", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Receipts of Return of Election Records and Materials after poll", "10:30 AM", "Issue regarding Receipts of Return of Election Records and Materials after poll", "pending", false));

  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For smaller envelopes (statutory covers) (SE-8)", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For marked copy of electoral rolls (SE-8)", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For other copies of electoral rolls (SE-8)", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For tendered ballot paper and tendered voters list", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For declaration by the Presiding Officer before and after the poll", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For account of votes recorded (Form 17C) (SE-5)", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For list of challenged votes (SE-5)", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For unused and spoiled paper seals (SE-5)", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For appointment letters of polling agents (SE-6)", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For list of blind and infirm voters (SE-5)", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For Presiding Officer’s diary report (SE-6)", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For election duty certificate (SE-5)", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For receipt book and cash forfeited (SE-6)", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For declaration of companions (SE-5)", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For smaller envelopes (others) (SE-7)", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For Register of Voters having signatures of voters (17A) (SE-8)", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For other relevant papers (SE-5)", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For smaller envelopes (SE-8)", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Cover for Presiding Officer’s brief record under rule 40 (SE-6)", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Plain envelopes (SE-7)", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Plain envelopes (SE-8)", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For unused ballot papers (SE-7)", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","For any other paper that the RO has decided to keep in the sealed cover", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Cover for unused and damaged special tags (SE-7)", "10:30 AM", "Issue regarding envelope.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Cover for unused and damaged strip seal (SE-7)", "10:30 AM", "Issue regarding envelope.", "pending", false));

  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Ordinary Pencil", "10:30 AM", "Requires more Ordinary Pencil.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Ball Pen", "10:30 AM", "Requires more Ball Pen.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Blank Paper", "10:30 AM", "Requires more Blank Paper.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Pins", "10:30 AM", "Requires more Pins.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Sealing Wax(Sticks)", "10:30 AM", "Requires more Sealing Wax(Sticks).", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Voting Compartment", "10:30 AM", "Requires more Voting Compartment.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Gum Paste", "10:30 AM", "Requires more .", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Blade", "10:30 AM", "Requires more Blade.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Candle Sticks", "10:30 AM", "Requires more Candle Sticks.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Thin Twine Thread", "10:30 AM", "Requires more Thin Twine Thread.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Metal Rule", "10:30 AM", "Requires more Metal Rule.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Carbon Paper", "10:30 AM", "Requires more Carbon Paper.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Cloth or Rag for removing oil etc.", "10:30 AM", "Requires more Cloth or Rag for removing oil etc.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Packing Paper Sheets", "10:30 AM", "Requires more Packing Paper Sheet.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Cup/Empty Tin/Plastic Box for holding indelible ink bottle", "10:30 AM", "Requires more Cup/Empty Tin/Plastic Box for holding indelible ink bottle.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Drawing Pins", "10:30 AM", "Requires more Drawing Pin.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Check Lists", "10:30 AM", "Requires more Check List.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Rubber Bands", "10:30 AM", "Requires more Rubber Band.", "pending", false));
  modelIssue.add(new ModelIssue("1", "8943676929", "S_140","Pala","Cello Tape", "10:30 AM", "Requires more Cello Tape.", "pending", false));

}
  @override
  void initState() {
    search.addListener(onChange);

    getSavedData();


     populate();
boothList=modelIssue;
    super.initState();
  }
  void onChange(){
    String text = search.text;
    //do your text transforming
    if(text!=""){
    boothList.clear();
    //print("TEXT::::::"+text);

      //populate();
      var k=0;
      for(int i = 0; i < modelIssue.length; i++){
        // modelIssue.add(new ModelIssue(dat[0]["0"][i]["rid"],dat[0]["0"][i]["phone"], "S_140","Pala",dat[0]["0"][i]["rname"],
        //   dat[0]["0"][i]["time"], dat[0]["0"][i]["description"],
        // "pending", true));
        //print("JIS========="+modelIssue[i].issueName.toString());

        if(modelIssue[i].issueName.contains(text));
        boothList.add(modelIssue[k]);
        //print("JIS========="+boothList[k].issueName.toString());
        k++;

      }


    }
    else {

      boothList = modelIssue;
     // print("[[[[[[[[[[]]]]]]]]]]]]"+modelIssue.length.toString());

    }

  }
  void getSavedData() async{
    await getSharedPrefrence();
  }

  getSharedPrefrence() async{
    final prefs = await SharedPreferences.getInstance();
    savedUid = prefs.getString('saved_uid') ?? '';
    savedToken = prefs.getString('saved_token') ?? '';
  }

  Future<Null> _loginapi(var data) async {
    var url = Constants.URL_REQUEST;
   // print("SENDING TO SERVER"+json.encode(data));
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
      //print("---------------------"+response.body);

      dat = jsonDecode(response.body);

      if(dat[0]["success"]==100){
        showAlertDialog("Submitted", "Your grievance is successfully submitted.");
        displaySnackBar(dat[0]["message"]);
      }
      else
      {

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

    for(int j = 0; j < boothList.length; j++){
      if(boothList[j].select){
        selectFlag = true;
      }
    }

    if(selectFlag){

      var request="[";
      int k = 0;

      for(int j = 0; j < boothList.length; j++){
        if(boothList[j].select) {
          ++k;
          var jis={};
         // print("ISSUE NAME : "+boothList[j].issueName+" : "+boothList[j].issueDescription);
          jis["request_name"] = boothList[j].issueName;
          jis["description"] = boothList[j].issueDescription+"\ncount : "+boothList[j].issueCount.toString();
          if(k==1)
            request+=""+json.encode(jis);
          else
            request+=","+json.encode(jis);

        }
      }
      request+="]";
    //  print(boothList.toString());
   //   print("UID : "+savedUid);
    //  print("TOKEN : "+savedToken);

      var data = {};
      data["uid"] = savedUid;
      data["token"] = savedToken;
      data["request"] = request;
      //String str = json.encode(data);
    //  print("REQUEST : "+data.toString());
      _loginapi(data);
    }else{
      displaySnackBar("Kindly select some issues");
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
            elevation: 0,
            title:  TextFormField(
              controller: search,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: new InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.white),
                labelStyle: TextStyle(color: Colors.yellow),

                fillColor: Colors.green,
                border: InputBorder.none,
                //fillColor: Colors.green
              ),
              textAlign: TextAlign.center,
              autofocus: true,
              textInputAction: TextInputAction.done,
              inputFormatters: [BlacklistingTextInputFormatter(RegExp("[ ,;.N/#*)(+-]")),],
            ),
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
                      itemCount: boothList.length,
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
                                    child: Text(boothList[Index].issueName, textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold),)
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 8)
                                ),
                                Expanded(
                                    child: Text(boothList[Index].issueDescription, textAlign: TextAlign.left,)
                                ),
                                Column(
                                  children: <Widget>[
                                    RawMaterialButton(
                                      onPressed: () {
                                        setState(() {
                                          boothList[Index].issueCount++;
                                         // print(boothList[Index].issueCount);
                                        });
                                      },
                                      child: new Icon(
                                        Icons.add,
                                        color: Color(0xff34A2AA),
                                        size: 30.0,
                                      ),
                                      shape: new CircleBorder(),
                                      elevation: 2.0,
                                      fillColor: Colors.white,
                                      padding: const EdgeInsets.all(0.0),
                                    ),
                                    Text(boothList[Index].issueCount.toString(), textAlign: TextAlign.center,),
                                    RawMaterialButton(
                                      onPressed: () {
                                        setState(() {
                                          if(boothList[Index].issueCount > 1){
                                            boothList[Index].issueCount--;
                                           // print(boothList[Index].issueCount);
                                          }
                                        });
                                      },
                                      child: new Icon(
                                        Icons.do_not_disturb_on,
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
                                  child: Checkbox(value: boothList[Index].select, onChanged: (bool value){onChanged(value, Index);},),
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
                            updateDatabase();

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