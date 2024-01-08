import 'package:bakestory_report/PROVIDER/providerDemo.dart';
import 'package:bakestory_report/controller/controller.dart';
import 'package:bakestory_report/screens/REPORTS/m_damage.dart';
import 'package:bakestory_report/screens/REPORTS/m_report.dart';
import 'package:bakestory_report/screens/REPORTS/daily_prod.dart';
import 'package:bakestory_report/screens/REPORTS/damage_prod.dart';
import 'package:bakestory_report/screens/REPORTS/employee.dart';
import 'package:bakestory_report/screens/REPORTS/monthlyPro.dart';
import 'package:bakestory_report/screens/auth/loginScreen.dart';
import 'package:bakestory_report/screens/homeScreen.dart';
import 'package:bakestory_report/screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

List<DrawerlistClass> drawer_list = [
  DrawerlistClass(
      title: "Home",
      icon: Image.asset(
        "assets/home.png",
        color: Colors.black54,
      ),
      menuindex: 0),
  DrawerlistClass(
      title: "Daily Production Report",
      icon: Image.asset(
        "assets/prod.png",
        color: Colors.black54,
      ),
      menuindex: 1),
  DrawerlistClass(
      title: "Monthly Production Report",
      icon: Image.asset(
        "assets/leave.png",
        color: Colors.black54,
      ),
      menuindex: 2),
  DrawerlistClass(
      title: "Daily Damage Report",
      icon: Image.asset(
        "assets/dam.png",
        color: Colors.black54,
      ),
      menuindex: 2),
  DrawerlistClass(
      title: "Monthly Damage Report",
      icon: Image.asset(
        "assets/dam.png",
        color: Colors.black54,
      ),
      menuindex: 2),
  DrawerlistClass(
      title: "Employee Report",
      icon: Image.asset(
        "assets/employee.png",
        color: Colors.black54,
      ),
      menuindex: 2),
  DrawerlistClass(
      title: "Monthly Report",
      icon: Image.asset(
        "assets/calendar.png",
        color: Colors.black54,
      ),
      menuindex: 2),
  DrawerlistClass(
      title: "Logout",
      icon: Image.asset(
        "assets/leave.png",
        color: Colors.black54,
      ),
      menuindex: 2),
];

class DrawerlistClass {
  final String title;
  final Image icon;
  final int menuindex;
  DrawerlistClass({
    required this.title,
    required this.icon,
    required this.menuindex,
  });
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  void initState() {
    // TODO: implement initState
    // Provider.of<Controller>(context, listen: false)
    //     .getDailyProductionReport(context);
    // Provider.of<Controller>(context, listen: false)
    //     .getDamageProductionReport(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String usr = Provider.of<ProviderDemo>(context).fav;
    print("UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUu.....$usr");
    int i = -1;
    return Consumer(builder: (BuildContext context, value, Widget? child) {
      return Drawer(
          backgroundColor: Colors.white,
          width: 300,
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                          height: 50,
                          width: 100,
                          child: Image.asset("assets/user.png")),
                      Text(
                        usr,
                        style: GoogleFonts.ptSerif(
                            fontSize: 25, color: Colors.blue[900]),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  const Divider(),
                  ...List.generate(
                      drawer_list.length,
                      (index) => Column(
                            children: [
                              InkWell(
                                child: ListTile(
                                  title: Text(
                                    drawer_list[index].title,
                                    style: GoogleFonts.ptSerif(),
                                  ),
                                  leading: index > 6
                                      ? Image.asset(
                                          "assets/leave.png",
                                          color: Colors.black54,height: 30,width: 25,
                                        )
                                      : SizedBox(
                                        height: 25,width: 25,
                                        child: Icon(Icons.circle,color:Colors.black54 ,size: 10,)),
                                  // trailing: SizedBox(
                                  //     height: 35,
                                  //     width: 40,
                                  //     child: drawer_list[index].icon),
                                ),
                                onTap: () {
                                  setState(() {
                                    i = index;
                                    if (i == 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()),
                                      );
                                    } else if (i == 1) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DailyProduct()),
                                      );
                                    } else if (i == 2) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Report()),
                                      );
                                    } else if (i == 3) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DamageProd()),
                                      );
                                    } else if (i == 4) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MonthlyDamage()),
                                      );
                                    } else if (i == 5) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EmployReport()),
                                      );
                                    } else if (i == 6) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MonthlyPro()),
                                      );
                                    } else {
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const LoginScreen(),
                                        ),
                                        (Route route) => false,
                                      );
                                    }
                                  });
                                },
                              ),
                              const Divider(),
                            ],
                          ))
                ],
              ),
            ),
          ));
    });
  }
}
