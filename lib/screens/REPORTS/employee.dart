import 'package:bakestory_report/commonwidgets/commonScaffold.dart';
import 'package:bakestory_report/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EmployReport extends StatefulWidget {
  const EmployReport({super.key});

  @override
  State<EmployReport> createState() => _EmployReportState();
}

class _EmployReportState extends State<EmployReport> {
  String cid = "";
  @override
  void initState() {
    String datetoday = DateFormat('dd-MM-yyyy').format(DateTime.now());
    String d = Provider.of<Controller>(context, listen: false).defbrnch;
    print("jhgfdstrtyuijkkltttttttttttttttttttt>>>>$d");
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<Controller>(context, listen: false)
          .getBranch(context, datetoday);
      Provider.of<Controller>(context, listen: false)
          .getEmployeeReport(context, d);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MyScaffold(
        hasDrawer: true,
        scBgColor: Color.fromARGB(255, 250, 223, 205),
        body: Consumer<Controller>(builder: (context, value, child) {
          // Provider.of<Controller>(context, listen: false).getEmployeeReport(context,value.selectedBranch["CID"].toString());
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                height: 47,
                width: 200,
                padding: EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: DropdownButton<Map>(
                  underline: SizedBox(),
                  elevation: 0,
                  value: value.selectedBranch,
                  items: value.branchlist.map((branch) {
                    // cid = branch["CID"].toString();
                    return DropdownMenuItem<Map>(
                      value: branch,
                      child: Text(
                        branch["BranchName"],
                        style: GoogleFonts.ptSerif(fontSize: 16),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      print(val!["CID"]);
                      cid = val!["CID"].toString();
                      value.selectedBranch = val;
                      Provider.of<Controller>(context, listen: false)
                          .getEmployeeReport(context, cid);
                    });
                    //  print("cidddddddddd===============>>>>${cid}");
                  },
                  hint: Text('Select Branch'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              value.isEMPreportLoading
                  ? SizedBox(
                      height: size.height * 0.6,
                      child: SpinKitFadingCircle(
                        color: Colors.black,
                        duration: Duration(minutes: 10),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                          itemCount: value.proReportWidget.length,
                          itemBuilder: (BuildContext context, int index) {
                            return value.proReportWidget[index];
                          }),
                    ),
            ],
          );
        }),
        title: "Employee Report");
  }
}
