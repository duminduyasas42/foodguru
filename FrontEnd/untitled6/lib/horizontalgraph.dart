import 'package:flutter/material.dart';

class Data {
  final int units;
  final Color color;

  Data({required this.units, required this.color});
}

class HorizontalGraph extends StatefulWidget {
  List data;
  HorizontalGraph({super.key, required this.data});
  @override
  State<HorizontalGraph> createState() => _HorizontalGraphState();
}

class _HorizontalGraphState extends State<HorizontalGraph> {
  final double gap = 0.0;
  
  
 
  
  List<double> get processedStops {
    double totalGapsWith = gap * (widget.data.length - 1);
    double totalData = widget.data.fold(0, (a, b) => a + b.units);
    return widget.data.fold(<double>[0.0], (List<double> l, d) {
      l.add(l.last + d.units * (1 - totalGapsWith) / totalData);
      l.add(l.last);
      l.add(l.last + gap);
      l.add(l.last);
      return l;
    })
      ..removeLast()
      ..removeLast()
      ..removeLast();
  }

  List<Color> get processedColors {
    return widget.data.fold(
        <Color>[],
        (List<Color> l, d) => [
              ...l,
              d.color,
              d.color,
              Colors.transparent,
              Colors.transparent,
            ])
      ..removeLast()
      ..removeLast();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(500),
        ),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: processedStops,
          colors: processedColors,
        ),
      ),
    );
  }
}
