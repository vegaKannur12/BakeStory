import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:bakestory_report/components/customSnackbar.dart';
import 'package:bakestory_report/components/externalDir.dart';
import 'package:bakestory_report/components/globalData.dart';
import 'package:bakestory_report/components/networkConnection.dart';
import 'package:bakestory_report/model/menuDatas.dart';
import 'package:bakestory_report/model/registrationModel.dart';
import 'package:bakestory_report/screens/auth/loginScreen.dart';
import 'package:bakestory_report/screens/homeScreen.dart';
import 'package:bakestory_report/services/dbHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "package:collection/collection.dart";
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_to_hex/string_to_hex.dart';

class Controller extends ChangeNotifier {
  String clicked = "0";
  List<dynamic> filteredData = [];
  var jsonEncoded;
  List<TextEditingController> listEditor = [];
  String? fp;
  String? cid;
  ExternalDir externalDir = ExternalDir();
  int? generatedColorInt;
  String? cname;
  String? sof;
  int? qtyinc;
  List<CD> c_d = [];
  String? firstMenu;
  bool isSearch = false;
  String? tabId;
  String? brId;
  String? showGraph;
  String? date_criteria;
  String? customIndex;
  bool isLoading = false;
  bool isLoginLoad = false;
  bool issearching = false;
  bool isReportLoading = false;
  bool isSubReportLoading = false;
  bool isLoginLoading = false;
  String? _string;
  Color? generatedColor;

  String? idd;
  String? menu_index;
  String? tab_index;

  bool? dateApplyClicked;
  String? fromDate;
  String id = "";
  List<String> barColor = [];
  String? selected;
  String? todate;
  var reportjson;
  Map graphMap = {};
  Map selectedBranch = {};
  List<String> legends = [];
  List<String> colorList = [];
  List<Color> colorListCopy = [];

  List<Map<String, dynamic>> listColor = [];

  Color? colorDup;
  bool menuClick = false;
  List<Map<String, dynamic>> list = [];
  List<Map<String, dynamic>> list1 = [];
  List<Map<String, dynamic>> sublist = [];

  List<TabsModel> customMenuList = [];
  List<Map<String, dynamic>> branches = [];
  List<Map<String, dynamic>> productHistory = [];
  List<Map<String, dynamic>> productList = [];
  List<Map<String, dynamic>> newList = [];

  List<TabsModel> tabList = [];
  List<Map<String, dynamic>> legendList = [];

  List<bool> descTextShowFlag = [];
  List<Map<String, dynamic>> menuList = [];
  String urlglobl = Globaldata.apiglobal;
  String token = "";
  List<Map<dynamic, dynamic>> branchlist = [];
  List<Map<String, dynamic>> dailyprodReportlist = [];
  List<Map<String, dynamic>> monthlyprodReportlist = [];
  List<Map<dynamic, dynamic>> damageprodReportlist = [];
  List<Map<String, dynamic>> employeeReportlist = [];
  List proReportWidget = [];
  List monthReportWidget = [];
  List dailyprodnewkeylist = [];
  bool isBranchLoding = false;
  bool isProdLoding = false;
  bool isDamageLoding = false;
  bool isMonthreportLoading = false;
  bool isEMPreportLoading = false;
  bool isDashboardLoding = false;
  double grandtot = 0.0;
  double grandtotdamge = 0.0;
  List graphlistdash = [];
  List damagelistdash = [];
  Map dashboardMap = {};
  List<Map<String, dynamic>> dashList = [];
  String qtydata = "";
  List cnameGRaPList = [];
  List nosGRaPList = [];
  String defbrnch="";

/////////////////////////////////////////////
  Future<RegistrationData?> postRegistration(
      String company_code,
      String? fingerprints,
      String phoneno,
      String deviceinfo,
      BuildContext context) async {
    NetConnection.networkConnection(context).then((value) async {
      print("Text fp...$fingerprints---$company_code---$phoneno---$deviceinfo");
      print("company_code.........$company_code");
      // String dsd="helloo";
      String appType = company_code.substring(10, 12);
      print("apptytpe----$appType");
      if (value == true) {
        try {
          Uri url =
              Uri.parse("https://trafiqerp.in/order/fj/get_registration.php");
          Map body = {
            'company_code': company_code,
            'fcode': fingerprints,
            'deviceinfo': deviceinfo,
            'phoneno': phoneno
          };
          print("body----${body}");
          isLoginLoad = true;
          notifyListeners();
          http.Response response = await http.post(
            url,
            body: body,
          );
          print("respones --- ${response.body}");

          var map = jsonDecode(response.body);
          print("map register ${map}");
          RegistrationData regModel = RegistrationData.fromJson(map);

          sof = regModel.sof;
          fp = regModel.fp;
          String? msg = regModel.msg;
          print("fp----- $fp");
          print("sof----${sof}");

          if (sof == "1") {
            print("apptype----$appType");
            if (appType == 'BS') {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              /////////////// insert into local db /////////////////////
              late CD dataDetails;
              String? fp1 = regModel.fp;
              print("fingerprint......$fp1");
              prefs.setString("fp", fp!);
              String? os = regModel.os;
              regModel.c_d![0].cid;
              cid = regModel.cid;
              prefs.setString("cid", cid!);

              cname = regModel.c_d![0].cnme;
              print("cname ${cname}");

              prefs.setString("cn", cname!);
              notifyListeners();

              await externalDir.fileWrite(fp1!);

              for (var item in regModel.c_d!) {
                c_d.add(item);
                print("ciddddddddd......$item");
              }
              print("bfore----");
              await ReportDB.instance
                  .deleteFromTableCommonQuery("companyRegistrationTable", "");
              var res =
                  await ReportDB.instance.insertRegistrationDetails(regModel);
              print("response----$res");
              // getInitializeApi(context);

              isLoginLoad = false;
              notifyListeners();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            } else {
              CustomSnackbar snackbar = CustomSnackbar();
              snackbar.showSnackbar(context, "Invalid Apk Key", "");
            }
          }
          /////////////////////////////////////////////////////
          if (sof == "0") {
            CustomSnackbar snackbar = CustomSnackbar();
            snackbar.showSnackbar(context, msg.toString(), "");
          }

          notifyListeners();
        } catch (e) {
          print(e);
          return null;
        }
      }
    });
  }

