import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:untitled6/grapgh.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:untitled6/horizontalgraph.dart';
import 'package:untitled6/nutrition.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'dashboard.dart';
import 'homepage.dart';
import 'main.dart';

class FoodDetialsData {
  final int id;
  final String name;
  final String details;
  final String units;
  final int cals;
  final String protein;
  final String carbs;
  final String suger;
  final String fats;
  final String fats_saturated;
  final String fats_monounsaturated;
  final String fats_polyunsaturated;
  final String fibre;
  final String salt;
  final String cholesterol_mg;
  final String potassium_mg;
  final String image;

  FoodDetialsData({
    required this.id,
    required this.name,
    required this.details,
    required this.units,
    required this.cals,
    required this.protein,
    required this.carbs,
    required this.suger,
    required this.fats,
    required this.fats_saturated,
    required this.fats_monounsaturated,
    required this.fats_polyunsaturated,
    required this.fibre,
    required this.salt,
    required this.cholesterol_mg,
    required this.potassium_mg,
    required this.image,
  });
  factory FoodDetialsData.fromJson(Map<String, dynamic> json) {
    return FoodDetialsData(
      id: json['id'],
      name: json['name'],
      details: json['details'],
      units: json['units'],
      cals: json['cals'],
      protein: json['protein'],
      carbs: json['carbs'],
      suger: json['suger'],
      fats: json['fats'],
      fats_saturated: json['fats_saturated'],
      fats_monounsaturated: json['fats_monounsaturated'],
      fats_polyunsaturated: json['fats_polyunsaturated'],
      fibre: json['fibre'],
      salt: json['salt'],
      cholesterol_mg: json['cholesterol_mg'],
      potassium_mg: json['potassium_mg'],
      image: json['image'],
    );
  }
}

class FoodRecognitionPage extends StatefulWidget {
  final User user;
  final dataNutrition;
  final foodDetialsData;

  File? imagePicked;
  FoodRecognitionPage(
      {super.key,
      this.imagePicked,
      required this.user,
      required this.dataNutrition,
      required this.foodDetialsData});

  @override
  State<FoodRecognitionPage> createState() => _FoodRecognitionPageState();
}

