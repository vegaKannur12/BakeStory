import 'dart:io';
import 'package:bakestory_report/components/externalDir.dart';
import 'package:bakestory_report/controller/controller.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController keycontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  FocusNode? fieldFocusNode;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? manufacturer;
  String? model;
  String? fp;
  String? textFile;
  ExternalDir externalDir = ExternalDir();
  late String uniqId;

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        manufacturer = deviceData["manufacturer"];
        model = deviceData["model"];
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'manufacturer': build.manufacturer,
      'model': build.model,
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deletemenu();
    initPlatformState();
  }

  deletemenu() async {
    print("delete");
    // await OrderAppDB.instance.deleteFromTableCommonQuery('menuTable', "");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: keycontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                    labelText: 'Company Key',
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: phonecontroller,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                    labelText: 'Phone Number',
                  ),
                ),
              ),

              SizedBox(
                height: 30,
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () async {
                    String deviceInfo = "$manufacturer" + '' + "$model";
                    print("device info-----$deviceInfo");
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => LoginPage()),
                    // );

                    // await OrderAppDB.instance
                    //     .deleteFromTableCommonQuery('menuTable', "");
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (_formKey.currentState!.validate()) {
                      String tempFp1 = await externalDir.fileRead();
                      // String? tempFp1=externalDir.tempFp;

                      // if(externalDir.tempFp==null){
                      //    tempFp="";
                      // }
                      print("tempFp---${tempFp1}");
                      // textFile = await externalDir
                      //     .getPublicDirectoryPath();
                      // print("textfile........$textFile");

                      Provider.of<Controller>(context, listen: false)
                          .postRegistration(keycontroller.text, tempFp1,
                              phonecontroller.text, deviceInfo, context);
                    }
                  },
                  child: Text(
                    'Register',
                    style: GoogleFonts.ptSerif(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