  //////////////////////////////////////////////////

  getLogin(String userName, String password, BuildContext context) async {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          Uri url = Uri.parse("$urlglobl/user_check");
          var body = {'uname': userName, 'pwd': password};
          isLoginLoading = true;
          notifyListeners();
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          token = localStorage.getString('token') ?? " ";
          // ignore: avoid_print
          print("body-----$body---$url-----$token");
          http.Response response =
              await http.post(url, body: jsonEncode(body), headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
          // var res = await Network().authData(data, 'login');
          var map = json.decode(response.body);
          // ignore: avoid_print
          print("map-----$map");
          isLoginLoading = false;
          notifyListeners();
          if (map['message'] == "User Logged In Successfully") {
            SharedPreferences localStorage =
                await SharedPreferences.getInstance();
            localStorage.setString('token', map['access_token']);
            localStorage.setString('user', map['user_id'].toString());
            // ignore: avoid_print
            print('cjcs-----$userName----$password');
            localStorage.setString("st_uname", userName);
            localStorage.setString("st_pwd", password);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else {
            CustomSnackbar snackbar = CustomSnackbar();

            snackbar.showSnackbar(context, map['message'], "");
          }
          notifyListeners();
          // return staffModel;
        } catch (e) {
          // ignore: avoid_print
          print(e);
          return null;
        }
      }
    });
  }

  /////////////////////////////////////////////////////
  getBranch(BuildContext context, String? datetoday) async {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          isBranchLoding = true;
          notifyListeners();
          Uri url = Uri.parse("$urlglobl/branch");
          Map body = {"mm_mob": "1"};
          print("body----$body");
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          token = localStorage.getString('token') ?? " ";
          http.Response response =
              await http.post(url, body: jsonEncode(body), headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
          var map = json.decode(response.body);
          branchlist.clear();
          for (var item in map) {
            branchlist.add(item);
          }
          selectedBranch = branchlist[0];
          defbrnch=selectedBranch["CID"].toString();
          notifyListeners();
          getDashboard(context, datetoday!, branchlist[0]["CID"].toString());
          print("branchlist.......$branchlist");
          isBranchLoding = false;
          notifyListeners();
          print("Branch list map-----$map");
        } catch (e) {
          // ignore: avoid_print
          print(e);
          return null;
        }
      }
    });

    // menuList = [
    //   {"menu_index": "1", "menu_type": "dashboard"},
    //   {"menu_index": "2", "menu_type": "sales"},
    //   {"menu_index": "3", "menu_type": "purchase"}
    // ];

    // menuIndex = menuList[0]["menu_index"];
    // menuTitle = menuList[0]["menu_type"];
    // notifyListeners();

    // notifyListeners();
  }

  changebranch(Map val) {
    selectedBranch = val;
    notifyListeners();
  }

  ///////////////////////////////////////////////////////////
  getDailyProductionReport(
      BuildContext context, String formattedDate, String cid) async {
    var resultList = <String, List<Map<String, dynamic>>>{};
    var grandtotlist = [];
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          isProdLoding = true;
          notifyListeners();
          Uri url = Uri.parse("$urlglobl/fetch_daily_production_report");
          Map body = {"to_date": formattedDate, "company_id": cid};
          print("body----$body");
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          token = localStorage.getString('token') ?? " ";
          http.Response response =
              await http.post(url, body: jsonEncode(body), headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
          var map = json.decode(response.body);
          // print("Prod list map-----$map");
          dailyprodReportlist.clear();
          for (var item in map["data"]) {
            dailyprodReportlist.add(item);
          }
          // for (var i = 0; i < (dailyprodReportlist.length-1); i++) {
          // }

          var dailyprodnewMap =
              groupBy(dailyprodReportlist, (Map obj) => obj['employee_id']);
          print("new mapdailyProd-------.>>$dailyprodnewMap");
          dailyprodnewkeylist.clear();
          dailyprodnewMap.keys.forEach((key) {
            print(".......................................$key");
            dailyprodnewkeylist.add(key);
          });
          /////////////////////////////////////////////////////////////
          grandtot = 0.0;
          // print("listt hhhh----$map");
          for (var item in map["data"]) {
            if (item["flg"] == "2") {
              grandtot = grandtot + double.parse(item["tot"]);
            }
          }
          grandtotlist.add(grandtot);
          print("granbdtott-----$grandtot");
          list.clear();
          resultList = <String, List<Map<String, dynamic>>>{};
          for (var d in map["data"]) {
            print(d);
            var e = {
              "employee_id": d["employee_id"].toString(),
              "exp_nos": d["exp_nos"].toString(),
              "flg": d["flg"].toString(),
              "c_name": d["c_name"].toString(),
              "p_name": d["p_name"].toString(),
              "nos": d["nos"].toString(),
              "s_rate_1": d["s_rate_1"].toString(),
              "tot": d["tot"].toString(),
            };
            var key = d["employee_id"].toString();
            if (resultList.containsKey(key)) {
              resultList[key]!.add(e);
            } else {
              resultList[key] = [e];
            }
          }
          resultList.entries.forEach((e) => list.add({e.key: e.value}));
          isProdLoding = false;
          notifyListeners();
          print("resultList---$list");

          print("Dailyprodlist.......$dailyprodReportlist");

          // print("Branch list map-----$map");
        } catch (e) {
          // ignore: avoid_print
          print(e);
          return null;
        }
      }
    });
  }

  //////////////////////////////////////////////////////
  // makeuserLogContainer(List<Map<String, dynamic>> dailyprodReportlist) {
  //   int? name;
  //   String c_name;
  //   String tot;
  //   int eid = -1;
  //   List dailyProSorted = [];
  //   List grandtot = [];
  //   double grndtotal = 0.0;
  //   int c = 0;
  //   proReportWidget.clear();

  //   for (var item in dailyprodReportlist) {
  //     if (eid != item["employee_id"]) {
  //       proReportWidget.add(Container(
  //         child: Row(
  //           children: [
  //             Flexible(
  //               child: Text(
  //                 item["c_name"].toString().toUpperCase(),
  //                 style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.red),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ));
  //       eid = item["employee_id"];
  //     }

  //     proReportWidget.add(
  //       SingleChildScrollView(
  //           scrollDirection: Axis.horizontal,
  //           child: DataTable(
  //               headingRowHeight: 35,
  //               dataRowMinHeight: 30,
  //               dataRowMaxHeight: 40,
  //               headingRowColor:
  //                   MaterialStateColor.resolveWith((states) => Colors.black),
  //               decoration: BoxDecoration(color: Colors.white),
  //               border: TableBorder.all(
  //                   width: 1, borderRadius: BorderRadius.circular(5)),
  //               columns: [
  //                 DataColumn(
  //                   label: Text(
  //                     'p_name',
  //                     style: TextStyle(
  //                         fontStyle: FontStyle.italic, color: Colors.white),
  //                   ),
  //                 ),
  //                 DataColumn(
  //                   label: Text(
  //                     'exp_nos',
  //                     style: TextStyle(
  //                         fontStyle: FontStyle.italic, color: Colors.white),
  //                   ),
  //                 ),
  //                 DataColumn(
  //                   label: Text(
  //                     'nos',
  //                     style: TextStyle(
  //                         fontStyle: FontStyle.italic, color: Colors.white),
  //                   ),
  //                 ),
  //                 DataColumn(
  //                   label: Text(
  //                     'S_rate',
  //                     style: TextStyle(
  //                         fontStyle: FontStyle.italic, color: Colors.white),
  //                   ),
  //                 ),
  //                 DataColumn(
  //                   label: Text(
  //                     'Total',
  //                     style: TextStyle(
  //                         fontStyle: FontStyle.italic, color: Colors.white),
  //                   ),
  //                 ),
  //               ],
  //               rows: dailyProSorted.asMap().entries.map((entry) {
  //                 int index = entry.key;
  //                 Map<String, dynamic> p = entry.value;
  //                 bool isLastRow = index == dailyProSorted.length - 1;

  //                 return DataRow(
  //                   color: MaterialStateColor.resolveWith(
  //                       (Set<MaterialState> states) {
  //                     return isLastRow ? Colors.blue : Colors.white;
  //                   }),
  //                   cells: [
  //                     DataCell(
  //                       Text(p["p_name"]),
  //                     ),
  //                     DataCell(
  //                       Text(p["exp_nos"]),
  //                     ),
  //                     DataCell(
  //                       Text(p["nos"]),
  //                     ),
  //                     DataCell(
  //                       Text(p["s_rate_1"]),
  //                     ),
  //                     DataCell(
  //                       Text(p["tot"]),
  //                     ),
  //                   ],
  //                 );
  //               }).toList()
  //               // Add another DataRow for the next set of data
  //               )),
  //     );

  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  //////////////////////////////////////////////////////////
  getDamageProductionReport(
      BuildContext context, String formattedDate, String cid) async {
    var damageresultList = <String, List<Map<String, dynamic>>>{};
    // var grandtotlist = [];
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          isDamageLoding = true;
          notifyListeners();

          Uri url = Uri.parse("$urlglobl/fetch_damage_production_report");
          // Map body = {"to_date": "21-11-2023", "company_id": "1"};
          Map body = {"to_date": formattedDate, "company_id": cid};
          print("body----$body");
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          token = localStorage.getString('token') ?? " ";
          http.Response response =
              await http.post(url, body: jsonEncode(body), headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
          var map = json.decode(response.body);
          print("DamageProd list map-----$map");
          print("DamageProd list map[]-----${map["data"]}");
          grandtotdamge = 0.0;
          for (var item in map["data"]) {
            print(
                "nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn${item["p_name"]} ");
            if (item["flg"] == "2") {
              print(
                  "ttttttttttttttttttttttttttttttttttttttt${item["tot"].runtimeType}");
              grandtotdamge = grandtotdamge + item["tot"].toDouble();
            }
          }

          print("granbdtottDamage-----$grandtotdamge");
          list1.clear();
          damageresultList = <String, List<Map<String, dynamic>>>{};

          for (var d in map["data"]) {
            print(d);

            var e = {
              "flg": d["flg"].toString(),
              "p_name": d["p_name"].toString(),
              "remarks": d["remarks"].toString(),
              "product_id": d["product_id"].toString(),
              "c_name": d["c_name"].toString(),
              "qty": d["qty"].toString(),
              "c_id": d["c_id"].toString(),
              "s_rate_1": d["s_rate_1"].toString(),
              "tot": d["tot"].toString(),
            };
            var key = d["c_id"].toString();
            if (damageresultList.containsKey(key)) {
              damageresultList[key]!.add(e);
            } else {
              damageresultList[key] = [e];
            }
          }
          damageresultList.entries.forEach((e) => list1.add({e.key: e.value}));

          print("resultListdamageeee---$list1");

          // damageprodReportlist.clear();
          // for (var item in map["data"]) {
          //   damageprodReportlist.add(item);
          // }
          // print("Damageprodlist.......>>>> $damageprodReportlist");
          isDamageLoding = false;
          notifyListeners();
        } catch (e) {
          // ignore: avoid_print
          print(e);
          return null;
        }
      }
    });
  }

  ///////////////////////////////////////////////////////////

  getProlossReport(
      BuildContext context, String formattedDate, String cid) async {
        Size size=MediaQuery.of(context).size;
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          isMonthreportLoading = true;
          notifyListeners();
          Uri url = Uri.parse("$urlglobl/fetch_monthly_pro_loss_report");
          // Map body = {"to_date": "2023-11-01", "company_id": "1"};
          Map body = {"to_date": formattedDate, "company_id": cid};
          print("body----$body");
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          token = localStorage.getString('token') ?? " ";
          http.Response response =
              await http.post(url, body: jsonEncode(body), headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
          var map = json.decode(response.body);
          monthlyprodReportlist.clear();
          for (var item in map["data"]) {
            monthlyprodReportlist.add(item);
          }
          monthlyReportList(monthlyprodReportlist,size);
          isMonthreportLoading = false;
          notifyListeners();
          print("Monthlylist map-----$map");
        } catch (e) {
          // ignore: avoid_print
          print(e);
          return null;
        }
      }
    });
  }

  //////////////////////////////////////////////
  monthlyReportList(List<Map<String, dynamic>> monthlylist,Size size) {
    monthReportWidget.clear();
    print("Monthly data[]....$monthlylist");
    isEMPreportLoading = true;

    notifyListeners();
    if (monthlylist.length == 0) {
      monthReportWidget.add(Container(
        height: size.height * 0.6,
        child: Center(
          child: Lottie.asset(
            "assets/nodata.json",
            height: 100,
          ),
        ),
      ));
    } 
    else 
    {
      int i = 0;
      monthReportWidget.add(
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Card(
              elevation: 4,
              child: DataTable(
                  headingRowHeight: 45,
                  dataRowMinHeight: 30,
                  dataRowMaxHeight: 35,
                  headingRowColor:
                      MaterialStateColor.resolveWith((states) => Colors.black),
                  decoration: BoxDecoration(color: Colors.white),
                  border: TableBorder.all(
                      width: 0.1, borderRadius: BorderRadius.circular(5)),
                  columns: [
                    DataColumn(
                      label: Text(
                        '',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'EMPLOYEE NAME',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'EXP. SALE',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'SALE',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'DAMAGE',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'SALARY',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'ASSISTANTS',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.white),
                      ),
                    ),
                  ],
                  rows: monthlylist.map((p) {
                    i++;
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(i.toString()),
                        ),
                        DataCell(
                          Text(p["c_name"].toString()),
                        ),
                        DataCell(
                          Text(p["ex_rate"].toString()),
                        ),
                        DataCell(
                          Text(p["get_rate"].toString()),
                        ),
                        DataCell(
                          Text(p["rt_rate"].toString()),
                        ),
                        DataCell(
                          Text(p["totsal"].toString()),
                        ),
                        DataCell(
                          Text(
                            p["assist"].toString() == null ||
                                    p["assist"].toString().isEmpty ||
                                    p["assist"].toString() == "null"
                                ? " "
                                : p["assist"].toString(),
                          ),
                        ),
                      ],
                    );
                  }).toList()
                  // Add another DataRow for the next set of data
                  ),
            )),
      );
    }

    isEMPreportLoading = false;
    notifyListeners();
  }
