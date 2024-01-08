// import 'package:bakestory_report/Controller/controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class DateFind {
//   DateTime currentDate = DateTime.now();
//   DateTime defaultDate = DateTime.now();

//   // String? formattedDate;
//   String? fromDate;
//   String? toDate;
//   String? crntDateFormat;
//   String? specialField;
//   String? gen_condition;

//   Future selectDateFind(BuildContext context, String dateType) async {
//     crntDateFormat = DateFormat('dd-MM-yyyy').format(currentDate);
//     var pickedDate = await DatePicker.showSimpleDatePicker(
      
//       context,
//       // initialDate: DateTime(1994),
//       firstDate: DateTime(2020),
//       // lastDate: DateTime.now(),
//       dateFormat: "dd-MMMM-yyyy",

//       // locale: DateTimePickerLocale.in,
//       looping: false,
//     );
//     if (pickedDate != null) {
//       // setState(() {
//       currentDate = pickedDate;
//       // });
//     } else {
//       print("please select date");
//     }

//     if (dateType == "from date") {
//       print("curnt date----$currentDate");
//       fromDate = DateFormat('dd-MM-yyyy').format(currentDate);
//       if (toDate == null) {
//         toDate = DateFormat('dd-MM-yyyy').format(defaultDate);
//       }
//     }
//     if (dateType == "to date") {
//       toDate = DateFormat('dd-MM-yyyy').format(currentDate);
//       if (fromDate == null) {
//         fromDate = DateFormat('dd-MM-yyyy').format(defaultDate);
//       }
//     }

//     print("fromdate-----$fromDate---$toDate");
//     // Provider.of<Controller>(context, listen: false).fromDate=fromDate;
//     if (fromDate != null && toDate != null) {
//       Provider.of<Controller>(context, listen: false)
//           .setDate(fromDate!, toDate!);
//     }
//     toDate = toDate == null
//         ? Provider.of<Controller>(context, listen: false).todate.toString()
//         : toDate.toString();
//   }
// }
