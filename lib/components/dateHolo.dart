import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';

class DateHome extends StatefulWidget {
  const DateHome({super.key});

  @override
  State<DateHome> createState() => _DateHomeState();
}

class _DateHomeState extends State<DateHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text("open picker dialog"),
              onPressed: () async {
                var datePicked = await DatePicker.showSimpleDatePicker(
                  context,
                  initialDate: DateTime(1994),
                  firstDate: DateTime(1960),
                  lastDate: DateTime(2012),
                  dateFormat: "dd-MMMM-yyyy",
                  locale: DateTimePickerLocale.th,
                  looping: true,
                );

                final snackBar =
                    SnackBar(content: Text("Date Picked $datePicked"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
            ElevatedButton(
              child: Text("Show picker widget"),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => DateHolo()));
              },
            )
          ],
        ),
      ),
    );
  }
}

class DateHolo extends StatefulWidget {
  const DateHolo({super.key});

  @override
  State<DateHolo> createState() => _DateHoloState();
}

class _DateHoloState extends State<DateHolo> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: [
              Colors.purple,
              Colors.purple,
            ],
            stops: const [0.7, 1.0],
          )),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: DatePickerWidget(
                    looping: false, // default is not looping
                    firstDate: DateTime.now(), //DateTime(1960),
                    //  lastDate: DateTime(2002, 1, 1),
//              initialDate: DateTime.now(),// DateTime(1994),
                    dateFormat:
                        // "MM-dd(E)",
                        "dd/MMMM/yyyy",
                    // locale: DatePicker.localeFromString('th'),
                    onChange: (DateTime newDate, _) {
                      setState(() {
                        _selectedDate = newDate;
                      });
                      print(_selectedDate);
                    },
                    pickerTheme: DateTimePickerTheme(
                      backgroundColor: Colors.transparent,
                      itemTextStyle:
                          TextStyle(color: Colors.white, fontSize: 19),
                      dividerColor: Colors.white,
                    ),
                  ),
                ),
                Text(
                  "${_selectedDate ?? ''}",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