///////////////////////////////////////////////////////////////

  getEmployeeReport(BuildContext context, String cid) async {
    var employeeresultList = <String, List<Map<String, dynamic>>>{};
    // var grandtotlist = [];
Size size=MediaQuery.of(context).size;
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          isEMPreportLoading = true;

          notifyListeners();
          Uri url = Uri.parse("$urlglobl/fetch_employee_list_report");
          Map body = {"to_date": "21-11-2023", "company_id": cid};
          // Map body = {"to_date": "21-11-2023", "company_id": "1"};
          print("body----$body");
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          token = localStorage.getString('token') ?? " ";
          http.Response response =
              await http.post(url, body: jsonEncode(body), headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
          var map = json.decode(response.body);
          employeeReportlist.clear();
          for (var item in map["data"]) {
            employeeReportlist.add(item);
          }
          employeeReportWidget(employeeReportlist,size);
          isEMPreportLoading = false;
          notifyListeners();
        } catch (e) {
          // ignore: avoid_print
          print(e);
          return null;
        }
      }
    });
  }

  employeeReportWidget(List<Map<String, dynamic>> emplist,Size size) {
    proReportWidget.clear();

    if (emplist.length == 0) {
      proReportWidget.add(Container(
        height: size.height * 0.6,
        child: Center(
          child: Lottie.asset(
            "assets/nodata.json",
            height: 100,
          ),
        ),
      ));
    } else {
      int i = 0;
      proReportWidget.add(
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Card(
              elevation: 4,
              child: DataTable(
                  headingRowHeight: 45,
                  dataRowMinHeight: 30,
                  dataRowMaxHeight: 35,
                  headingRowColor:
                      MaterialStateColor.resolveWith((states) => Colors.black),
                  decoration: BoxDecoration(color: Colors.white),
                  border: TableBorder.all(
                      width: 0.1, borderRadius: BorderRadius.circular(5)),
                  columns: [
                    DataColumn(
                      label: Text(
                        '',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'EMPLOYEE NAME',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'ADDRESS',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'PHONE',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'TYPE',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.white),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'SALARY',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.white),
                      ),
                    ),
                  ],
                  rows: emplist.map((p) {
                    i++;

                    return DataRow(
                      color: MaterialStateColor.resolveWith(
                          (Set<MaterialState> states) {
                        return p["type_name"] == "Sheff"
                            ? Color.fromARGB(255, 247, 158, 158)
                            : Colors.white;
                      }),
                      cells: [
                        DataCell(
                          Text(i.toString()),
                        ),
                        DataCell(
                          Text(p["c_name"].toString()),
                        ),
                        DataCell(
                          Text(p["address"].toString() == null ||
                                  p["address"].toString().isEmpty ||
                                  p["address"].toString() == "null"
                              ? ""
                              : p["address"].toString()),
                        ),
                        DataCell(
                          Text(p["phone"].toString()),
                        ),
                        DataCell(
                          Text(p["type_name"].toString()),
                        ),
                        DataCell(
                          Text(p["salary"].toString()),
                        ),
                      ],
                    );
                  }).toList()
                  // Add another DataRow for the next set of data
                  ),
            )),
      );
    }
  }
