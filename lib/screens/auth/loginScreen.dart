import 'package:bakestory_report/Helperwidgets/formcontainer.dart';
import 'package:bakestory_report/Helperwidgets/gradientcontainer.dart';
import 'package:bakestory_report/PROVIDER/providerDemo.dart';
import 'package:bakestory_report/controller/controller.dart';
import 'package:bakestory_report/model/logmodel.dart';
import 'package:bakestory_report/utils/validation.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const route = 'LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController unamecontroller = TextEditingController();
  TextEditingController pwdcontroller = TextEditingController();
  late LoginRequestModel loginRequestModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    loginRequestModel = LoginRequestModel();
  }

  ValueNotifier<String> unm = ValueNotifier("");
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 400,width: 200,
                child: Image.asset("assets/lo.png",)),
              _buildForm()],
          ),
        ),
    );
  }

  Widget _buildForm() {
    return FormContainer(
      child: Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(cursorColor:Colors.black ,
            decoration: InputDecoration(
              labelText: 'Username',
              floatingLabelStyle: TextStyle(color: Colors.blue),
              prefixIcon: const Icon(Icons.person),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            ),
           
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'Please Enter Username';
              }
              return null;
            },
            controller: unamecontroller,
            onSaved: (v) => loginRequestModel.username = v!,
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(cursorColor:Colors.black ,
            decoration: InputDecoration(
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                labelText: 'Password',
                floatingLabelStyle: TextStyle(color: Colors.blue),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(hidePassword
                        ?  Icons.visibility_off
                        :Icons.visibility)),
                    
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black))),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'Please Enter Password';
              }
              return null;
            },
            obscureText: hidePassword,
            controller: pwdcontroller,
            onSaved: (v) => loginRequestModel.password = v!,
          ),
          const SizedBox(
            height: 20,
          ),
          ValueListenableBuilder(
            // valueListenable: null,
            builder: (BuildContext context, value, Widget? child) {
              return InkWell(
                onTap: () async {
                  unm.value = unamecontroller.text;
                  //   _askingPhonePermission();
                  //  String imeiNo = await DeviceInformation.deviceIMEINumber;
                  //  print("iimei................$imeiNo");
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (_formKey.currentState!.validate()) {
                    Provider.of<Controller>(context, listen: false).getLogin(
                        unamecontroller.text, pwdcontroller.text, context);
                    Provider.of<ProviderDemo>(context, listen: false)
                        .changevalue(unamecontroller.text);
                  }
                },
                child: Container(
                    height: 45,
                    width: 90,decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(20)),
                    child: 
                        Center(
                          child: Text(
                            "LOGIN",
                            style: GoogleFonts.ptSerif(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        
                    ),
              );
            },
            valueListenable: unm,
          ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _askingPhonePermission() async {
    final PermissionStatus permissionStatus = await _getPhonePermission();
  }

  Future<PermissionStatus> _getPhonePermission() async {
    final PermissionStatus permission = await Permission.phone.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.phone].request();
      return permissionStatus[Permission.phone] ?? PermissionStatus.restricted;
    } else {
      return permission;
    }
  }
}
