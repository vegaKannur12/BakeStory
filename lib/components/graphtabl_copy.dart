// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:trafiqxpreports/bottomSheet/detail.dart';
// import 'package:trafiqxpreports/components/commonColor.dart';

// class GraphDataTable extends StatefulWidget {
//   var decodd;
//   GraphDataTable({required this.decodd});

//   @override
//   State<GraphDataTable> createState() => _GraphDataTableState();
// }

// class _GraphDataTableState extends State<GraphDataTable> {
//   int _currentSortColumn = 0;
//   bool _isSortAsc = true;
//   DetailedInfoSheet info = DetailedInfoSheet();
//   Map<String, dynamic> mapTabledata = {};
//   List<String> tableColumn = [];
//   Map<String, dynamic> valueMap = {};
//   List<Map<dynamic, dynamic>> newMp = [];
//   List<dynamic> rowMap = [];
//   double? datatbleWidth;
//   final ScrollController _scrollController = ScrollController();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     if (widget.decodd != null) {
//       mapTabledata = json.decode(widget.decodd);
//       print("shrinked   mapTabledata---${mapTabledata}");
//     } else {
//       print("null");
//     }
//     rowMap = mapTabledata["data"];
//     mapTabledata["data"][0].forEach((key, value) {
//       tableColumn.add(key);
//     });
//     newMp.clear();
//     calculateSum(mapTabledata["data"], mapTabledata["data"][0].length,
//         mapTabledata["sum"]);
//     rowMap.forEach((element) {
//       print("element-----$element");
//       newMp.add(element);
//     });
//     print("newMp---${newMp}");
//   }

// //////////////////////////////////////////////////////////////////////////////
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     datatbleWidth = size.width * 0.95;
//     print(
//         "screen width-----${size.width}------datatble width-----$datatbleWidth");
//     return Center(
//       child: Container(
//         // alignment: Alignment.center,
//         width: datatbleWidth,
//         child: Scrollbar(
//           controller: _scrollController,
//           child: SingleChildScrollView(
//             controller: _scrollController,
//             scrollDirection: Axis.horizontal,
//             child: DataTable(
//               showCheckboxColumn: false,

//               columnSpacing: 7,
//               headingRowHeight: 40,
//               dataRowHeight: 35,
//               horizontalMargin: 5,
//               // sortColumnIndex: _currentSortColumn,
//               // sortAscending: _isSortAsc,
//               // decoration: BoxDecoration(color: P_Settings.bar1Color),
//               // border: TableBorder.all(
//               //   color: P_Settings.bar1Color,
//               // ),
//               columns: getColumns(tableColumn, mapTabledata["align"],
//                   mapTabledata["width"], mapTabledata["sum"]),
//               rows: getRowss(newMp, mapTabledata["align"],
//                   mapTabledata["width"], mapTabledata["sum"]),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   ///////////////////////////////////////////////////
//   List<DataColumn> getColumns(
//       List<String> columns, String alignment, String width, String sum) {
//     String behv;
//     String colsName;
//     double colwidth = 0.0;
//     List<DataColumn> datacolumnList = [];
//     print("alignment --------${rowMap}");
//     List<String> ws = width.split(',');

//     for (int i = 0; i < columns.length; i++) {
//       if (ws.length == 0) {
//         colwidth = (datatbleWidth! / columns.length);
//       } else {
//         colwidth = (datatbleWidth! * double.parse(ws[i]) / 100);
//       }
//       colwidth = colwidth * 0.94;
//       datacolumnList.add(DataColumn(
//         // onSort: (columnIndex, _) {
//         //   setState(() {
//         //     _currentSortColumn = columnIndex;
//         //     if (_isSortAsc) {
//         //       newMp.sort((a, b) => b[columns[0]].compareTo(a[columns[0]]));
//         //     } else {
//         //       newMp.sort((a, b) => a[columns[0]].compareTo(b[columns[0]]));
//         //     }
//         //     _isSortAsc = !_isSortAsc;
//         //   });
//         // },
//         label: ConstrainedBox(
//           constraints: BoxConstraints(minWidth: colwidth, maxWidth: colwidth),
//           child: Padding(
//             padding: EdgeInsets.all(0.0),
//             child: Text(columns[i].toUpperCase(),
//                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
//                 textAlign:
//                     alignment[i] == "L" ? TextAlign.left : TextAlign.right),
//           ),
//         ),
//       ));
//     }
//     return datacolumnList;
//     // return columns.map((String column) {
//     //   return DataColumn(
//     //     label: ConstrainedBox(
//     //       constraints: BoxConstraints(minWidth: 90, maxWidth: 90),
//     //       child: Padding(
//     //         padding: EdgeInsets.all(0.0),
//     //         child: Text(column.toUpperCase(),
//     //             style: TextStyle(fontSize: 12), textAlign: TextAlign.right),
//     //       ),
//     //     ),
//     //   );
//     // }).toList();
//   }