///////////////////////////////////////////////////////////

  getDashboard(BuildContext context, String formattedDate, String cid) async {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          isDashboardLoding = true;
          notifyListeners();
          Uri url = Uri.parse("$urlglobl/load_dash_index");
          Map body = {"company_id": cid, "ind_dt": formattedDate};
          // Map body = {"company_id": "1", "ind_dt": "21-11-2023"};
          // Map body = {"to_date": formattedDate, "company_id": cid};
          print("body----$body");
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          token = localStorage.getString('token') ?? " ";
          http.Response response =
              await http.post(url, body: jsonEncode(body), headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
          dashboardMap = json.decode(response.body);
          dashList.clear();
          print("Dashboard map-----$dashboardMap");
          graphlistdash.clear();
          for (var item in dashboardMap["grph"]) {
            graphlistdash.add(item);
          }
          for (var item in graphlistdash) {
            cnameGRaPList.add(item["c_name"]);
            nosGRaPList.add(item["nos"]);
          }

          print("graph List-----$graphlistdash");
          print("graph List.....cname-----$cnameGRaPList");
          print("graph List.....nos-----$nosGRaPList");
          damagelistdash.clear();
          for (var item in dashboardMap["dmg"]) {
            damagelistdash.add(item);
          }
          qtydata = "";
          for (int i = 0; i < damagelistdash.length; i++) {
            qtydata = damagelistdash[i]["qty"].toString();
          }
          isDashboardLoding = false;
          notifyListeners();
          print("qqqqqqqqqqqqqqqqqqqqqqqqqqqqqq${qtydata}");

          print("damage List-----$damagelistdash");
        } catch (e) {
          // ignore: avoid_print
          print(e);
          return null;
        }
      }
    });
  }

  ////////////////////////////////////////////////////////////
  getInitializeApi(BuildContext context) async {
    var res;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cid = prefs.getString("cid");
    String? user_id = prefs.getString("user_id");

    // print("cid----$cid");
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          Uri url = Uri.parse("$urlglobl/initialize.php");
          Map body = {'c_id': cid, 'user_id': user_id};

          print("jkhdkj-----$body");
          isLoading = true;
          notifyListeners();
          http.Response response = await http.post(
            url,
            body: body,
          );

          var map = jsonDecode(response.body);

          print("init map --$map");
          MenuModel menuModel = MenuModel.fromJson(map);

          tabList.clear();
          customMenuList.clear();
          for (var item in menuModel.tabs!) {
            if (item.menuType == "0") {
              tabList.add(item);
            } else {
              customMenuList.add(item);
            }
          }
          tabId = tabList[0].tabId.toString();
          branches.clear();
          if (map["branchs"] != null && map["branchs"].length > 0) {
            print("haiiiii");
            List sid = map["branchs"][0]["branch_ids"].split(',');
            List sname = map["branchs"][0]["branch_names"].split(',');
            selected = sname[0];
            brId = sid[0];
            print("brId----------$brId");
            for (int i = 0; i < sid.length; i++) {
              Map<String, dynamic> ma = {
                "branch_id": sid[i],
                "branch_name": sname[i]
              };
              print("ma----$ma");
              branches.add(ma);
            }
            print("branches----------------$branches");
            // for (var item in map["branchs"]) {
            //   branches.add(item);
            // }

            // selected = branches[0]["branch_name"];
            // brId = branches[0]["branch_id"];
          }

          print("branches--------$branches");
          print("customMenuList---------------$customMenuList");
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => HomeScreen()),
          // );
          isLoginLoad = false;
          isLoading = false;
          notifyListeners();
        } catch (e) {
          print(e);
          return null;
        }
      }
    });
  }

