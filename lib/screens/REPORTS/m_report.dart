import 'package:bakestory_report/commonwidgets/commonScaffold.dart';
import 'package:bakestory_report/controller/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  TextEditingController dateInput = TextEditingController();
  String formattedDate = "";
  bool grndtotRow = false;
  DateTime? _selected;
  @override
  void initState() {
    grndtotRow = false;
    String datetoday = DateFormat('dd-MM-yyyy').format(DateTime.now());
    dateInput.text = DateFormat('MM-yyyy').format(DateTime.now());
    Provider.of<Controller>(context, listen: false).getCategoryList(context);
    super.initState();
    Provider.of<Controller>(context, listen: false)
        .getDailyMonthlyReport(context, datetoday, "1", 1, "1");
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      hasDrawer: true,
      scBgColor: const Color.fromARGB(255, 250, 223, 205),

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
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                      height: 47,
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: TextFormField(
                        controller: dateInput,
                        // validator:
                        //     value.isEmpty ? 'this field is required' : null,
                        readOnly: true,
                        style: GoogleFonts.ptSerif(fontSize: 16),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.ptSerif(fontSize: 16),
                          hintText: 'Pick Year',
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          final pickedDate = await showMonthYearPicker(
                              context: context,
                              initialDate: _selected ?? DateTime.now(),
                              firstDate: DateTime(2019),
                              lastDate: DateTime(2030),
                              locale: const Locale('en', 'US'));

                          if (pickedDate != null) {
                            print(
                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            setState(() {
                              dateInput.text =
                                  DateFormat('MM-yyyy').format(pickedDate);
                              Provider.of<Controller>(context, listen: false)
                                  .getDailyMonthlyReport(
                                      context,
                                      formattedDate,
                                      value.selectedBranch["CID"].toString(),
                                      1,
                                      value.selectedCategory["cat_id"]
                                          .toString());
                              //set output date to TextField value.
                            });
                          } else {}
                        },
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: DropdownButton<Map>(
                      value: value.selectedBranch,
                      underline: const SizedBox(),
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
                          value.selectedBranch = val!;

                          value.changebranch(val);
                          Provider.of<Controller>(context, listen: false)
                              .getDailyMonthlyReport(
                            context,
                            formattedDate,
                            value.selectedBranch["CID"].toString(),
                            1,
                            value.selectedCategory["cat_id"].toString(),
                          );
                        });
                      },
                      hint: const Text('Select Branch'),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: Text("Choose Category  :",
                        style: GoogleFonts.ptSerif(fontSize: 18))),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: DropdownButton<Map>(
                      value: value.selectedCategory,
                      underline: const SizedBox(),
                      items: value.catList.map((cat) {
                        return DropdownMenuItem<Map>(
                          value: cat,
                          child: Text(
                            cat["cat_name"],
                            style: GoogleFonts.ptSerif(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() async {
                          // cid = val!["cat_id"].toString();
                          value.selectedCategory = val!;
                          value.changecat(val!);
                          Provider.of<Controller>(context, listen: false)
                              .getDailyMonthlyReport(
                                  context,
                                  formattedDate,
                                  value.selectedBranch["CID"].toString(),
                                  1,
                                  value.selectedCategory["cat_id"].toString());
                          print(
                              "selected this cat----->>>>>>>>>>>>>>>>${value.selectedCategory["cat_id"]}");
                          // Provider.of<Controller>(context, listen: false)
                          //     .getDailyMonthlyReport(
                          //         context, formattedDate, cid, 1);
                        });
                      },
                      hint: const Text('Select Category'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            value.isProdLoding
                ? const Padding(
                    padding: EdgeInsets.only(top: 70),
                    child: SpinKitDualRing(
                      color: Colors.blue,
                      lineWidth: 5.0,
                      size: 40,
                      duration: Duration(minutes: 5),
                    ))
                : value.list.length == 0
                    ? Padding(
                        padding: const EdgeInsets.only(top: 150),
                        child: Image.asset(
                          "assets/folder.png",
                          height: 80,
                          width: 60,
                        ))
                    : Expanded(
                        child: Scrollbar(
                          thickness: 15,
                          radius: const Radius.circular(10),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        columnSpacing: 20,
                                        // headingTextStyle: TextStyle(color: Colors.white),
                                        headingRowHeight: 45,
                                        decoration: const BoxDecoration(
                                            color: Colors.white),
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
                                              color: MaterialStateColor
                                                  .resolveWith(
                                                      (Set<MaterialState>
                                                          states) {
                                                return isLastRow
                                                    ? const Color.fromARGB(
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
                                                  Text(
                                                      e["s_rate_1"].toString()),
                                                ),
                                                DataCell(
                                                  Text(e["tot"].toString()),
                                                ),
                                              ]);
                                        }).toList(),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ),
            const SizedBox(
              height: 5,
            ),
            //  value.isProdLoding &&
            value.grandtot == 0.0 || value.isProdLoding
                ? Container()
                : Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "GRAND TOTAL",
                          style: GoogleFonts.ptSerif(
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
      title: 'Monthly Production Report',
    );
  }
}
