import 'package:flutter/material.dart';
import 'package:untitled6/horizontalgraph.dart';
import 'package:intl/intl.dart';

import 'main.dart';

class Nutrition extends StatefulWidget {
  final User user;
  final dataNutrition;
  const Nutrition({super.key, required this.user, required this.dataNutrition});

  @override
  State<Nutrition> createState() => _NutritionState();
}

class _NutritionState extends State<Nutrition> {
  double loginWidth = 0;
  void _onD1Changed() {
    // Code to run when d1 changes
    // Future.delayed(Duration(milliseconds: 100), () {
    //   setState(() {
    //     loginWidth = 400.0;
    //   });
    // });
    Future.delayed(const Duration(milliseconds: 1), () {
      setState(() {
        loginWidth = 400.0;
      });
    });
    print('d1 changed to $loginWidth');
  }

  @override
  void didUpdateWidget(Nutrition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dataNutrition != oldWidget.dataNutrition) {
      setState(() {
        loginWidth = 0.0;
      });
      _onD1Changed();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        loginWidth = 400.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: true
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 8),
                  child: Row(
                    children: [
                      const Text(
                        "Calories",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.black),
                      ),
                      if (widget.dataNutrition.CalariesOver != null ||
                          widget.dataNutrition.CalariesItem != null)
                        const Text(
                          ":",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black),
                        ),
                      if (widget.dataNutrition.CalariesItem != null)
                        Text(
                          " ${widget.dataNutrition.CalariesItem} cals",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.blueAccent),
                        ),
                      if (widget.dataNutrition.CalariesOver != null)
                        Text(
                          " Over ${widget.dataNutrition.CalariesOver} cals",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD50000)),
                        ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: loginWidth == 400
                      ? const Duration(seconds: 1)
                      : const Duration(seconds: 0),
                  width: loginWidth,
                  height: 20,
                  child: HorizontalGraph(
                    data: widget.dataNutrition.data,
                  ),
                ),
                if ((widget.dataNutrition.DailyCaloricNeeds >
                        widget.dataNutrition.DailyCaloricUser) &
                    (widget.dataNutrition.CalariesItem == null))
                  Row(
                    children: [
                      const Text("0",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(
                          flex: widget.dataNutrition.DailyCaloricUser > 0
                              ? widget.dataNutrition.DailyCaloricUser
                              : 1),
                      Text("${widget.dataNutrition.DailyCaloricUser}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.lightBlueAccent)),
                      Spacer(
                          flex: widget.dataNutrition.DailyCaloricNeeds -
                              widget.dataNutrition.DailyCaloricUser),
                      Text(widget.dataNutrition.DailyCaloricNeeds.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                    ],
                  ),
                if ((widget.dataNutrition.DailyCaloricNeeds <
                        widget.dataNutrition.DailyCaloricUser) &
                    (widget.dataNutrition.CalariesItem == null))
                  Row(
                    children: [
                      const Text("0",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(flex: widget.dataNutrition.DailyCaloricNeeds),
                      Text(widget.dataNutrition.DailyCaloricNeeds.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(
                          flex: widget.dataNutrition.DailyCaloricUser -
                              widget.dataNutrition.DailyCaloricNeeds),
                      Text("${widget.dataNutrition.DailyCaloricUser}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD50000))),
                    ],
                  ),
                if ((widget.dataNutrition.DailyCaloricNeeds >
                        widget.dataNutrition.DailyCaloricUser) &
                    (widget.dataNutrition.CalariesItem != null) &
                    ((widget.dataNutrition.DailyCaloricNeeds) >
                        (widget.dataNutrition.DailyCaloricUser +
                            (widget.dataNutrition.CalariesItem ?? 0))))
                  Row(
                    children: [
                      const Text("0",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(
                          flex: widget.dataNutrition.DailyCaloricUser > 0
                              ? widget.dataNutrition.DailyCaloricUser
                              : 1),
                      Text("${widget.dataNutrition.DailyCaloricUser}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.lightBlueAccent)),
                      Spacer(
                          flex: widget.dataNutrition.CalariesItem.round() > 0
                              ? widget.dataNutrition.CalariesItem.round()
                              : 1),
                      Text(
                          "${widget.dataNutrition.DailyCaloricUser + widget.dataNutrition.CalariesItem.round()}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.blueAccent)),
                      Spacer(
                          flex: widget.dataNutrition.DailyCaloricNeeds -
                              widget.dataNutrition.DailyCaloricUser -
                              widget.dataNutrition.CalariesItem.round()),
                      Text(widget.dataNutrition.DailyCaloricNeeds.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                    ],
                  ),
                if ((widget.dataNutrition.DailyCaloricNeeds >
                        widget.dataNutrition.DailyCaloricUser) &
                    (widget.dataNutrition.CalariesItem != null) &
                    (widget.dataNutrition.DailyCaloricNeeds <
                        (widget.dataNutrition.DailyCaloricUser +
                            (widget.dataNutrition.CalariesItem ?? 0))))
                  Row(
                    children: [
                      const Text("0",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(
                          flex: widget.dataNutrition.DailyCaloricUser > 0
                              ? widget.dataNutrition.DailyCaloricUser
                              : 1),
                      Text(widget.dataNutrition.DailyCaloricUser.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.lightBlueAccent)),
                      Spacer(
                          flex: widget.dataNutrition.DailyCaloricNeeds -
                              widget.dataNutrition.DailyCaloricUser),
                      Text((widget.dataNutrition.DailyCaloricNeeds).toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(flex: widget.dataNutrition.CalariesOver ?? 1),
                      Text(
                          "${widget.dataNutrition.DailyCaloricNeeds + widget.dataNutrition.CalariesOver}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.lightBlueAccent)),
                    ],
                  ),
                if ((widget.dataNutrition.DailyCaloricNeeds <
                        widget.dataNutrition.DailyCaloricUser) &
                    (widget.dataNutrition.CalariesItem != null) &
                    (widget.dataNutrition.DailyCaloricNeeds <
                        (widget.dataNutrition.DailyCaloricUser +
                            (widget.dataNutrition.CalariesItem ?? 0))))
                  Row(
                    children: [
                      const Text("0",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(flex: widget.dataNutrition.DailyCaloricNeeds),
                      Text(widget.dataNutrition.DailyCaloricNeeds.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(
                          flex: widget.dataNutrition.DailyCaloricUser -
                              widget.dataNutrition.DailyCaloricNeeds),
                      Text("${widget.dataNutrition.DailyCaloricUser}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD50000))),
                      Spacer(
                          flex: widget.dataNutrition.CalariesItem.round() ?? 1),
                      Text(
                          "${widget.dataNutrition.DailyCaloricUser + widget.dataNutrition.CalariesItem.round()}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD50000))),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 8),
                  child: Row(
                    children: [
                      const Text(
                        "Protien",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.black),
                      ),
                      if (widget.dataNutrition.ProtenOver != null ||
                          widget.dataNutrition.ProtenItem != null)
                        const Text(
                          ":",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black),
                        ),
                      if (widget.dataNutrition.ProtenItem != null)
                        Text(
                          " ${widget.dataNutrition.ProtenItem}g",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFFF1744)),
                        ),
                      if (widget.dataNutrition.ProtenOver != null)
                        Text(
                          " Over ${widget.dataNutrition.ProtenOver}g",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD50000)),
                        ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: loginWidth == 400
                      ? const Duration(seconds: 1)
                      : const Duration(seconds: 0),
                  width: loginWidth,
                  height: 20,
                  child: HorizontalGraph(
                    data: widget.dataNutrition.data1,
                  ),
                ),
                if ((widget.dataNutrition.ProtenNeeds >
                        widget.dataNutrition.ProtenUser) &
                    (widget.dataNutrition.ProtenItem == null))
                  Row(
                    children: [
                      const Text("0",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(
                          flex: widget.dataNutrition.ProtenUser > 0
                              ? widget.dataNutrition.ProtenUser
                              : 1),
                      Text("${widget.dataNutrition.ProtenUser}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.redAccent)),
                      Spacer(
                          flex: widget.dataNutrition.ProtenNeeds -
                              widget.dataNutrition.ProtenUser),
                      Text(widget.dataNutrition.ProtenNeeds.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                    ],
                  ),
                if ((widget.dataNutrition.ProtenNeeds <
                        widget.dataNutrition.ProtenUser) &
                    (widget.dataNutrition.ProtenItem == null))
                  Row(
                    children: [
                      const Text("0",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(flex: widget.dataNutrition.ProtenNeeds),
                      Text(widget.dataNutrition.ProtenNeeds.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(
                          flex: widget.dataNutrition.ProtenUser -
                              widget.dataNutrition.ProtenNeeds),
                      Text("${widget.dataNutrition.ProtenUser}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD50000))),
                    ],
                  ),
                if ((widget.dataNutrition.ProtenNeeds >
                        widget.dataNutrition.ProtenUser) &
                    (widget.dataNutrition.ProtenItem != null) &
                    ((widget.dataNutrition.ProtenNeeds) >
                        (widget.dataNutrition.ProtenUser +
                            (widget.dataNutrition.ProtenItem ?? 0))))
                  Row(
                    children: [
                      const Text("0",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(
                          flex: widget.dataNutrition.ProtenUser > 0
                              ? widget.dataNutrition.ProtenUser
                              : 1),
                      Text("${widget.dataNutrition.ProtenUser}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.redAccent)),
                      Spacer(
                          flex: widget.dataNutrition.ProtenItem.round() > 0
                              ? widget.dataNutrition.ProtenItem.round()
                              : 1),
                      Text(
                          "${widget.dataNutrition.ProtenUser + widget.dataNutrition.ProtenItem.round()}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFFF1744))),
                      Spacer(
                          flex: widget.dataNutrition.ProtenNeeds -
                              widget.dataNutrition.ProtenUser -
                              widget.dataNutrition.ProtenItem.round()),
                      Text(widget.dataNutrition.ProtenNeeds.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                    ],
                  ),
                if ((widget.dataNutrition.ProtenNeeds >
                        widget.dataNutrition.ProtenUser) &
                    (widget.dataNutrition.ProtenItem != null) &
                    (widget.dataNutrition.ProtenNeeds <
                        (widget.dataNutrition.ProtenUser +
                            (widget.dataNutrition.ProtenItem ?? 0))))
                  Row(
                    children: [
                      const Text("0",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(
                          flex: widget.dataNutrition.ProtenUser > 0
                              ? widget.dataNutrition.ProtenUser
                              : 1),
                      Text(widget.dataNutrition.ProtenUser.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.redAccent)),
                      Spacer(
                          flex: widget.dataNutrition.ProtenNeeds -
                              widget.dataNutrition.ProtenUser),
                      Text((widget.dataNutrition.ProtenNeeds).toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(flex: widget.dataNutrition.ProtenOver ?? 1),
                      Text(
                          "${widget.dataNutrition.ProtenNeeds + widget.dataNutrition.ProtenOver}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD50000))),
                    ],
                  ),
                if ((widget.dataNutrition.ProtenNeeds <
                        widget.dataNutrition.ProtenUser) &
                    (widget.dataNutrition.ProtenItem != null) &
                    (widget.dataNutrition.ProtenNeeds <
                        (widget.dataNutrition.ProtenUser +
                            (widget.dataNutrition.ProtenItem ?? 0))))
                  Row(
                    children: [
                      const Text("0",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(flex: widget.dataNutrition.ProtenNeeds),
                      Text(widget.dataNutrition.ProtenNeeds.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(
                          flex: widget.dataNutrition.ProtenUser -
                              widget.dataNutrition.ProtenNeeds),
                      Text("${widget.dataNutrition.ProtenUser}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD50000))),
                      Spacer(
                          flex: widget.dataNutrition.ProtenItem.round() ?? 1),
                      Text(
                          "${widget.dataNutrition.ProtenUser + widget.dataNutrition.ProtenItem.round()}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD50000))),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 8),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Fats",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.black),
                          ),
                          if (widget.dataNutrition.FatsOver != null ||
                              widget.dataNutrition.FatsItem != null)
                            const Text(
                              ":",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black),
                            ),
                          if (widget.dataNutrition.FatsItem != null)
                            Text(
                              " ${widget.dataNutrition.FatsItem}g",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.deepOrangeAccent),
                            ),
                          if (widget.dataNutrition.FatsOver != null)
                            Text(
                              " Over ${widget.dataNutrition.FatsOver}g",
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFD50000)),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: loginWidth == 400
                      ? const Duration(seconds: 1)
                      : const Duration(seconds: 0),
                  width: loginWidth,
                  height: 20,
                  child: HorizontalGraph(
                    data: widget.dataNutrition.data2,
                  ),
                ),
                if ((widget.dataNutrition.FatsNeeds >
                        widget.dataNutrition.FatsUser) &
                    (widget.dataNutrition.FatsItem == null))
                  Row(
                    children: [
                      const Text("0",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(
                          flex: widget.dataNutrition.FatsUser > 0
                              ? widget.dataNutrition.FatsUser
                              : 1),
                      Text("${widget.dataNutrition.FatsUser}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.orangeAccent)),
                      Spacer(
                          flex: widget.dataNutrition.FatsNeeds -
                              widget.dataNutrition.FatsUser),
                      Text(widget.dataNutrition.FatsNeeds.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                    ],
                  ),
                if ((widget.dataNutrition.FatsNeeds <
                        widget.dataNutrition.FatsUser) &
                    (widget.dataNutrition.FatsItem == null))
                  Row(
                    children: [
                      const Text("0",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(flex: widget.dataNutrition.FatsNeeds),
                      Text(widget.dataNutrition.FatsNeeds.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(
                          flex: widget.dataNutrition.FatsUser -
                              widget.dataNutrition.FatsNeeds),
                      Text("${widget.dataNutrition.FatsUser}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD50000))),
                    ],
                  ),
                if ((widget.dataNutrition.FatsNeeds >
                        widget.dataNutrition.FatsUser) &
                    (widget.dataNutrition.FatsItem != null) &
                    ((widget.dataNutrition.FatsNeeds) >
                        (widget.dataNutrition.FatsUser +
                            (widget.dataNutrition.FatsItem ?? 0))))
                  Row(
                    children: [
                      const Text("0",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(
                          flex: widget.dataNutrition.FatsUser > 0
                              ? widget.dataNutrition.FatsUser
                              : 1),
                      Text("${widget.dataNutrition.FatsUser}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.orangeAccent)),
                      Spacer(
                          flex: widget.dataNutrition.FatsItem.round() > 0
                              ? widget.dataNutrition.FatsItem.round()
                              : 1),
                      Text(
                          "${widget.dataNutrition.FatsUser + widget.dataNutrition.FatsItem.round()}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.deepOrangeAccent)),
                      Spacer(
                          flex: widget.dataNutrition.FatsNeeds -
                              widget.dataNutrition.FatsUser -
                              widget.dataNutrition.FatsItem.round()),
                      Text(widget.dataNutrition.FatsNeeds.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                    ],
                  ),
                if ((widget.dataNutrition.FatsNeeds >
                        widget.dataNutrition.FatsUser) &
                    (widget.dataNutrition.FatsItem != null) &
                    (widget.dataNutrition.FatsNeeds <
                        (widget.dataNutrition.FatsUser +
                            (widget.dataNutrition.FatsItem ?? 0))))
                  Row(
                    children: [
                      const Text("0",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(
                          flex: widget.dataNutrition.FatsUser > 0
                              ? widget.dataNutrition.FatsUser
                              : 1),
                      Text(widget.dataNutrition.FatsUser.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.orangeAccent)),
                      Spacer(
                          flex: widget.dataNutrition.FatsNeeds -
                              widget.dataNutrition.FatsUser),
                      Text((widget.dataNutrition.FatsNeeds).toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(flex: widget.dataNutrition.FatsOver ?? 1),
                      Text(
                          "${widget.dataNutrition.FatsNeeds + widget.dataNutrition.FatsOver}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD50000))),
                    ],
                  ),
                if ((widget.dataNutrition.FatsNeeds <
                        widget.dataNutrition.FatsUser) &
                    (widget.dataNutrition.FatsItem != null) &
                    (widget.dataNutrition.FatsNeeds <
                        (widget.dataNutrition.FatsUser +
                            (widget.dataNutrition.FatsItem ?? 0))))
                  Row(
                    children: [
                      const Text("0",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(flex: widget.dataNutrition.FatsNeeds),
                      Text(widget.dataNutrition.FatsNeeds.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(
                          flex: widget.dataNutrition.FatsUser -
                              widget.dataNutrition.FatsNeeds),
                      Text("${widget.dataNutrition.FatsUser}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD50000))),
                      Spacer(flex: widget.dataNutrition.FatsItem.round() ?? 1),
                      Text(
                          "${widget.dataNutrition.FatsUser + widget.dataNutrition.FatsItem.round()}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD50000))),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 8),
                  child: Row(
                    children: [
                      const Text(
                        "Carbs",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.black),
                      ),
                      if (widget.dataNutrition.CarbsOver != null ||
                          widget.dataNutrition.CarbsItem != null)
                        const Text(
                          ":",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black),
                        ),
                      if (widget.dataNutrition.CarbsItem != null)
                        Text(
                          " ${widget.dataNutrition.CarbsItem}g",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFF9A825)),
                        ),
                      if (widget.dataNutrition.CarbsOver != null)
                        Text(
                          " Over ${widget.dataNutrition.CarbsOver}g",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD50000)),
                        ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: loginWidth == 400
                      ? const Duration(seconds: 1)
                      : const Duration(seconds: 0),
                  width: loginWidth,
                  height: 20,
                  child: HorizontalGraph(
                    data: widget.dataNutrition.data3,
                  ),
                ),
                if ((widget.dataNutrition.CarbsNeeds >
                        widget.dataNutrition.CarbsUser) &
                    (widget.dataNutrition.CarbsItem == null))
                  Row(
                    children: [
                      const Text("0",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(
                          flex: widget.dataNutrition.CarbsUser > 0
                              ? widget.dataNutrition.CarbsUser
                              : 1),
                      Text("${widget.dataNutrition.CarbsUser}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.yellow)),
                      Spacer(
                          flex: widget.dataNutrition.CarbsNeeds -
                              widget.dataNutrition.CarbsUser),
                      Text(widget.dataNutrition.CarbsNeeds.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                    ],
                  ),
                if ((widget.dataNutrition.CarbsNeeds <
                        widget.dataNutrition.CarbsUser) &
                    (widget.dataNutrition.CarbsItem == null))
                  Row(
                    children: [
                      const Text("0",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(flex: widget.dataNutrition.CarbsNeeds),
                      Text(widget.dataNutrition.CarbsNeeds.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(
                          flex: widget.dataNutrition.CarbsUser -
                              widget.dataNutrition.CarbsNeeds),
                      Text("${widget.dataNutrition.CarbsUser}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD50000))),
                    ],
                  ),
                if ((widget.dataNutrition.CarbsNeeds >
                        widget.dataNutrition.CarbsUser) &
                    (widget.dataNutrition.CarbsItem != null) &
                    ((widget.dataNutrition.CarbsNeeds) >
                        (widget.dataNutrition.CarbsUser +
                            (widget.dataNutrition.CarbsItem ?? 0))))
                  Row(
                    children: [
                      const Text("0",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(
                          flex: widget.dataNutrition.CarbsUser > 0
                              ? widget.dataNutrition.CarbsUser
                              : 1),
                      Text("${widget.dataNutrition.CarbsUser}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.yellow)),
                      Spacer(
                          flex: widget.dataNutrition.CarbsItem.round() > 0
                              ? widget.dataNutrition.CarbsItem.round()
                              : 1),
                      Text(
                          "${widget.dataNutrition.CarbsUser + widget.dataNutrition.CarbsItem.round()}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFF9A825))),
                      Spacer(
                          flex: widget.dataNutrition.CarbsNeeds -
                              widget.dataNutrition.CarbsUser -
                              widget.dataNutrition.CarbsItem.round()),
                      Text(widget.dataNutrition.CarbsNeeds.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                    ],
                  ),
                if ((widget.dataNutrition.CarbsNeeds >
                        widget.dataNutrition.CarbsUser) &
                    (widget.dataNutrition.CarbsItem != null) &
                    (widget.dataNutrition.CarbsNeeds <
                        (widget.dataNutrition.CarbsUser +
                            (widget.dataNutrition.CarbsItem ?? 0))))
                  Row(
                    children: [
                      const Text("0",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(
                          flex: widget.dataNutrition.CarbsUser > 0
                              ? widget.dataNutrition.CarbsUser
                              : 1),
                      Text(widget.dataNutrition.CarbsUser.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.yellow)),
                      Spacer(
                          flex: widget.dataNutrition.CarbsNeeds -
                              widget.dataNutrition.CarbsUser),
                      Text((widget.dataNutrition.CarbsNeeds).toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(flex: widget.dataNutrition.CarbsOver ?? 1),
                      Text(
                          "${widget.dataNutrition.CarbsNeeds + widget.dataNutrition.CarbsOver}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD50000))),
                    ],
                  ),
                if ((widget.dataNutrition.CarbsNeeds <
                        widget.dataNutrition.CarbsUser) &
                    (widget.dataNutrition.CarbsItem != null) &
                    (widget.dataNutrition.CarbsNeeds <
                        (widget.dataNutrition.CarbsUser +
                            (widget.dataNutrition.CarbsItem ?? 0))))
                  Row(
                    children: [
                      const Text("0",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(flex: widget.dataNutrition.CarbsNeeds),
                      Text(widget.dataNutrition.CarbsNeeds.toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                      Spacer(
                          flex: widget.dataNutrition.CarbsUser -
                              widget.dataNutrition.CarbsNeeds),
                      Text("${widget.dataNutrition.CarbsUser}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD50000))),
                      Spacer(flex: widget.dataNutrition.CarbsItem.round() ?? 1),
                      Text(
                          "${widget.dataNutrition.CarbsUser + widget.dataNutrition.CarbsItem.round()}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD50000))),
                    ],
                  ),
              ],
            )
          : const Text("loading"),
    );
  }
}