//   ////////////////////////////////////////////////////////////////
//   List<DataRow> getRowss(
//       List<Map<dynamic, dynamic>> row, String align, String width, String sum) {
//     print("rowjsjfkd-----$row");
//     List<DataRow> items = [];

//     var itemList = newMp;
//     for (var r = 0; r < itemList.length; r++) {
//       items.add(DataRow(
//           // onSelectChanged: (selected) {
//           //   if (selected!) {

//           //   }
//           // },
//           color: r == itemList.length - 1
//               ? MaterialStateProperty.all(P_Settings.sumColor)
//               : MaterialStateProperty.all(P_Settings.rowColor),
//           cells: getCelle(itemList[r], align, width, sum)));
//     }
//     return items;

//     // return newMp.map((row) {
//     //   return DataRow(
//     //     cells: getCelle(row),
//     //   );
//     // }).toList();
//   }

//   //////////////////////////////////////////////////////////////
//   List<DataCell> getCelle(
//       Map<dynamic, dynamic> data, String alignment, String width, String sum) {
//     String behv;
//     String colsName;

//     String? dval;
//     double colwidth = 0.0;
//     print("data--$data");
//     List<DataCell> datacell = [];
//     List<String> ws = width.split(',');

//     print("data-------$data");
//     String text = data.values.elementAt(0);
//     for (var i = 0; i < tableColumn.length; i++) {
//       if (ws.length == 0) {
//         colwidth = (datatbleWidth! / tableColumn.length);
//       } else {
//         colwidth = (datatbleWidth! * double.parse(ws[i]) / 100);
//       }
//       colwidth = colwidth * 0.94;
//       data.forEach((key, value) {
//         if (tableColumn[i] == key) {
//           if (sum[i] == "Y") {
//             print("fbfb------${value.runtimeType}");
//             double d = double.parse(value);
//             dval = d.toStringAsFixed(2);
//           } else {
//             dval = value;
//             // double d = double.parse(value);
//             // dval = d.toStringAsFixed(2);
//           }
//           datacell.add(
//             DataCell(
//               // onTap: () {

//               //   info.showInfoSheet(context, text);
//               // },
//               Container(
//                 constraints:
//                     BoxConstraints(minWidth: colwidth, maxWidth: colwidth),
//                 // width: 70,
//                 alignment: alignment[i] == "L"
//                     ? Alignment.centerLeft
//                     : Alignment.centerRight,
//                 // alignment: Alignment.centerRight,
//                 child: Padding(
//                   padding: EdgeInsets.all(0.0),
//                   // padding: behv[1] == "L"? EdgeInsets.only(left:0.3):EdgeInsets.only(right:0.3),
//                   child: Text(
//                     dval.toString(),
//                     style: TextStyle(fontSize: 14),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }
//       });
//     }
//     print(datacell.length);
//     return datacell;
//   }

//   /////////////////////////////////////////////////////////////////////
//   calculateSum(List<dynamic> element, int c, String isSum) {
//     Map map = {};
//     Map finalmap = {};
//     print("dynamic elemnt-----$element--$isSum");
//     double sum = 0.0;
//     String? key;
//     for (int i = 0; i < c; i++) {
//       if (isSum[i] == "Y") {
//         for (int j = 0; j < element.length; j++) {
//           key = element[j].keys.elementAt(i);
//           double d = double.parse(element[j].values.elementAt(i));
//           print("zjsnjzsnd-----${d}");
//           sum = sum + d;
//         }
//         map[key] = sum.toStringAsFixed(2);
//         sum = 0.0;
//       } else {
//         map[element[i].keys.elementAt(i)] = "";
//       }
//     }
//     element.add(map);
//     print("sum-----$element");
//   }
// }
