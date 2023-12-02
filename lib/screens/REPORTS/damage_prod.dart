import 'package:bakestory_report/commonwidgets/commonScaffold.dart';
import 'package:bakestory_report/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class DamageProd extends StatefulWidget {
  const DamageProd({super.key});

  @override
  State<DamageProd> createState() => _DamageProdState();
}

class _DamageProdState extends State<DamageProd> {
  TextEditingController dateInput = TextEditingController();
  String formattedDate = "";
  double gtot = 0.0;
  String cid = "";
  @override
  void initState() {
    // TODO: implement initState
    String datetoday = DateFormat('dd-MM-yyyy').format(DateTime.now());
    dateInput.text = datetoday;
    String d = Provider.of<Controller>(context, listen: false).defbrnch;
    print("jhgfdstrtyuijkkltttttttttttttttttttt>>>>$d");
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<Controller>(context, listen: false)
          .getBranch(context, datetoday);
      Provider.of<Controller>(context, listen: false)
          .getDamageProductionReport(context, datetoday, d);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MyScaffold(
      hasDrawer: true,
      scBgColor: Color.fromARGB(255, 250, 223, 205),
      // row: Calender(),

      // body: Consumer<Controller>(builder: (context, value, child) {

      //   return ListView.builder(
      //     itemCount: value.proReportWidget.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       return value.proReportWidget[index];
      //     });

      // }),
      body: Consumer<Controller>(
        builder: (context, value, child) => Column(
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
                      //editing controller of this TextField
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                        icon: Icon(Icons.calendar_today), //icon of text field
                        //label text of field
                      ),
                      readOnly: true,
                      //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2100));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          formattedDate =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          setState(() {
                            dateInput.text = formattedDate;
                            Provider.of<Controller>(context, listen: false)
                                .getDamageProductionReport(
                                    context,
                                    formattedDate,
                                    value.selectedBranch["CID"].toString());
                            //set output date to TextField value.
                          });
                        } else {}
                      },
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
                        setState(() {
                          //  print(value!["CID"]);
                          cid = val!["CID"].toString();
                          value.selectedBranch = val;
                          value.changebranch(val);
                          Provider.of<Controller>(context, listen: false)
                              .getDamageProductionReport(
                                  context, formattedDate, cid);
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
              height: 20,
            ),
            value.isDamageLoding
                ? SizedBox(
                    height: size.height * 0.6,
                    child: SpinKitFadingCircle(
                      color: Colors.black,
                      duration: Duration(minutes: 10),
                    ),
                  )
                : value.list1.length == 0
                    ? Container(
                        height: size.height * 0.6,
                        child: Center(
                          child: Lottie.asset(
                            "assets/nodata.json",
                            height: 100,
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                            // physics: NeverScrollableScrollPhysics(),
                            itemCount: value.list1.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              List list = value.list1[index].values.first;
                              String ccid =
                                  value.list1[index].keys.first.toString();
                              List datatblerow = [];
                              String cheff = "";
                              int i = 0;
                              List cnm = [];
                              for (var item in list) {
                                // print("toot typ${item["tot"].runtimeType}");
                                if (item["c_name"].isNotEmpty &&
                                    item["flg"] != 2) {
                                  datatblerow.add(item);
                                }
                                // print("object ${item["c_name"]}");
                                if (item['c_name'] != null &&
                                    item['c_name'] != " " &&
                                    item['c_name'].isNotEmpty) {
                                  cheff = item["c_name"].toString();
                                  // print("chhhhhhhhhhhhhhhhhhhhhhhh$cheff");
                                  // cnm.add(item["c_name"]);
                                }
                              }
                              // print("object$cnm");

                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        cheff,
                                        // value.list[index].keys.first.toString(),
                                        style: GoogleFonts.ptSerif(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      columnSpacing: 20,
                                      headingTextStyle: GoogleFonts.ptSerif(
                                          color: Colors.white),
                                      headingRowHeight: 45,
                                      headingRowColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.black),
                                      columns: [
                                        DataColumn(
                                          label: Text(
                                            'PRODUCT NAME',
                                            style: GoogleFonts.ptSerif(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.white),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'QUANTITY',
                                            style: GoogleFonts.ptSerif(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.white),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'SALES RATE',
                                            style: GoogleFonts.ptSerif(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.white),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'REMARKS',
                                            style: GoogleFonts.ptSerif(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.white),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'TOTAL',
                                            style: GoogleFonts.ptSerif(
                                                fontStyle: FontStyle.italic,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                      rows: datatblerow
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        int index = entry.key;
                                        Map<String, dynamic> e = entry.value;
                                        bool isLastRow =
                                            index == datatblerow.length - 1;
                                        return DataRow(
                                            color:
                                                MaterialStateColor.resolveWith(
                                                    (Set<MaterialState>
                                                        states) {
                                              return isLastRow
                                                  ? const Color.fromARGB(
                                                      255, 157, 162, 193)
                                                  : Colors.white;
                                            }),
                                            cells: [
                                              DataCell(
                                                Text(e["p_name"].toString()),
                                              ),
                                              DataCell(
                                                Text(e["qty"].toString()),
                                              ),
                                              DataCell(
                                                Text(e["s_rate_1"].toString()),
                                              ),
                                              DataCell(isLastRow
                                                  ? SizedBox()
                                                  : GestureDetector(
                                                      onTap: () {
                                                        dilogbox(
                                                            context,
                                                            e["p_name"]
                                                                .toString(),
                                                            e["remarks"]
                                                                .toString());
                                                      },
                                                      child: SizedBox(
                                                          height: 25,
                                                          width: 24,
                                                          child: Image.asset(
                                                            "assets/tap.png",
                                                          )),
                                                    )),
                                              DataCell(
                                                Text(e["tot"].toString()),
                                              ),
                                            ]);
                                      }).toList(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  )
                                ],
                              );
                            }),
                      ),
            SizedBox(
              height: 5,
            ),
            value.grandtotdamge == 0.0 || value.isDamageLoding
                ? Container()
                : Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 31, 91, 125),
                    ),
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "GRAND TOTAL",
                          style: GoogleFonts.ptSerif(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          " \u{20B9} ${value.grandtotdamge.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ),
      title: 'Damage Products',
    );
  }

  Future<String?> dilogbox(BuildContext context, String title, String remarks) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.only(right: 5, left: 22, top: 10),
        title: Text(
          title,
          style: GoogleFonts.ptSerif(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Text(
          remarks,
          style: GoogleFonts.ptSerif(),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
