import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:untitled6/foodrecognitionpage.dart';

class DataItem {
  final double value;
  final String label;
  final Color color;
  DataItem(this.color, this.value, this.label);
}

class DonutGrapgh extends StatefulWidget {
  final List<DataItem> dataset = [
    DataItem(Colors.redAccent, 0.4, "Protein"),
    DataItem(Colors.orangeAccent, 0.2, "Fats"),
    DataItem(Colors.yellow, 0.1, "Carbs"),
  ];
  final foodDetialsData;

  DonutGrapgh({super.key, required this.foodDetialsData});

  @override
  State<DonutGrapgh> createState() => _DonutGrapghState();
}

class _DonutGrapghState extends State<DonutGrapgh> {
  List<DataItem> dataset = [
    DataItem(Colors.redAccent, 0.4, "Protein"),
    DataItem(Colors.orangeAccent, 0.3, "Fats"),
    DataItem(Colors.yellow, 0.0, "Carbs"),
  ];
  late Timer timer;
  double fullAngle = 0.0;
  double secondsToComplete = 5.0;
  void initState() {
    dataset = [
      DataItem(
          Colors.redAccent,
          (double.parse(widget.foodDetialsData.protein) /
              (double.parse(widget.foodDetialsData.protein) +
                  double.parse(widget.foodDetialsData.carbs) +
                  double.parse(widget.foodDetialsData.fats)))*0.7,
          "Protein"),
      DataItem(
          Colors.orangeAccent,
          (double.parse(widget.foodDetialsData.fats) /
              (double.parse(widget.foodDetialsData.protein) +
                  double.parse(widget.foodDetialsData.carbs) +
                  double.parse(widget.foodDetialsData.fats)))*0.7,
          "Fats"),
      DataItem(
          Colors.yellow,
          (double.parse(widget.foodDetialsData.carbs) /
              (double.parse(widget.foodDetialsData.protein) +
                  double.parse(widget.foodDetialsData.carbs) +
                  double.parse(widget.foodDetialsData.fats)))*0.7,
          "Carbs"),
    ];
    timer = Timer.periodic(const Duration(milliseconds: 1000 ~/ 60), (timer) {
      setState(() {
        fullAngle += 360.0 / (secondsToComplete * 1000 ~/ 60);
        if (fullAngle >= 360.0) {
          fullAngle = 360.0;
          timer.cancel();
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CustomPaint(
      child: Container(),
      painter: DonutChartPainter(dataset, fullAngle,widget.foodDetialsData),
    ));
  }
}

final linePaint = Paint()
  ..color = Colors.white
  ..strokeWidth = 1.0
  ..style = PaintingStyle.stroke;

final middlePaint = Paint()
  ..color = Colors.white
  ..style = PaintingStyle.fill;

class DonutChartPainter extends CustomPainter {
  final List<DataItem> dataSet;
  final double fullAngle;
  final FoodDetialsData foodDetialsData;

  DonutChartPainter(this.dataSet, this.fullAngle, this.foodDetialsData);

  static const labelStyle = TextStyle(
      color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold);
  final midPaint = Paint()
    ..color = Colors.transparent!
    ..style = PaintingStyle.fill;
  final midPaint1 = Paint()
    ..color = Colors.greenAccent!
    ..style = PaintingStyle.fill;
  static const textBigStyle = TextStyle(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30.0);

  @override
  void paint(Canvas canvas, Size size) {
    final linePath = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final c = Offset(size.width / 2.0, size.height / 2.0);
    final radius = size.width * 0.9;
    final rect = Rect.fromCenter(center: c, width: radius, height: radius);

    var startAngle = 2.52;
    for (var di in dataSet) {
      final sweepAngle = di.value * fullAngle / 180 * pi;
      drawSectors(di, canvas, rect, startAngle, sweepAngle);
      startAngle += sweepAngle;
    }

    startAngle = 2.52;
    for (var di in dataSet) {
      final sweepAngle = di.value * fullAngle / 180 * pi;
      if (di.value != 0) {
        drawLabels(
          canvas,
          c,
          radius,
          startAngle,
          sweepAngle,
          di.label,
        );
      }

      startAngle += sweepAngle;
    }

    canvas.drawCircle(c, radius * 0.3, midPaint1);
    drawTextCentered(
        canvas, c, foodDetialsData.name, textBigStyle, radius * 0.5, (Size sz) {});
  }

  TextPainter measureText(String string, TextStyle textStyle, double maxWidth,
      TextAlign textAlign) {
    final span = TextSpan(text: string, style: textStyle);
    final tp = TextPainter(
        text: span, textAlign: textAlign, textDirection: TextDirection.ltr);
    tp.layout(minWidth: 0, maxWidth: maxWidth);
    return tp;
  }

  Size drawTextCentered(Canvas canvas, Offset position, String text,
      TextStyle textStyle, double maxWidth, Function(Size size) bgCb) {
    final textPainter =
        measureText(text, textStyle, maxWidth, TextAlign.center);
    final pos =
        position + Offset(-textPainter.width / 2.0, -textPainter.height / 2.0);
    bgCb(textPainter.size);
    textPainter.paint(canvas, pos);
    return textPainter.size;
  }

  void drawLines(double radius, double startAngle, Offset c, Canvas canvas,
      Paint linePath) {
    final lineLength = radius / 2;
    final dx = lineLength * cos(startAngle);
    final dy = lineLength * sin(startAngle);
    final p2 = c + Offset(dx, dy);
    canvas.drawLine(c, p2, linePath);
  }

  void drawSectors(DataItem di, Canvas canvas, Rect rect, double startAngle,
      double sweepAngle) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = di.color;
    canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
  }

  void drawLabels(Canvas canvas, Offset c, double radius, double startAngle,
      double sweepAngle, String label) {
    final r = radius * 0.4;
    final dx = r * cos(startAngle + sweepAngle / 2.0);
    final dy = r * sin(startAngle + sweepAngle / 2.0);
    final position = c + Offset(dx, dy);
    drawTextCentered(canvas, position, label, labelStyle, 100.0, (Size size) {
      final rect = Rect.fromCenter(
          center: position, width: size.width + 5, height: size.height + 5);
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(5));
      canvas.drawRRect(rrect, midPaint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