///////////////////////////////////////////////////////////////////
  setDate(String date1, String date2) {
    fromDate = date1;
    todate = date2;
    print("gtyy----$fromDate----$todate");
    notifyListeners();
  }

///////////////////////////////////////////////////////////////////
  getData() {
    List<Map<String, dynamic>> barListShow = [];
    // list = [
    //   {
    //     "id": "0",
    //     "title": "Sale1",
    //     "sum": "NYY",
    //     "align": "LRR",
    //     "width": "60,20,20",
    //     "data": [
    //       {"date": "4-2022", "Qty": "61703110", "val(k)": "61703110.07"},
    //       {"date": "5-2022", "Qty": "61703110", "val(k)": "61703110.07"},
    //       {"date": "6-2022", "Qty": "61703110", "val(k)": "61703110.07"},
    //     ]
    //   }
    // ];
    list = [
      {
        "id": "0",
        "title": "Sale Report1",
        "sum": "NYY",
        "align": "LRR",
        "width": "60,20,20",
        "data": [
          {"date": "20/10/2022", "amount1": "100", "amount2": "327"},
          {"date": "4/8/2022", "amount1": "200", "amount2": "190"},
          {"date": "2/10/2022", "amount1": "300", "amount2": "206"},
          {"date": "1/2/2022", "amount1": "400", "amount2": "100"},
        ]
      },
      {
        "id": "1",
        "title": "anushak",
        "sum": "NY",
        "align": "LR",
        "width": "60,40",
        "data": [
          {"date": "20/10/2022", "amount2": "100"},
          {"date": "4/8/2022", "amount2": "200"},
          {"date": "2/10/2022", "amount2": "300"},
          {"date": "1/10/2022", "amount2": "100"},
          {"date": "6/8/2022", "amount2": "1000"},
          // {"date": "8/10/2022", "amount2": "400"},
        ]
      },
      // {
      //   "id": "2",
      //   "title": "Sale Report3",
      //   "data": [
      //     {
      //       "date": "20/10/2022",
      //       "amount1": "10",
      //     },
      //     {
      //       "date": "4/8/2022",
      //       "amount1": "200",
      //     },
      //     {
      //       "date": "2/10/2022",
      //       "amount1": "300",
      //     },
      //     {
      //       "date": "1/2/2022",
      //       "amount1": "400",
      //     },
      //   ]
      // },
    ];

    descTextShowFlag = List.generate(list.length, (index) => false);
  }

  //////////////////////////////////////////////////////////////////////////////
  loadReportData(BuildContext context, String tab_id, String? fromdate,
      String? tilldate, String b_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cid = prefs.getString("cid");
    String? user_id = prefs.getString("user_id");
    var map;
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          print("pishkuu---$fromDate----$tilldate----$b_id");
          Uri url = Uri.parse("$urlglobl/load_report.php");
          Map body = {
            "c_id": cid,
            "b_id": b_id,
            'user_id': user_id,
            "tab_id": tab_id,
            "from_date": fromdate,
            "till_date": tilldate
          };
          print("load report body----$body");
          isReportLoading = true;
          notifyListeners();
          // var client = http.Client();
          // try {
          //   var response = await client.post(
          //       Uri.https("trafiqerp.in", '/rapi_xp/load_report.php'),
          //       body: body);
          //   map = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
          //   print("from map------$map");
          //   // var uri = Uri.parse(map['uri'] as String);
          //   // print(await client.get(uri));
          // } finally {
          //   client.close();
          // }
          // http.Response response = await http.post(
          //   url,
          //   body: body,
          // );
          // var map = jsonDecode(response.body);
          // String encodeData = jsonEncode(map);
          // print("json encoded data from gets storage------$encodeData");
          // String key = tab_id.toString() + "key";
          // print("key key-----$key");
          // prefs.setString(key, encodeData);
          // final rawJson = prefs.getString(key) ?? '';
          // var map1 = jsonDecode(rawJson);
          // print("decoded-----$map");
          // list.clear();
          // for (var item in map1) {
          //   list.add(item);
          // }
          // isReportLoading = false;
          // notifyListeners();

          http.Response response = await http.post(
            url,
            body: body,
          );
          var map = jsonDecode(response.body);
          print("load report data------${map}");
          // String jsone = jsonEncode(map);
          // _write(jsone, tab_id);
          // String readVal = await _read();
          // var haa = jsonDecode(readVal);
          // print("nnsnbsn----$haa");
          list.clear();
          if (map != null) {
            for (var item in map) {
              list.add(item);
            }
          }
          listEditor =
              List.generate(list.length, (index) => TextEditingController());
          isReportLoading = false;
          notifyListeners();
        } catch (e) {
          print(e);
          return null;
        }
      }
    });
    notifyListeners();
  }
  // loadReportData(BuildContext context, String tab_id, String? fromdate,
  //     String? tilldate, String b_id) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? cid = prefs.getString("cid");
  //   String? user_id = prefs.getString("user_id");
  //   var map;
  //   NetConnection.networkConnection(context).then((value) async {
  //     if (value == true) {
  //       try {
  //         print("pishkuu---$fromDate----$tilldate----$b_id");
  //         Uri url = Uri.parse("$urlgolabl/load_report.php");
  //         Map body = {
  //           "c_id": cid,
  //           "b_id": b_id,
  //           'user_id': user_id,
  //           "tab_id": tab_id,
  //           "from_date": fromdate,
  //           "till_date": tilldate
  //         };
  //         print("load report body----$body");
  //         isReportLoading = true;
  //         notifyListeners();
  //         var client = http.Client();
  //         try {
  //           var response = await client.post(
  //               Uri.https("trafiqerp.in", '/rapi_xp/load_report.php'),
  //               body: body);
  //           var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
  //           print("decodedResponse---$decodedResponse");
  //           // var uri = Uri.parse(decodedResponse['uri'] as String);
  //           // print(await client.get(uri));
  //           list.clear();
  //           if (decodedResponse != null) {
  //             for (var item in decodedResponse) {
  //               list.add(item);
  //             }
  //           }
  //           isReportLoading = false;
  //           notifyListeners();
  //         } finally {
  //           client.close();
  //         }
  //       } catch (e) {
  //         print(e);
  //         return null;
  //       }
  //     }
  //   });
  //   notifyListeners();
  // }

  /////////////////////////////////////////////////////////
  loaclStorageData(List<Map<String, dynamic>> list1) async {
    print("listtt---------$list");
    list.clear();

    for (var item in list1) {
      list.add(item);
    }
    notifyListeners();
    // list = list1;
    print("listtt-cccc--------$list");
    notifyListeners();
  }

