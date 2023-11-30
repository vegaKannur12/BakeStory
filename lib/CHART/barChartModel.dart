// import 'package:flutter/material.dart';


// class BarChartAPI extends StatefulWidget {
//   const BarChartAPI({Key? key}) : super(key: key);

//   @override
//   State<BarChartAPI> createState() => _BarChartAPIState();
// }

// class _BarChartAPIState extends State<BarChartAPI> {
//   List<GenderModel> genders = [];
//   bool loading = true;
//   // NetworkHelper _networkHelper = NetworkHelper();

//   @override
//   void initState() {
//     super.initState();
//     // getData();
//   }

//   // void getData() async {
//   //   var response = await _networkHelper.get(
//   //       "https://api.genderize.io/?name[]=balram&name[]=deepa&name[]=saket&name[]=bhanu&name[]=aquib");
//   //   List<GenderModel> tempdata = genderModelFromJson(response.body);
//   //   setState(() {
//   //     genders = tempdata;
//   //     loading = false;
//   //   });
//   // }

//   List<charts.Series> _createSampleData() {
//     return [
//       charts.Series(
//         data: genders,
//         id: 'sales',
//         colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
//         domainFn:genderModel.name,
//         measureFn:genderModel.count,
//       )
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Bar Chart With API"),
//       ),
//       body: Center(
//         child: loading
//             ? CircularProgressIndicator()
//             : Container(
//                 height: 300,
//                 child: charts.BarChart(
//                   _createSampleData(),
//                   animate: true,
//                 ),
//               ),
//       ),
//     );
//   }
// }