class _FoodRecognitionPageState extends State<FoodRecognitionPage> {
  DataNutrition? dataNutrition;
  FoodDetialsData? foodDetialsData;
  TextEditingController weightController = TextEditingController();
  List<SearchData> searchData = [];
// static File? imagePicked;
  @override
  void initState() {
    super.initState();
    dataNutrition = widget.dataNutrition;
    foodDetialsData = widget.foodDetialsData;
    weightController = TextEditingController(text: '100');
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now().toLocal();
    DateTime datetoday = DateTime(today.year, today.month, today.day);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Food Data"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.greenAccent,
            child: Column(
              children: [
                SizedBox(
                    height: 375,
                    child: FractionallySizedBox(
                      widthFactor: 1.34,
                      child: widget.imagePicked != null
                          ? Image.file(
                              widget.imagePicked!,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              'http://100.91.248.174:8000${foodDetialsData!.image}',
                              fit: BoxFit.cover,
                            ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: DonutGrapgh(
                    foodDetialsData: widget.foodDetialsData,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Text('( ${foodDetialsData!.units} )',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.black)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    " ${foodDetialsData!.cals} cals",
                    style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 15),
                      child: Container(
                        width: 118,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.redAccent),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              Text("${foodDetialsData!.protein}g",
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black)),
                              const Text("Protein",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 15),
                      child: Container(
                        width: 118,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.orangeAccent),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              Text("${foodDetialsData!.fats}g",
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black)),
                              const Text("Fats",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 15),
                      child: Container(
                        width: 118,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.yellow),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              Text("${foodDetialsData!.carbs}g",
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black)),
                              const Text("Carbs",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      const Align(
                          alignment: Alignment.topLeft,
                          child: Text("Detials",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black))),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(foodDetialsData!.details,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: Colors.black)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 10, top: 15, bottom: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Fats",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                      "Fats Polyunsaturated: ${foodDetialsData!.fats_polyunsaturated}g",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black)),
                                  Text(
                                      "Fats Monounsaturated: ${foodDetialsData!.fats_monounsaturated}g",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black)),
                                  Text(
                                      "Fats Saturated: ${foodDetialsData!.fats_saturated}g",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black)),
                                  Text(
                                      "Cholesterol: ${foodDetialsData!.cholesterol_mg}mg",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black))
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 10, top: 15, bottom: 60),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Carbs",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text("Suger: ${foodDetialsData!.suger}g",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black)),
                                  Text("Fiber: ${foodDetialsData!.fibre}g",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.purple[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 15, bottom: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Minerals",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 5.0),
                              Text("Salt: ${foodDetialsData!.salt}g",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black)),
                              Text(
                                  "Potassium: ${foodDetialsData!.potassium_mg}mg",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          color: Colors.green[50],
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            controller: weightController,
                            onEditingComplete: () {
                              dataNutrition = widget.dataNutrition;
                              String weight = weightController.text.trim();
                              final calariesperQutity =
                                  (dataNutrition!.CalariesItem /
                                          100 *
                                          int.parse(weight))
                                      .round();
                              final protenperQutity =
                                  dataNutrition!.ProtenItem /
                                      100 *
                                      double.parse(weight);
                              final carbsperQutity = dataNutrition!.CarbsItem /
                                  100 *
                                  double.parse(weight);
                              final fatsperQutity = dataNutrition!.FatsItem /
                                  100 *
                                  double.parse(weight);
                              final data = [
                                Data(
                                    units: dataNutrition!.DailyCaloricNeeds >
                                            dataNutrition!.DailyCaloricUser
                                        ? dataNutrition!.DailyCaloricUser
                                        : dataNutrition!.DailyCaloricNeeds,
                                    color: Colors.lightBlueAccent),
                                Data(
                                    units: dataNutrition!.DailyCaloricNeeds >
                                            dataNutrition!.DailyCaloricUser +
                                                calariesperQutity
                                        ? calariesperQutity
                                        : dataNutrition!.DailyCaloricNeeds >
                                                dataNutrition!.DailyCaloricUser
                                            ? dataNutrition!.DailyCaloricNeeds -
                                                dataNutrition!.DailyCaloricUser
                                            : 0,
                                    color: Colors.blueAccent),
                                Data(
                                    units: dataNutrition!.DailyCaloricNeeds >
                                            dataNutrition!.DailyCaloricUser +
                                                calariesperQutity
                                        ? dataNutrition!.DailyCaloricNeeds -
                                            dataNutrition!.DailyCaloricUser -
                                            calariesperQutity
                                        : 0,
                                    color: Colors.white),
                                Data(
                                    units: dataNutrition!.DailyCaloricNeeds <
                                            dataNutrition!.DailyCaloricUser +
                                                calariesperQutity
                                        ? dataNutrition!.DailyCaloricUser +
                                            calariesperQutity -
                                            dataNutrition!.DailyCaloricNeeds
                                        : dataNutrition!.DailyCaloricNeeds <
                                                dataNutrition!
                                                        .DailyCaloricUser +
                                                    calariesperQutity
                                            ? dataNutrition!.DailyCaloricUser -
                                                dataNutrition!.DailyCaloricNeeds
                                            : 0,
                                    color: const Color(0xFFD50000))
                              ];
                              final data1 = [
                                Data(
                                    units: dataNutrition!.ProtenNeeds >
                                            dataNutrition!.ProtenUser
                                        ? dataNutrition!.ProtenUser
                                        : dataNutrition!.ProtenNeeds,
                                    color: Colors.redAccent),
                                Data(
                                    units: dataNutrition!.ProtenNeeds >
                                            dataNutrition!.ProtenUser +
                                                protenperQutity.round()
                                        ? protenperQutity.round()
                                        : dataNutrition!.ProtenNeeds >
                                                dataNutrition!.ProtenUser
                                            ? dataNutrition!.ProtenNeeds -
                                                dataNutrition!.ProtenUser
                                            : 0,
                                    color: const Color(0xFFFF1744)),
                                Data(
                                    units: dataNutrition!.ProtenNeeds >
                                            dataNutrition!.ProtenUser +
                                                protenperQutity.round()
                                        ? dataNutrition!.ProtenNeeds -
                                            dataNutrition!.ProtenUser -
                                            protenperQutity.round()
                                        : 0,
                                    color: Colors.white),
                                Data(
                                    units: dataNutrition!.ProtenNeeds <
                                            dataNutrition!.ProtenUser +
                                                protenperQutity.round()
                                        ? dataNutrition!.ProtenNeeds +
                                            protenperQutity.round() -
                                            dataNutrition!.ProtenNeeds
                                        : dataNutrition!.ProtenNeeds <
                                                dataNutrition!.ProtenUser +
                                                    protenperQutity.round()
                                            ? dataNutrition!.ProtenUser -
                                                dataNutrition!.ProtenNeeds
                                            : 0,
                                    color: const Color(0xFFD50000))
                              ];
                              final data2 = [
                                Data(
                                    units: dataNutrition!.FatsNeeds >
                                            dataNutrition!.FatsUser
                                        ? dataNutrition!.FatsUser
                                        : dataNutrition!.FatsNeeds,
                                    color: Colors.orangeAccent),
                                Data(
                                    units: dataNutrition!.FatsNeeds >
                                            dataNutrition!.FatsUser +
                                                fatsperQutity.round()
                                        ? fatsperQutity.round()
                                        : dataNutrition!.FatsNeeds >
                                                dataNutrition!.FatsUser
                                            ? dataNutrition!.FatsNeeds -
                                                dataNutrition!.FatsUser
                                            : 0,
                                    color: Colors.deepOrangeAccent),
                                Data(
                                    units: dataNutrition!.FatsNeeds >
                                            dataNutrition!.FatsUser +
                                                fatsperQutity.round()
                                        ? dataNutrition!.FatsNeeds -
                                            dataNutrition!.FatsUser -
                                            fatsperQutity.round()
                                        : 0,
                                    color: Colors.white),
                                Data(
                                    units: dataNutrition!.FatsNeeds <
                                            dataNutrition!.FatsUser +
                                                fatsperQutity.round()
                                        ? dataNutrition!.FatsUser +
                                            fatsperQutity.round() -
                                            dataNutrition!.FatsNeeds
                                        : dataNutrition!.FatsNeeds <
                                                dataNutrition!.FatsUser +
                                                    fatsperQutity.round()
                                            ? dataNutrition!.FatsUser -
                                                dataNutrition!.FatsNeeds
                                            : 0,
                                    color: const Color(0xFFD50000))
                              ];
                              final data3 = [
                                Data(
                                    units: dataNutrition!.CarbsNeeds >
                                            dataNutrition!.CarbsUser
                                        ? dataNutrition!.CarbsUser
                                        : dataNutrition!.CarbsNeeds,
                                    color: Colors.yellow),
                                Data(
                                    units: dataNutrition!.CarbsNeeds >
                                            dataNutrition!.CarbsUser +
                                                carbsperQutity.round()
                                        ? carbsperQutity.round()
                                        : dataNutrition!.CarbsNeeds >
                                                dataNutrition!.CarbsUser
                                            ? dataNutrition!.CarbsNeeds -
                                                dataNutrition!.CarbsUser
                                            : 0,
                                    color: const Color(0xFFF9A825)),
                                Data(
                                    units: dataNutrition!.CarbsNeeds >
                                            dataNutrition!.CarbsUser +
                                                carbsperQutity.round()
                                        ? dataNutrition!.CarbsNeeds -
                                            dataNutrition!.CarbsUser -
                                            carbsperQutity.round()
                                        : 0,
                                    color: Colors.white),
                                Data(
                                    units: dataNutrition!.CarbsNeeds <
                                            dataNutrition!.CarbsUser +
                                                carbsperQutity.round()
                                        ? dataNutrition!.CarbsUser +
                                            carbsperQutity.round() -
                                            dataNutrition!.CarbsNeeds
                                        : dataNutrition!.CarbsNeeds <
                                                dataNutrition!.CarbsUser +
                                                    carbsperQutity.round()
                                            ? dataNutrition!.CarbsUser -
                                                dataNutrition!.CarbsNeeds
                                            : 0,
                                    color: const Color(0xFFD50000))
                              ];
                              DataNutrition dataNutritionEdited = DataNutrition(
                                  data: data,
                                  data1: data1,
                                  data2: data2,
                                  data3: data3,
                                  DailyCaloricNeeds:
                                      dataNutrition!.DailyCaloricNeeds,
                                  FatsNeeds: dataNutrition!.FatsNeeds,
                                  CarbsNeeds: dataNutrition!.CarbsNeeds,
                                  ProtenNeeds: dataNutrition!.ProtenNeeds,
                                  DailyCaloricUser:
                                      dataNutrition!.DailyCaloricUser,
                                  FatsUser: dataNutrition!.FatsUser,
                                  CarbsUser: dataNutrition!.CarbsUser,
                                  ProtenUser: dataNutrition!.ProtenUser,
                                  CalariesOver: dataNutrition!
                                              .DailyCaloricNeeds <
                                          dataNutrition!.DailyCaloricUser +
                                              calariesperQutity
                                      ? dataNutrition!.DailyCaloricUser +
                                          calariesperQutity -
                                          dataNutrition!.DailyCaloricNeeds
                                      : dataNutrition!.DailyCaloricNeeds <
                                              dataNutrition!.DailyCaloricUser +
                                                  calariesperQutity
                                          ? dataNutrition!.DailyCaloricUser -
                                              dataNutrition!.DailyCaloricNeeds
                                          : null,
                                  FatsOver: dataNutrition!.FatsNeeds <
                                          dataNutrition!.FatsUser +
                                              fatsperQutity.round()
                                      ? dataNutrition!.FatsUser +
                                          fatsperQutity.round() -
                                          dataNutrition!.FatsNeeds
                                      : dataNutrition!.FatsNeeds <
                                              dataNutrition!.FatsUser +
                                                  fatsperQutity.round()
                                          ? dataNutrition!.FatsUser -
                                              dataNutrition!.FatsNeeds
                                          : null,
                                  CarbsOver: dataNutrition!.CarbsNeeds <
                                          dataNutrition!.CarbsUser +
                                              carbsperQutity.round()
                                      ? dataNutrition!.CarbsUser +
                                          carbsperQutity.round() -
                                          dataNutrition!.CarbsNeeds
                                      : dataNutrition!.CarbsNeeds <
                                              dataNutrition!.CarbsUser +
                                                  carbsperQutity.round()
                                          ? dataNutrition!.CarbsUser -
                                              dataNutrition!.CarbsNeeds
                                          : null,
                                  ProtenOver: dataNutrition!.ProtenNeeds <
                                          dataNutrition!.ProtenUser +
                                              protenperQutity.round()
                                      ? dataNutrition!.ProtenNeeds +
                                          protenperQutity.round() -
                                          dataNutrition!.ProtenNeeds
                                      : dataNutrition!.ProtenNeeds <
                                              dataNutrition!.ProtenUser +
                                                  protenperQutity.round()
                                          ? dataNutrition!.ProtenUser -
                                              dataNutrition!.ProtenNeeds
                                          : null,
                                  CalariesItem: calariesperQutity,
                                  FatsItem: fatsperQutity,
                                  CarbsItem: carbsperQutity,
                                  ProtenItem: protenperQutity);
                              setState(() {
                                dataNutrition = dataNutritionEdited;
                              });
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Weight g',
                                labelStyle: TextStyle(color: Colors.black)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Weight';
                              }

                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Nutrition(
                          user: widget.user,
                          dataNutrition: dataNutrition,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            int? CaloricOver = 0;
                            int? ProtenOver = 0;
                            int? CarbsOver = 0;
                            int? FatsOver = 0;
                            final url = Uri.parse(
                                'http://100.91.248.174:8000/historyFood');
                            final headers = {
                              'Content-Type': 'application/json'
                            };

                            final body = json.encode({
                              "user_id": widget.user.id,
                              "date":
                                  DateFormat('yyyy-MM-dd').format(datetoday),
                              "cals": dataNutrition!.CalariesItem,
                              "fats": dataNutrition!.FatsItem.toString(),
                              "carbs": dataNutrition!.CarbsItem.toString(),
                              "protein": dataNutrition!.ProtenItem.toString(),
                              "food_id": foodDetialsData!.id,
                              "food_name": foodDetialsData!.name,
                              "food_weight": weightController.text.trim()
                            });
                            print(body);
                            final response = await http.post(url,
                                headers: headers, body: body);

                            final url1 =
                                Uri.parse('http://100.91.248.174:8000/foods');
                            final response1 = await http.get(url1);

                            if ((response.statusCode == 201) &
                                (response1.statusCode == 200)) {
                              final jsonMap2 = jsonDecode(response.body);

                              DailyNutrionData dailyNutrionData =
                                  DailyNutrionData.fromJson(jsonMap2);
                              final jsonMap1 = jsonDecode(response1.body);
                              for (dynamic item in jsonMap1) {
                                SearchData searchDataItem = SearchData(
                                  id: item['id'],
                                  name: item['name'],
                                  cals: item['cals'],
                                  image: item['image'],
                                );
                                searchData.add(searchDataItem);
                              }
                              print("dddddddddddddddddddddddddddddd");
                              print(dailyNutrionData);
                              CaloricOver = (dailyNutrionData.cals >
                                      dataNutrition!.DailyCaloricNeeds)
                                  ? (dailyNutrionData.cals -
                                      dataNutrition!.DailyCaloricNeeds) as int
                                  : null;
                              ProtenOver =
                                  double.parse(dailyNutrionData.protein)
                                              .round() >
                                          dataNutrition!.ProtenNeeds
                                      ? (double.parse(dailyNutrionData.protein)
                                              .round() -
                                          dataNutrition!.ProtenNeeds) as int
                                      : null;
                              CarbsOver =
                                  double.parse(dailyNutrionData.carbs).round() >
                                          dataNutrition!.CarbsNeeds
                                      ? (double.parse(dailyNutrionData.carbs)
                                              .round() -
                                          dataNutrition!.CarbsNeeds) as int
                                      : null;
                              FatsOver =
                                  double.parse(dailyNutrionData.fats).round() >
                                          dataNutrition!.FatsNeeds
                                      ? (double.parse(dailyNutrionData.fats)
                                              .round() -
                                          dataNutrition!.FatsNeeds) as int
                                      : null;
                              final data = [
                                Data(
                                    units: dataNutrition!.DailyCaloricNeeds >
                                            dailyNutrionData.cals
                                        ? dailyNutrionData.cals
                                        : dataNutrition!.DailyCaloricNeeds,
                                    color: Colors.lightBlueAccent),
                                Data(units: 0, color: Colors.blueAccent),
                                Data(
                                    units: dataNutrition!.DailyCaloricNeeds >
                                            dailyNutrionData.cals
                                        ? dataNutrition!.DailyCaloricNeeds -
                                            dailyNutrionData.cals
                                        : 0,
                                    color: Colors.white),
                                Data(
                                    units: dataNutrition!.DailyCaloricNeeds <
                                            dailyNutrionData.cals
                                        ? (dailyNutrionData.cals -
                                            dataNutrition!
                                                .DailyCaloricNeeds) as int
                                        : 0,
                                    color: const Color(0xFFD50000))
                              ];
                              final data1 = [
                                Data(
                                    units: dataNutrition!.ProtenNeeds >
                                            double.parse(
                                                    dailyNutrionData.protein)
                                                .round()
                                        ? double.parse(dailyNutrionData.protein)
                                            .round()
                                        : dataNutrition!.ProtenNeeds,
                                    color: Colors.redAccent),
                                Data(units: 0, color: const Color(0xFFFF1744)),
                                Data(
                                    units: dataNutrition!.ProtenNeeds >
                                            double.parse(
                                                    dailyNutrionData.protein)
                                                .round()
                                        ? dataNutrition!.ProtenNeeds -
                                            double.parse(
                                                    dailyNutrionData.protein)
                                                .round()
                                        : 0,
                                    color: Colors.white),
                                Data(
                                    units: dataNutrition!.ProtenNeeds <
                                            double.parse(
                                                    dailyNutrionData.protein)
                                                .round()
                                        ? (double.parse(
                                                    dailyNutrionData.protein)
                                                .round() -
                                            dataNutrition!.ProtenNeeds) as int
                                        : 0,
                                    color: const Color(0xFFD50000)),
                              ];
                              final data2 = [
                                Data(
                                    units: dataNutrition!.FatsNeeds >
                                            double.parse(dailyNutrionData.fats)
                                                .round()
                                        ? double.parse(dailyNutrionData.fats)
                                            .round()
                                        : dataNutrition!.FatsNeeds,
                                    color: Colors.orangeAccent),
                                Data(units: 0, color: Colors.deepOrangeAccent),
                                Data(
                                    units: dataNutrition!.FatsNeeds >
                                            double.parse(dailyNutrionData.fats)
                                                .round()
                                        ? dataNutrition!.FatsNeeds -
                                            double.parse(dailyNutrionData.fats)
                                                .round()
                                        : 0,
                                    color: Colors.white),
                                Data(
                                    units: dataNutrition!.FatsNeeds <
                                            double.parse(dailyNutrionData.fats)
                                                .round()
                                        ? (double.parse(dailyNutrionData.fats)
                                                .round() -
                                            dataNutrition!.FatsNeeds) as int
                                        : 0,
                                    color: const Color(0xFFD50000)),
                              ];
                              final data3 = [
                                Data(
                                    units: dataNutrition!.CarbsNeeds >
                                            double.parse(dailyNutrionData.carbs)
                                                .round()
                                        ? double.parse(dailyNutrionData.carbs)
                                            .round()
                                        : dataNutrition!.CarbsNeeds,
                                    color: Colors.yellow),
                                Data(units: 0, color: Color(0xFFF9A825)),
                                Data(
                                    units: dataNutrition!.CarbsNeeds >
                                            double.parse(dailyNutrionData.carbs)
                                                .round()
                                        ? dataNutrition!.CarbsNeeds -
                                            double.parse(dailyNutrionData.carbs)
                                                .round()
                                        : 0,
                                    color: Colors.white),
                                Data(
                                    units: (dataNutrition!.CarbsNeeds <
                                            double.parse(dailyNutrionData.carbs)
                                                .round())
                                        ? (double.parse(dailyNutrionData.carbs)
                                                .round() -
                                            dataNutrition!.CarbsNeeds) as int
                                        : 0,
                                    color: const Color(0xFFD50000)),
                              ];
                              DataNutrition dataNutritionEdited = DataNutrition(
                                data: data,
                                data1: data1,
                                data2: data2,
                                data3: data3,
                                ProtenNeeds: dataNutrition!.ProtenNeeds,
                                FatsNeeds: dataNutrition!.FatsNeeds,
                                CarbsNeeds: dataNutrition!.CarbsNeeds,
                                DailyCaloricNeeds:
                                    dataNutrition!.DailyCaloricNeeds,
                                DailyCaloricUser: dailyNutrionData.cals,
                                FatsUser:
                                    double.parse(dailyNutrionData.fats).round(),
                                ProtenUser:
                                    double.parse(dailyNutrionData.protein)
                                        .round(),
                                CarbsUser: double.parse(dailyNutrionData.carbs)
                                    .round(),
                                CalariesOver: CaloricOver,
                                FatsOver: FatsOver,
                                CarbsOver: CarbsOver,
                                ProtenOver: ProtenOver,
                                CalariesItem: null,
                                FatsItem: null,
                                CarbsItem: null,
                                ProtenItem: null,
                              );
                              print(dataNutritionEdited.CarbsOver);
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (BuildContext context) => DashBoard(
                                    user: widget.user,
                                    dataNutrition: dataNutritionEdited,
                                    searchData: searchData),
                              ));
                            } else {
                              print("error occured");
                              print(response1.statusCode);
                              print(response1.body);
                              print(response.statusCode);
                              print(response.body);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          child: SizedBox(
                            width: 400,
                            child: const Padding(
                              padding: EdgeInsets.all(18.0),
                              child: Center(
                                child: Text(
                                  'Eat This Food',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