////////////////////////////////////////////////////////////////
  setShowHideText(bool value, int index) {
    print("bbdsbd-----$value");
    descTextShowFlag[index] = value;
    notifyListeners();
  }

  /////////////////////////////////////////////////////////////////
  getBarData(List<dynamic> listTest) {
    print("listTest----$listTest");
    List<Map<String, dynamic>> listMap = [];
    Map<String, dynamic> finalList = {};
    List<Map<String, dynamic>> barDataList = [];
    Map<String, dynamic> barDataMap = {};
    // List listTest = [
    //   {"date": "20/10/2022", "amount1": "100", "amount2": "327"},
    //   {"date": "4/8/2022", "amount1": "200", "amount2": "190"},
    //   {"date": "2/10/2022", "amount1": "300", "amount2": "206"},
    //   {"date": "1/2/2022", "amount1": "400", "amount2": "100"},
    // ];
    int c = listTest[0].length;
    Map tempMap = {};
    List<Map<String, dynamic>> data = [];
    for (int j = 1; j < c; j++) {
      data = [];
      barColor = [];
      for (int i = 0; i < listTest.length; i++) {
        // data.add(listTest[i]);
        tempMap = listTest[i];
        String domain = tempMap.values.elementAt(0);
        double measure = double.parse(tempMap.values.elementAt(j));
        id = tempMap.keys.elementAt(j);
        barColor.add(id);
        // String _string = StringToHex.toHexString(sCon);
        Map<String, dynamic> mapTest = {"domain": domain, "measure": measure};
        data.add(
            {"domain": domain, "measure": measure, "colorId": colorList[j]});
      }

      barDataList.add({
        "id": id,
        "data": data,
      });
    }

    print("dnzsndsm-------$barDataList");
    graphMap = {"barData": barDataList};
    print("graphMap----$graphMap");

    return barDataList;
    // reportjson = jsonEncode(graphMap);
  }

  //////////////////////////////////////////////////////////////
  getLegends(List<dynamic> l, String title) {
    Map<String, dynamic> c = {};
    colorList.clear();

    print("from-----$l---");
    listColor.clear();
    legends = [];
    int keyIndex = 0;
    l[0].keys.forEach((key) {
      print("key----$key");
      int key1 = keyIndex * 1215;
      // textToColor(key, title);
      Color color1 = textToColor(key1.toString(), title, key);
      c = {
        key: color1,
      };
      // listColor.add(c);
      legends.add(key);
      keyIndex = keyIndex + 1;
    });

    print("color and id----$listColor");
  }

