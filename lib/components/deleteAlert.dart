

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DeleteAlert {
  DateTime now = DateTime.now();
  TextEditingController controller = TextEditingController();


  Future buildPopupDialog(BuildContext context, Size size, String table,String content ){
    controller.clear();
    String formattedDate = DateFormat('yyyyMMdd').format(now);
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return AlertDialog(
            content: Container(
              height: size.height * 0.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Enter Key  : "),
                      Container(
                        width: size.width * 0.3,
                        child: TextField(
                          controller: controller,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                      // style: ElevatedButton.styleFrom(
                      //     primary: ColorThemeComponent.appbar),
                      onPressed: () async {
                        if (formattedDate == controller.text) {
                          print("correct");
                          // await VstockDB.instance
                          //     .deleteFromTableCommonQuery(table, "");
                               Navigator.pop(ctx);
                          // msgAlert.buildPopupDialog(context, size, content);
                        }
                      },
                      child: Text("Delete")),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ElevatedButton(
                        // style: ElevatedButton.styleFrom(
                        //     primary: ColorThemeComponent.appbar),
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                        child: Text("Cancel")),
                  )
                ],
              ),
            ],
          );
        });
  }
}
