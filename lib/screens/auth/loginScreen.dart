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

  String? _username, _password;
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
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 270,width: 170,
                child: Image.asset("assets/key.png",color: Colors.black54,)),
              _buildForm()],
          ),
        ),
      ),
    );
  }
  Widget _buildForm() {
    return FormContainer(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min, 
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Username',
              prefixIcon: const Icon(Icons.person),
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
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  icon: Icon(
                      hidePassword ? Icons.visibility : Icons.visibility_off)),
            ),
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
                  child:SizedBox(height: 30,width: 90,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   
                      children: [Text("LOGIN",style: GoogleFonts.ptSerif(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 17,),),
                        Image.asset("assets/log-in.png",height: 20,width: 20,),
                      ],
                    )),);
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