/////////////////////////////////////////////////////////////////
  // setColor(Color color, String id) {
  //   print("idd---------$color----$id");
  //   // if (idd != id) {
  //   //   print("cdfk-----$color");
  //   //   legendList.add({'id': id, 'color': color});
  //   //   idd = id;
  //   // }
  //   if (colorDup != color) {
  //     colorList.add(color);
  //     colorDup = color;
  //   }

  //   // notifyListeners();
  // }

/////////////////////////////////////////////////////////////////
  textToColor(String id, String title, String key) {
    DateTime date = DateTime.now();
    print("date---$id---$date");
    String sdte = DateFormat('ddMM').format(date);
    print("iso ----${sdte}");
    String reverseId = id.split('').reversed.join('');
    String sCon = reverseId + sdte + title;
    try {
      generatedColor = Color((Random().nextDouble() * 0xFF4d47c).toInt() << 0)
          .withOpacity(1);
      // _string = StringToHex.toHexString(sCon);
      // generatedColor = Color(StringToHex.toColor(_string));
      // generatedColorInt = StringToHex.toColor(_string);
      print("_string---$generatedColorInt--$_string----$generatedColor");
    } catch (e) {
      print("exception-----$e");
      String sCon2 = id + "1994";
      String reversed = sCon2.split('').reversed.join('');
      _string = StringToHex.toHexString(reversed);
      generatedColor = Color(StringToHex.toColor(_string));
      // generatedColorInt = StringToHex.toColor(_string);
    }
    var hex = '#${generatedColor!.value.toRadixString(16)}';
    colorList.add(hex);
    // listColor.add(generatedColor!);
    print("colorList--------$colorList");
    return generatedColor;
  }

