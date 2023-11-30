import 'package:flutter/material.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';

class GenerateRandomColor extends StatefulWidget {
  const GenerateRandomColor({super.key});

  @override
  State<GenerateRandomColor> createState() => _GenerateRandomColorState();
}

class _GenerateRandomColorState extends State<GenerateRandomColor> {
   var color;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Container(height: 200,color: color,),
            ElevatedButton(
                onPressed: () {
                  var options = Options(
                      format: Format.hsl,
                      count: 100,
                      // colorType: ColorType.blue,
                      luminosity: Luminosity.light);
                  color = RandomColor.getColor(options);
                  print("color----$color");
                },
                child: Text("click"))
          ],
        ),
      ),
    );
  }
}
