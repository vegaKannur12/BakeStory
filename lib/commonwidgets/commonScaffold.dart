import 'package:bakestory_report/commoncalender.dart';
import 'package:bakestory_report/screens/drawer/drawerPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MyScaffold extends StatefulWidget {
  final Widget body;
  final bool hasDrawer;
  final String title;
  final Color scBgColor;
  // final Calender row;

  const MyScaffold({
    super.key,
    required this.body,
    this.hasDrawer = false,
    required this.title,
    this.scBgColor = Colors.white,
  });

  @override
  State<MyScaffold> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  }

  String formattedDate = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       
        drawer: widget.hasDrawer ? DrawerPage() : null,
        backgroundColor: widget.scBgColor,
        appBar: AppBar(
          elevation: 3.0,
          centerTitle: true,
          title: Text(widget.title,
              style: GoogleFonts.ptSerif(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
        ),
        body: widget.body,
      ),
    );
  }
}
