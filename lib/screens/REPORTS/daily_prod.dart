import 'package:bakestory_report/commoncalender.dart';
import 'package:bakestory_report/commonwidgets/commonScaffold.dart';
import 'package:bakestory_report/controller/controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DailyProduct extends StatefulWidget {
  const DailyProduct({super.key});

  @override
  State<DailyProduct> createState() => _DailyProductState();
}

class _DailyProductState extends State<DailyProduct> {
  TextEditingController dateInput = TextEditingController();
  String formattedDate = "";
  String cid = "";
  bool grndtotRow = false;
  @override
  void initState() {
    grndtotRow = false;
    String datetoday = DateFormat('dd-MM-yyyy').format(DateTime.now());
    dateInput.text = datetoday; //set the initial value of text field
    Provider.of<Controller>(context, listen: false)
        .getBranch(context, datetoday);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      style: GoogleFonts.ptSerif(color: Colors.black),
                      controller: dateInput,
                      //editing controller of this TextField
                      decoration: InputDecoration(
                        border: InputBorder.none,

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
                                .getDailyProductionReport(
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
                    padding: EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: DropdownButton<Map>(
                      value: value.selectedBranch,
                      underline: SizedBox(),
                      items: value.branchlist.map((branch) {
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
                          cid = val!["CID"].toString();
                          value.selectedBranch = val;
                          value.changebranch(val);
                          Provider.of<Controller>(context, listen: false)
                              .getDailyProductionReport(
                                  context, formattedDate, cid);
                        });
                      },
                      hint: Text('Select Branch'),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            value.isProdLoding
                ? Padding(
                    padding: EdgeInsets.only(top: 70),
                    child: SpinKitDualRing(
                      color: Colors.blue,
                      lineWidth: 5.0,
                      size: 40,
                      duration: Duration(minutes: 5),
                    ))
                : value.list.length == 0
                    ? Padding(
                        padding: EdgeInsets.only(top: 150),
                        child: Image.asset(
                          "assets/folder.png",
                          height: 80,
                          width: 60,
                        ))
                    : Expanded(
                        child: ListView.builder(
                            // physics: NeverScrollableScrollPhysics(),
                            itemCount: value.list.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              List list = value.list[index].values.first;
                              List datatblerow = [];
                              String chef = "";
                              int i = 0;
                              for (var item in list) {
                                if (item["p_name"].isNotEmpty) {
                                  datatblerow.add(item);
                                }
                                print("object${item["c_name"].runtimeType}");
                                if (item["c_name"].isNotEmpty) {
                                  chef = item["c_name"].toString();
                                }

                                //   if (item["flg"] == "2") {

                                //     grandtot = grandtot + double.parse(item["tot"]);

                                // }
                              }
                              print("valuess  hhh---$list");
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        chef,
                                        // value.list[index].keys.first.toString(),
                                        style: GoogleFonts.ptSerif(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red[800]),
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
                                      // headingTextStyle: TextStyle(color: Colors.white),
                                      headingRowHeight: 45,
                                      decoration:
                                          BoxDecoration(color: Colors.white),
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
                                            'EXPECTED QTY',
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
                                                  ? Color.fromARGB(
                                                      255, 165, 209, 229)
                                                  : Colors.white;
                                            }),
                                            cells: [
                                              DataCell(
                                                Text(e["p_name"].toString()),
                                              ),
                                              DataCell(
                                                Text(e["exp_nos"].toString()),
                                              ),
                                              DataCell(
                                                Text(e["nos"].toString()),
                                              ),
                                              DataCell(
                                                Text(e["s_rate_1"].toString()),
                                              ),
                                              DataCell(
                                                Text(e["tot"].toString()),
                                              ),
                                            ]);
                                      }).toList(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              );
                            }),
                      ),
            SizedBox(
              height: 5,
            ),
            //  value.isProdLoding &&
            value.grandtot == 0.0
                ? Container()
                : Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "GRAND TOTAL",
                          style:  GoogleFonts.ptSerif(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          " \u{20B9} ${value.grandtot.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ),
      title: 'Daily Production',
    );
  }
}
