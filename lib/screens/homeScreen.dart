// import 'package:bakestory_report/controller/controller.dart';
import 'package:bakestory_report/commonwidgets/commonScaffold.dart';
import 'package:bakestory_report/commonwidgets/wrapper.dart';
import 'package:bakestory_report/controller/controller.dart';
import 'package:bakestory_report/screens/drawer/drawerPage.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController dateInput = TextEditingController();
  String formattedDate = "";
  String cc = "";
  String cid = "";
  double per = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    String datetoday = DateFormat('dd-MM-yyyy').format(DateTime.now());
    dateInput.text = datetoday;
    Provider.of<Controller>(context, listen: false)
        .getBranch(context, datetoday);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      scBgColor: Color.fromARGB(255, 195, 204, 212),
      hasDrawer: true,
      body: SingleChildScrollView(
        child: Consumer<Controller>(builder: (context, value, child) {
          // List damagell = value.damagelistdash;
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 47,
                      padding: EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: TextField(
                        controller: dateInput,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                          icon: Icon(Icons.calendar_today), //icon of text field
                        ),
                        readOnly: true,
                        //set it true, so that user will not able to edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2100));
                          if (pickedDate != null) {
                            print(
                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            formattedDate =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            setState(() async {
                              dateInput.text = formattedDate;
                              print(value.selectedBranch["CID"].toString());
                              await Provider.of<Controller>(context,
                                      listen: false)
                                  .getDashboard(context, formattedDate,
                                      value.selectedBranch["CID"].toString());

                              //set output date to TextField value.
                            });
                          } else {}
                        },
                        // onChanged: (formattedDate) {

                        //   setState(() async {

                        //     });
                        // },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 5, left: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: DropdownButton<Map>(
                        underline: SizedBox(),
                        value: value.selectedBranch,
                        items: value.branchlist.map((branch) {
                          // cid = branch["CID"].toString();
                          return DropdownMenuItem<Map>(
                            value: branch,
                            child: Text(
                              branch["BranchName"],
                              style: GoogleFonts.ptSerif(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() async {
                            //  print(value!["CID"]);
                            cid = val!["CID"].toString();
                            // value.selectedBranch = val;
                            value.changebranch(val);

                            await Provider.of<Controller>(context,
                                    listen: false)
                                .getDashboard(context, formattedDate, cid);

                            print(
                                "cccccccccccccccccccnnnnnnnnnnnTTT--------${value.dashboardMap["emp_cnt"].toString().runtimeType}");
                            print(
                                "qqqqqqqqqqqqqqqqqqqqqqTTT--------${value.qtydata.runtimeType}");
                          });
                          print("cidddddddddd===============>>>>${cid}");
                        },
                        hint: Text('Select Branch'),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
      
              SizedBox(
                height: 30,
              ),

              dashcontainer(
                  "Employee",
                  value.dashboardMap["emp_cnt"].toString(),
                  "assets/employee.png"),
              //  value.dashboardMap["emp_cnt"].toString(), "assets/emp2.jpg"),
              dashcontainer("Product", value.dashboardMap["items"].toString(),
                  "assets/prod.png"),
              dashcontainer(
                  "Damaged Products", value.qtydata, "assets/dam.png"),
              SizedBox(
                height: 40,
              ),
              value.graphlistdash.length == 0
                  ? SizedBox()
                  : Column(
                      children: [
                        Text(
                          "Employee and Production Graph",
                          style: GoogleFonts.ptSerif(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w800),
                        ),
                        const Divider(
                          // color: Colors.black38,
                          color: Colors.white54,
                          thickness: 1,
                        ),
                      ],
                    ),
              SizedBox(
                height: 30,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: value.graphlistdash.length,
                itemBuilder: (BuildContext context, int index) {
                  if (double.parse(value.graphlistdash[index]["nos"]) > 100) {
                    per =
                        (double.parse(value.graphlistdash[index]["nos"])) / 100;
                  } else {
                    per = double.parse(value.graphlistdash[index]["nos"]);
                  }
                  print(
                      "jbhjjghjgfgdffgsfgs ${value.graphlistdash[index]["nos"].runtimeType}");
                  return Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(value.graphlistdash[index]["c_name"].toString(),
                            style: GoogleFonts.ptSerif(
                                fontSize: 18,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold)),
                                SizedBox(height: 5,),
                        SizedBox(
                            height: 50,
                            child: DChartSingleBar(
                              radius: BorderRadius.circular(8),
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.indigo,
                              value: per,
                              foregroundLabel: Center(
                                  child: Text("${per.toString()} %",
                                      // value.graphlistdash[index]["nos"]
                                      //     .toString(),
                                      style: GoogleFonts.ptSerif(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              max: 100,
                            )),
                            Text("Quantity : ${value.graphlistdash[index]["nos"]}",style: GoogleFonts.ptSerif(color: Colors.black,fontSize: 15),),
                        const SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        }),
      ),
      title: 'BakeStory',
    );
  }

  dashcontainer(String title, String data, String icn) {
    return Card(
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple,
                Colors.black87,
              ],
              stops: [0.112, 0.789],
            ),
            // color: Colors.lightGreenAccent,
            borderRadius: BorderRadius.circular(10)),
        width: 290,
        height: 160,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 30,
                      width: 40,
                      child: Image.asset(
                        icn,
                        color: Colors.white70,
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    title,
                    style: GoogleFonts.ptSerif(
                      fontSize: 22,
                      color: Colors.white70,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Divider(
                color: Colors.black38,
                thickness: 2,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                data == null || data.isEmpty || data == "null" ? "0" : data,
                style: GoogleFonts.ptSerif(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