/////////////////////////////////////////////////////////////////
  setDropdowndata(String s) {
    brId = s;
    for (int i = 0; i < branches.length; i++) {
      if (branches[i]["branch_id"] == s) {
        selected = branches[i]["branch_name"];
      }
    }
    print("s------$s");
    notifyListeners();
  }

  setMenuClick(bool value) {
    menuClick = value;
    print("menu click------$menuClick");

    notifyListeners();
  }

  setMenuindex(String ind) {
    menu_index = ind;
    tab_index = ind;
    print("mnadmn------$tab_index");
    notifyListeners();
  }

  setCustomReportIndex(String inde) {
    customIndex = inde;
    print("customIndex------$customIndex");
    notifyListeners();
  }

  setDateCriteria(String inde) {
    date_criteria = inde;
    print("date_criteria------$date_criteria");
    notifyListeners();
  }

  setClicked(String clik) {
    clicked = clik;
    notifyListeners();
  }

  getProducts(
    BuildContext context,
  ) {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? branchId = prefs.getString("branch_id");
          String? userId = prefs.getString("user_id");
          Uri url = Uri.parse("$urlglobl/load_report.php");
          Map body = {
            'staff_id': userId,
            'branch_id': branchId,
          };
          // ignore: avoid_print
          print("menu body--$body");
          isLoading = true;
          notifyListeners();

          productList = [
            {"id": "1", "item": "cool cake", "stock": "200"},
            {"id": "2", "item": "groundnut", "stock": "200"},
            {"id": "3", "item": "sugar", "stock": "200"},
            {"id": "4", "item": "tool dall organic", "stock": "200"},
            {"id": "5", "item": "garlic luduva", "stock": "200"},
            {"id": "6", "item": "moong dall", "stock": "200"}
          ];
          // http.Response response = await http.post(url, body: body);
          // var map = jsonDecode(response.body);
          // // ignore: avoid_print
          // print("map----$map");
          // productList.clear();
          // for (var item in map) {
          //   productList.add(item);
          // }
          isLoading = false;
          notifyListeners();
        } catch (e) {
          // return null;
          return [];
        }
      }
    });
  }

  productSearchHistory(BuildContext context, String text) {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          issearching = true;
          notifyListeners();
          if (text.isNotEmpty) {
            isSearch = true;
            notifyListeners();
            newList = productList
                .where((e) =>
                    e["item"].contains(text) || e["item"].startsWith(text))
                .toList();
          } else
            newList = productList;
          issearching = false;
          notifyListeners();
          print("new list----$newList");
        } catch (e) {
          // return null;
          return [];
        }
      }
    });
  }

  // _write(String text, String filename) async {
  //   print("bhjjhd ---$text");
  //   final Directory directory = await getApplicationDocumentsDirectory();
  //   final File file = File('${directory.path}/$filename.txt');
  //   print("textbbb----$text");
  //   await file.writeAsString(text);
  // }

  Future<String> _read() async {
    String? text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/my_file.txt');
      text = await file.readAsString();
      print(" read file ---- $text");
    } catch (e) {
      text = "";
      print("Couldn't read file");
    }
    return text;
  }

  setIssearch(bool val) {
    isSearch = val;
    notifyListeners();
  }
}
