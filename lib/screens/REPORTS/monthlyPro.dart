import 'package:bakestory_report/commonwidgets/commonScaffold.dart';
import 'package:bakestory_report/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:month_year_picker/month_year_picker.dart';

class MonthlyPro extends StatefulWidget {
  const MonthlyPro({super.key});

  @override
  State<MonthlyPro> createState() => _MonthlyProState();
}

class _MonthlyProState extends State<MonthlyPro> {
  TextEditingController dateInput = TextEditingController();
  String formattedDate = "";
  String cid = " ";
  Map? selectedBranch;
  @override
  void initState() {
    String datetoday = DateFormat('dd-MM-yyyy').format(DateTime.now());
    dateInput.text = datetoday;
    Provider.of<Controller>(context, listen: false)
        .getBranch(context, datetoday);
    super.initState();
  }

  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    return MyScaffold(
        hasDrawer: true,
        scBgColor: Color.fromARGB(255, 250, 223, 205),
        body: Consumer<Controller>(builder: (context, value, child) {
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
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            final pickedDate = await showMonthYearPicker(
                                context: context,
                                initialDate: _selected ?? DateTime.now(),
                                firstDate: DateTime(2019),
                                lastDate: DateTime(2030),
                                locale: Locale('en', 'US'));

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
                                    .getProlossReport(context, formattedDate,
                                        value.selectedBranch["CID"].toString());
                                //set output date to TextField value.
                              });
                            } else {}
                          },
                        )),
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
                        underline: SizedBox(),
                        value: value.selectedBranch,

                        // icon: Icon(Icons.arrow_circle_down),
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
                          setState(() {
                            // print("cidddddddddd===============>>>>$cid");
                            cid = val!["CID"].toString();
                            value.selectedBranch = val;
                            value.changebranch(val);
                            Provider.of<Controller>(context, listen: false)
                                .getProlossReport(context, formattedDate, cid);
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
              value.isMonthreportLoading
                  ? SizedBox(
                    height: size.height * 0.6,
                    child: SpinKitFadingCircle(
                      color: Colors.black,
                      duration: Duration(minutes: 10),
                    ),
                  )
                  : Expanded(
                      child: ListView.builder(
                          itemCount: value.monthReportWidget.length,
                          itemBuilder: (BuildContext context, int index) {
                            return value.monthReportWidget[index];
                          }),
                    ),
            ],
          );
        }),
        title: "Monthly report");
  }

  pikmonthyear(BuildContext context) {
    final selected = showMonthYearPicker(
      context: context,
      initialDate: _selected ?? DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2030),
    );
  }
}
