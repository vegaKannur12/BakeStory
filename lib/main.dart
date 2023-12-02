import 'dart:io';
// import 'package:bakestory_report/Controller/controller.dart';
import 'package:bakestory_report/PROVIDER/providerDemo.dart';
import 'package:bakestory_report/components/commonColor.dart';
import 'package:bakestory_report/controller/controller.dart';
import 'package:bakestory_report/screens/REPORTS/daily_prod.dart';
import 'package:bakestory_report/screens/REPORTS/damage_prod.dart';
import 'package:bakestory_report/screens/REPORTS/employee.dart';
import 'package:bakestory_report/screens/REPORTS/monthlyPro.dart';
import 'package:bakestory_report/screens/homeScreen.dart';
import 'package:bakestory_report/screens/auth/registerScreen.dart';
import 'package:bakestory_report/screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// andra -----company key ---RPF23TYXLRLR
//  user-----shameem,, pwd---123

// pk holdings-----RHVZT0N9LRLR
// user------user,pwd---123
void requestPermission() async {
  var sta = await Permission.storage.request();
  var status = Platform.isIOS
      ? await Permission.photos.request()
      : await Permission.manageExternalStorage.request();
  if (status.isGranted) {
    await Permission.manageExternalStorage.request();
  } else if (status.isDenied) {
    await Permission.manageExternalStorage.request();
  } else if (status.isRestricted) {
    await Permission.manageExternalStorage.request();
  } else if (status.isPermanentlyDenied) {
    await Permission.manageExternalStorage.request();
  }
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  requestPermission();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Controller()),
       ChangeNotifierProvider(create: (context)=>ProviderDemo())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  //  static const routeName = '/mainscreen';
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // String? formattedDate = ModalRoute.of(context)!.settings.arguments.toString();
    return MaterialApp(
      theme: ThemeData(
        primaryColor: P_Settings.purple,
        fontFamily: GoogleFonts.aBeeZee().fontFamily,
      ),
      debugShowCheckedModeBanner: false,

      home:
          // MyApp(),
          // EmployReport(),
          // MonthlyPro(),
          //  DamageProd(),
          // DailyProduct(),
           SplashScreen(),
          // RegisterScreen(),
          // HomeScreen(),
      //  BarChartSample3(),
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('en', 'GB'),
      ],
    );
  }
}
