import 'package:flutter/material.dart';
import 'category_items.dart';

class SelectCategory extends StatefulWidget {
  @override
  _SelectCategoryState createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {

  List<String> requests = ["Voting Related","Basic Amenities","Forms Related", "Travel Issues", "Food Related"];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title:  Text('Item Request Categories', textAlign: TextAlign.center),
          backgroundColor: Color(0xff34A2AA),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              GestureDetector(
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [Color(0xff0BBFD6), Color(0xff5ACCC1)],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(0.5, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Image.asset('assets/images/polling_machines.png', width: 50.0, height: 50.0,
                            ),
                            Padding(padding: EdgeInsets.only(left: 80)),
                            Text("Polling\nMachine", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,),
                          ],
                        ),
                      ),
                    )
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryItems(requestCategory: "POLLING_MACHINE")),
                  );
                },
              ),
              GestureDetector(
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [Color(0xff0BBFD6), Color(0xff5ACCC1)],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(0.5, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Image.asset('assets/images/votting_materials.png', width: 50.0, height: 50.0,
                            ),
                            Padding(padding: EdgeInsets.only(left: 80)),
                            Text("Extra\nPolling\nMaterials", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,),
                          ],
                        ),
                      ),
                    )
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryItems(requestCategory: "POLLING_MATERIALS")),
                  );
                },
              ),
              GestureDetector(
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [Color(0xff0BBFD6), Color(0xff5ACCC1)],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(0.5, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Image.asset('assets/images/forms.png', width: 50.0, height: 50.0,
                            ),
                            Padding(padding: EdgeInsets.only(left: 80)),
                            Text("Extra\nForms", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,),
                          ],
                        ),
                      ),
                    )
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryItems(requestCategory: "FORMS")),
                  );
                },
              ),
              GestureDetector(
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [Color(0xff0BBFD6), Color(0xff5ACCC1)],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(0.5, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Image.asset('assets/images/envelope.png', width: 50.0, height: 50.0,
                            ),
                            Padding(padding: EdgeInsets.only(left: 80)),
                            Text("Extra\nEnvelopes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,),
                          ],
                        ),
                      ),
                    )
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryItems(requestCategory: "ENVELOPES")),
                  );
                },
              ),
              GestureDetector(
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [Color(0xff0BBFD6), Color(0xff5ACCC1)],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(0.5, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Image.asset('assets/images/statino.png', width: 50.0, height: 50.0,
                            ),
                            Padding(padding: EdgeInsets.only(left: 80)),
                            Text("Extra\nStationery", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,),
                          ],
                        ),
                      ),
                    )
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryItems(requestCategory: "STATIONERY")),
                  );
                },
              ),
              GestureDetector(
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [Color(0xff0BBFD6), Color(0xff5ACCC1)],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(0.5, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Image.asset('assets/images/basic_resized.png', width: 50.0, height: 50.0,
                            ),
                            Padding(padding: EdgeInsets.only(left: 80)),
                            Text("Basic\nFacilities", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,),
                          ],
                        ),
                      ),
                    )
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryItems(requestCategory: "BASIC_FACILITIES")),
                  );
                },
              ),
              GestureDetector(
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [Color(0xff0BBFD6), Color(0xff5ACCC1)],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(0.5, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Image.asset('assets/images/food_and_water.png', width: 50.0, height: 50.0,
                            ),
                            Padding(padding: EdgeInsets.only(left: 80)),
                            Text("Food &\nWater", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,),
                          ],
                        ),
                      ),
                    )
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryItems(requestCategory: "FOOD_AND_WATER")),
                  );
                },
              ),
              /*
              GestureDetector(
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [Color(0xff0BBFD6), Color(0xff5ACCC1)],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(0.5, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Image.asset('assets/images/signage.png', width: 50.0, height: 50.0,
                            ),
                            Padding(padding: EdgeInsets.only(left: 80)),
                            Text("Signage", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,),
                          ],
                        ),
                      ),
                    )
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryItems(requestCategory: "SIGNAGE")),
                  );
                },
              ),
              GestureDetector(
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [Color(0xff0BBFD6), Color(0xff5ACCC1)],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(0.5, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Image.asset('assets/images/help_desk.png', width: 50.0, height: 50.0,
                              ),
                              Padding(padding: EdgeInsets.only(left: 80)),
                              Text("Help\nDesk", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,),
                            ],
                          ),
                      ),
                    )
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryItems(requestCategory: "HELP_DESK")),
                  );
                },
              ),
              GestureDetector(
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [Color(0xff0BBFD6), Color(0xff5ACCC1)],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(0.5, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Image.asset('assets/images/way_in.png', width: 50.0, height: 50.0,
                            ),
                            Padding(padding: EdgeInsets.only(left: 80)),
                            Text("Entry &\nExit", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,),
                          ],
                        ),
                      ),
                    )
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryItems(requestCategory: "ENTRY_EXIT")),
                  );
                },
              ),*/
            ],
          ),
        )
    );
  }
}