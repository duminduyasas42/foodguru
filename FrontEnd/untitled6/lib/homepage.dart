import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:untitled6/foodrecognitionpage.dart';
import 'package:untitled6/nutrition.dart';
import 'package:http/http.dart' as http;

import 'horizontalgraph.dart';
import 'main.dart';

class SearchData {
  final String name;
  final int cals;
  final String image;
  final int id;

  SearchData(
      {required this.name,
      required this.cals,
      required this.image,
      required this.id});
}

class Homepage extends StatefulWidget {
  final User user;
  final dataNutrition;
  final searchData;
  Homepage(
      {required this.user,
      required this.dataNutrition,
      required this.searchData});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  File? imagePicked;

  final imagePicker = ImagePicker();

  Future getImage() async {
    final image = await imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      imagePicked = File(image!.path);
    });
    final url = Uri.parse('http://100.91.248.174:8000/foods/predict');
    final request = http.MultipartRequest('POST', url);
    request.files
        .add(await http.MultipartFile.fromPath('image', imagePicked!.path));
    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      print(respStr);
      final jsonMap1 = jsonDecode(respStr);
      print(jsonMap1);
      FoodDetialsData food = FoodDetialsData.fromJson(jsonMap1);
      print(widget.dataNutrition.DailyCaloricNeeds >
              widget.dataNutrition.DailyCaloricUser
          ? widget.dataNutrition.DailyCaloricUser
          : widget.dataNutrition.DailyCaloricNeeds);
      print(widget.dataNutrition.DailyCaloricNeeds >
              widget.dataNutrition.DailyCaloricUser + food.cals
          ? food.cals
          : widget.dataNutrition.DailyCaloricNeeds >
                  widget.dataNutrition.DailyCaloricUser
              ? widget.dataNutrition.DailyCaloricNeeds -
                  widget.dataNutrition.DailyCaloricUser
              : 0);
      print(widget.dataNutrition.DailyCaloricNeeds >
              widget.dataNutrition.DailyCaloricUser + food.cals
          ? widget.dataNutrition.DailyCaloricNeeds -
              widget.dataNutrition.DailyCaloricUser -
              food.cals
          : 0);
      print(widget.dataNutrition.DailyCaloricNeeds <
              widget.dataNutrition.DailyCaloricUser + food.cals
          ? widget.dataNutrition.DailyCaloricUser +
              food.cals -
              widget.dataNutrition.DailyCaloricNeeds
          : widget.dataNutrition.DailyCaloricNeeds <
                  widget.dataNutrition.DailyCaloricUser + food.cals
              ? widget.dataNutrition.DailyCaloricUser -
                  widget.dataNutrition.DailyCaloricNeeds
              : 0);
      final data = [
        Data(
            units: widget.dataNutrition.DailyCaloricNeeds >
                    widget.dataNutrition.DailyCaloricUser
                ? widget.dataNutrition.DailyCaloricUser
                : widget.dataNutrition.DailyCaloricNeeds,
            color: Colors.lightBlueAccent),
        Data(
            units: widget.dataNutrition.DailyCaloricNeeds >
                    widget.dataNutrition.DailyCaloricUser + food.cals
                ? food.cals
                : widget.dataNutrition.DailyCaloricNeeds >
                        widget.dataNutrition.DailyCaloricUser
                    ? widget.dataNutrition.DailyCaloricNeeds -
                        widget.dataNutrition.DailyCaloricUser
                    : 0,
            color: Colors.blueAccent),
        Data(
            units: widget.dataNutrition.DailyCaloricNeeds >
                    widget.dataNutrition.DailyCaloricUser + food.cals
                ? widget.dataNutrition.DailyCaloricNeeds -
                    widget.dataNutrition.DailyCaloricUser -
                    food.cals
                : 0,
            color: Colors.white),
        Data(
            units: widget.dataNutrition.DailyCaloricNeeds <
                    widget.dataNutrition.DailyCaloricUser + food.cals
                ? widget.dataNutrition.DailyCaloricUser +
                    food.cals -
                    widget.dataNutrition.DailyCaloricNeeds
                : widget.dataNutrition.DailyCaloricNeeds <
                        widget.dataNutrition.DailyCaloricUser + food.cals
                    ? widget.dataNutrition.DailyCaloricUser -
                        widget.dataNutrition.DailyCaloricNeeds
                    : 0,
            color: const Color(0xFFD50000))
      ];
      final data1 = [
        Data(
            units: widget.dataNutrition.ProtenNeeds >
                    widget.dataNutrition.ProtenUser
                ? widget.dataNutrition.ProtenUser
                : widget.dataNutrition.ProtenNeeds,
            color: Colors.redAccent),
        Data(
            units: widget.dataNutrition.ProtenNeeds >
                    widget.dataNutrition.ProtenUser +
                        double.parse(food.protein).round()
                ? double.parse(food.protein).round()
                : widget.dataNutrition.ProtenNeeds >
                        widget.dataNutrition.ProtenUser
                    ? widget.dataNutrition.ProtenNeeds -
                        widget.dataNutrition.ProtenUser
                    : 0,
            color: const Color(0xFFFF1744)),
        Data(
            units: widget.dataNutrition.ProtenNeeds >
                    widget.dataNutrition.ProtenUser +
                        double.parse(food.protein).round()
                ? widget.dataNutrition.ProtenNeeds -
                    widget.dataNutrition.ProtenUser -
                    double.parse(food.protein).round()
                : 0,
            color: Colors.white),
        Data(
            units: widget.dataNutrition.ProtenNeeds <
                    widget.dataNutrition.ProtenUser +
                        double.parse(food.protein).round()
                ? widget.dataNutrition.ProtenNeeds +
                    double.parse(food.protein).round() -
                    widget.dataNutrition.ProtenNeeds
                : widget.dataNutrition.ProtenNeeds <
                        widget.dataNutrition.ProtenUser +
                            double.parse(food.protein).round()
                    ? widget.dataNutrition.ProtenUser -
                        widget.dataNutrition.ProtenNeeds
                    : 0,
            color: const Color(0xFFD50000))
      ];
      final data2 = [
        Data(
            units:
                widget.dataNutrition.FatsNeeds > widget.dataNutrition.FatsUser
                    ? widget.dataNutrition.FatsUser
                    : widget.dataNutrition.FatsNeeds,
            color: Colors.orangeAccent),
        Data(
            units: widget.dataNutrition.FatsNeeds >
                    widget.dataNutrition.FatsUser +
                        double.parse(food.fats).round()
                ? double.parse(food.fats).round()
                : widget.dataNutrition.FatsNeeds > widget.dataNutrition.FatsUser
                    ? widget.dataNutrition.FatsNeeds -
                        widget.dataNutrition.FatsUser
                    : 0,
            color: Colors.deepOrangeAccent),
        Data(
            units: widget.dataNutrition.FatsNeeds >
                    widget.dataNutrition.FatsUser +
                        double.parse(food.fats).round()
                ? widget.dataNutrition.FatsNeeds -
                    widget.dataNutrition.FatsUser -
                    double.parse(food.fats).round()
                : 0,
            color: Colors.white),
        Data(
            units: widget.dataNutrition.FatsNeeds <
                    widget.dataNutrition.FatsUser +
                        double.parse(food.fats).round()
                ? widget.dataNutrition.FatsUser +
                    double.parse(food.fats).round() -
                    widget.dataNutrition.FatsNeeds
                : widget.dataNutrition.FatsNeeds <
                        widget.dataNutrition.FatsUser +
                            double.parse(food.fats).round()
                    ? widget.dataNutrition.FatsUser -
                        widget.dataNutrition.FatsNeeds
                    : 0,
            color: const Color(0xFFD50000))
      ];
      final data3 = [
        Data(
            units:
                widget.dataNutrition.CarbsNeeds > widget.dataNutrition.CarbsUser
                    ? widget.dataNutrition.CarbsUser
                    : widget.dataNutrition.CarbsNeeds,
            color: Colors.yellow),
        Data(
            units: widget.dataNutrition.CarbsNeeds >
                    widget.dataNutrition.CarbsUser +
                        double.parse(food.carbs).round()
                ? double.parse(food.carbs).round()
                : widget.dataNutrition.CarbsNeeds >
                        widget.dataNutrition.CarbsUser
                    ? widget.dataNutrition.CarbsNeeds -
                        widget.dataNutrition.CarbsUser
                    : 0,
            color: Color(0xFFF9A825)),
        Data(
            units: widget.dataNutrition.CarbsNeeds >
                    widget.dataNutrition.CarbsUser +
                        double.parse(food.carbs).round()
                ? widget.dataNutrition.CarbsNeeds -
                    widget.dataNutrition.CarbsUser -
                    double.parse(food.carbs).round()
                : 0,
            color: Colors.white),
        Data(
            units: widget.dataNutrition.CarbsNeeds <
                    widget.dataNutrition.CarbsUser +
                        double.parse(food.carbs).round()
                ? widget.dataNutrition.CarbsUser +
                    double.parse(food.carbs).round() -
                    widget.dataNutrition.CarbsNeeds
                : widget.dataNutrition.CarbsNeeds <
                        widget.dataNutrition.CarbsUser +
                            double.parse(food.carbs).round()
                    ? widget.dataNutrition.CarbsUser -
                        widget.dataNutrition.CarbsNeeds
                    : 0,
            color: const Color(0xFFD50000))
      ];
      DataNutrition dataNutritionEdited = DataNutrition(
          data: data,
          data1: data1,
          data2: data2,
          data3: data3,
          DailyCaloricNeeds: widget.dataNutrition.DailyCaloricNeeds,
          FatsNeeds: widget.dataNutrition.FatsNeeds,
          CarbsNeeds: widget.dataNutrition.CarbsNeeds,
          ProtenNeeds: widget.dataNutrition.ProtenNeeds,
          DailyCaloricUser: widget.dataNutrition.DailyCaloricUser,
          FatsUser: widget.dataNutrition.FatsUser,
          CarbsUser: widget.dataNutrition.CarbsUser,
          ProtenUser: widget.dataNutrition.ProtenUser,
          CalariesOver: widget.dataNutrition.DailyCaloricNeeds <
                  widget.dataNutrition.DailyCaloricUser + food.cals
              ? widget.dataNutrition.DailyCaloricUser +
                  food.cals -
                  widget.dataNutrition.DailyCaloricNeeds
              : widget.dataNutrition.DailyCaloricNeeds <
                      widget.dataNutrition.DailyCaloricUser + food.cals
                  ? widget.dataNutrition.DailyCaloricUser -
                      widget.dataNutrition.DailyCaloricNeeds
                  : null,
          FatsOver: widget.dataNutrition.FatsNeeds <
                  widget.dataNutrition.FatsUser +
                      double.parse(food.fats).round()
              ? widget.dataNutrition.FatsUser +
                  double.parse(food.fats).round() -
                  widget.dataNutrition.FatsNeeds
              : widget.dataNutrition.FatsNeeds <
                      widget.dataNutrition.FatsUser +
                          double.parse(food.fats).round()
                  ? widget.dataNutrition.FatsUser -
                      widget.dataNutrition.FatsNeeds
                  : null,
          CarbsOver: widget.dataNutrition.CarbsNeeds <
                  widget.dataNutrition.CarbsUser +
                      double.parse(food.carbs).round()
              ? widget.dataNutrition.CarbsUser +
                  double.parse(food.carbs).round() -
                  widget.dataNutrition.CarbsNeeds
              : widget.dataNutrition.CarbsNeeds <
                      widget.dataNutrition.CarbsUser +
                          double.parse(food.carbs).round()
                  ? widget.dataNutrition.CarbsUser -
                      widget.dataNutrition.CarbsNeeds
                  : null,
          ProtenOver: widget.dataNutrition.ProtenNeeds <
                  widget.dataNutrition.ProtenUser +
                      double.parse(food.protein).round()
              ? widget.dataNutrition.ProtenNeeds +
                  double.parse(food.protein).round() -
                  widget.dataNutrition.ProtenNeeds
              : widget.dataNutrition.ProtenNeeds <
                      widget.dataNutrition.ProtenUser +
                          double.parse(food.protein).round()
                  ? widget.dataNutrition.ProtenUser -
                      widget.dataNutrition.ProtenNeeds
                  : null,
          CalariesItem: food.cals,
          FatsItem: double.parse(food.fats),
          CarbsItem: double.parse(food.carbs),
          ProtenItem: double.parse(food.protein));
      var push = Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          return FoodRecognitionPage(
              foodDetialsData: food,
              imagePicked: imagePicked,
              user: widget.user,
              dataNutrition: dataNutritionEdited);
        }),
      );
      print(jsonMap1);
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Find out the best",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ),
              const Text(
                "Meal for You",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: GestureDetector(
                  onTap: () {
                    showSearch(
                        context: context,
                        delegate: MySearchDelegate(
                            user: widget.user,
                            dataNutrition: widget.dataNutrition,
                            searchData: widget.searchData));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[50],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.search, size: 23),
                          ),
                          Text("Search",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.greenAccent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 100, bottom: 50, top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Icon(Icons.camera_alt, size: 40),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text("Identify",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black)),
                                ),
                                Text("Food",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black))
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.greenAccent,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 70, bottom: 50, top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'images/FoodGuruLogo.png',
                                height: 40,
                                width: 40,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text("Recommend",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black)),
                              ),
                              const Text("Food",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black))
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Column(
                  children: [
                    Text(
                      "Daily deit Stats",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.black),
                    ),
                    Nutrition(
                      user: widget.user,
                      dataNutrition: widget.dataNutrition,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  final User user;
  final dataNutrition;
  List searchData;

  MySearchDelegate({
    required this.user,
    required this.dataNutrition,
    required this.searchData,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<SearchData> matchQuery = [];
    for (var fruit in searchData) {
      if (fruit.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.name),
        );
      },
      itemCount: matchQuery.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<SearchData> matchQuery = [];

    for (var fruit in searchData) {
      if (fruit.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          leading: Image.network(
            'http://100.91.248.174:8000${result.image}',
            height: 40,
            width: 40,
          ),
          title: Text(result.name),
          trailing: Text("${result.cals} calories"),
          onTap: () async {
            final url1 =
                Uri.parse('http://100.91.248.174:8000/foods/${result.id}');
            final response1 = await http.get(url1);
            print("============================================");

            if (response1.statusCode == 200) {
              final jsonMap1 = jsonDecode(response1.body);
              FoodDetialsData food = FoodDetialsData.fromJson(jsonMap1);
              print(dataNutrition.DailyCaloricNeeds >
                      dataNutrition.DailyCaloricUser
                  ? dataNutrition.DailyCaloricUser
                  : dataNutrition.DailyCaloricNeeds);
              print(dataNutrition.DailyCaloricNeeds >
                      dataNutrition.DailyCaloricUser + food.cals
                  ? food.cals
                  : dataNutrition.DailyCaloricNeeds >
                          dataNutrition.DailyCaloricUser
                      ? dataNutrition.DailyCaloricNeeds -
                          dataNutrition.DailyCaloricUser
                      : 0);
              print(dataNutrition.DailyCaloricNeeds >
                      dataNutrition.DailyCaloricUser + food.cals
                  ? dataNutrition.DailyCaloricNeeds -
                      dataNutrition.DailyCaloricUser -
                      food.cals
                  : 0);
              print(dataNutrition.DailyCaloricNeeds <
                      dataNutrition.DailyCaloricUser + food.cals
                  ? dataNutrition.DailyCaloricUser +
                      food.cals -
                      dataNutrition.DailyCaloricNeeds
                  : dataNutrition.DailyCaloricNeeds <
                          dataNutrition.DailyCaloricUser + food.cals
                      ? dataNutrition.DailyCaloricUser -
                          dataNutrition.DailyCaloricNeeds
                      : 0);
              final data = [
                Data(
                    units: dataNutrition.DailyCaloricNeeds >
                            dataNutrition.DailyCaloricUser
                        ? dataNutrition.DailyCaloricUser
                        : dataNutrition.DailyCaloricNeeds,
                    color: Colors.lightBlueAccent),
                Data(
                    units: dataNutrition.DailyCaloricNeeds >
                            dataNutrition.DailyCaloricUser + food.cals
                        ? food.cals
                        : dataNutrition.DailyCaloricNeeds >
                                dataNutrition.DailyCaloricUser
                            ? dataNutrition.DailyCaloricNeeds -
                                dataNutrition.DailyCaloricUser
                            : 0,
                    color: Colors.blueAccent),
                Data(
                    units: dataNutrition.DailyCaloricNeeds >
                            dataNutrition.DailyCaloricUser + food.cals
                        ? dataNutrition.DailyCaloricNeeds -
                            dataNutrition.DailyCaloricUser -
                            food.cals
                        : 0,
                    color: Colors.white),
                Data(
                    units: dataNutrition.DailyCaloricNeeds <
                            dataNutrition.DailyCaloricUser + food.cals
                        ? dataNutrition.DailyCaloricUser +
                            food.cals -
                            dataNutrition.DailyCaloricNeeds
                        : dataNutrition.DailyCaloricNeeds <
                                dataNutrition.DailyCaloricUser + food.cals
                            ? dataNutrition.DailyCaloricUser -
                                dataNutrition.DailyCaloricNeeds
                            : 0,
                    color: const Color(0xFFD50000))
              ];
              final data1 = [
                Data(
                    units: dataNutrition.ProtenNeeds > dataNutrition.ProtenUser
                        ? dataNutrition.ProtenUser
                        : dataNutrition.ProtenNeeds,
                    color: Colors.redAccent),
                Data(
                    units: dataNutrition.ProtenNeeds >
                            dataNutrition.ProtenUser +
                                double.parse(food.protein).round()
                        ? double.parse(food.protein).round()
                        : dataNutrition.ProtenNeeds > dataNutrition.ProtenUser
                            ? dataNutrition.ProtenNeeds -
                                dataNutrition.ProtenUser
                            : 0,
                    color: const Color(0xFFFF1744)),
                Data(
                    units: dataNutrition.ProtenNeeds >
                            dataNutrition.ProtenUser +
                                double.parse(food.protein).round()
                        ? dataNutrition.ProtenNeeds -
                            dataNutrition.ProtenUser -
                            double.parse(food.protein).round()
                        : 0,
                    color: Colors.white),
                Data(
                    units: dataNutrition.ProtenNeeds <
                            dataNutrition.ProtenUser +
                                double.parse(food.protein).round()
                        ? dataNutrition.ProtenNeeds +
                            double.parse(food.protein).round() -
                            dataNutrition.ProtenNeeds
                        : dataNutrition.ProtenNeeds <
                                dataNutrition.ProtenUser +
                                    double.parse(food.protein).round()
                            ? dataNutrition.ProtenUser -
                                dataNutrition.ProtenNeeds
                            : 0,
                    color: const Color(0xFFD50000))
              ];
              final data2 = [
                Data(
                    units: dataNutrition.FatsNeeds > dataNutrition.FatsUser
                        ? dataNutrition.FatsUser
                        : dataNutrition.FatsNeeds,
                    color: Colors.orangeAccent),
                Data(
                    units: dataNutrition.FatsNeeds >
                            dataNutrition.FatsUser +
                                double.parse(food.fats).round()
                        ? double.parse(food.fats).round()
                        : dataNutrition.FatsNeeds > dataNutrition.FatsUser
                            ? dataNutrition.FatsNeeds - dataNutrition.FatsUser
                            : 0,
                    color: Colors.deepOrangeAccent),
                Data(
                    units: dataNutrition.FatsNeeds >
                            dataNutrition.FatsUser +
                                double.parse(food.fats).round()
                        ? dataNutrition.FatsNeeds -
                            dataNutrition.FatsUser -
                            double.parse(food.fats).round()
                        : 0,
                    color: Colors.white),
                Data(
                    units: dataNutrition.FatsNeeds <
                            dataNutrition.FatsUser +
                                double.parse(food.fats).round()
                        ? dataNutrition.FatsUser +
                            double.parse(food.fats).round() -
                            dataNutrition.FatsNeeds
                        : dataNutrition.FatsNeeds <
                                dataNutrition.FatsUser +
                                    double.parse(food.fats).round()
                            ? dataNutrition.FatsUser - dataNutrition.FatsNeeds
                            : 0,
                    color: const Color(0xFFD50000))
              ];
              final data3 = [
                Data(
                    units: dataNutrition.CarbsNeeds > dataNutrition.CarbsUser
                        ? dataNutrition.CarbsUser
                        : dataNutrition.CarbsNeeds,
                    color: Colors.yellow),
                Data(
                    units: dataNutrition.CarbsNeeds >
                            dataNutrition.CarbsUser +
                                double.parse(food.carbs).round()
                        ? double.parse(food.carbs).round()
                        : dataNutrition.CarbsNeeds > dataNutrition.CarbsUser
                            ? dataNutrition.CarbsNeeds - dataNutrition.CarbsUser
                            : 0,
                    color: Color(0xFFF9A825)),
                Data(
                    units: dataNutrition.CarbsNeeds >
                            dataNutrition.CarbsUser +
                                double.parse(food.carbs).round()
                        ? dataNutrition.CarbsNeeds -
                            dataNutrition.CarbsUser -
                            double.parse(food.carbs).round()
                        : 0,
                    color: Colors.white),
                Data(
                    units: dataNutrition.CarbsNeeds <
                            dataNutrition.CarbsUser +
                                double.parse(food.carbs).round()
                        ? dataNutrition.CarbsUser +
                            double.parse(food.carbs).round() -
                            dataNutrition.CarbsNeeds
                        : dataNutrition.CarbsNeeds <
                                dataNutrition.CarbsUser +
                                    double.parse(food.carbs).round()
                            ? dataNutrition.CarbsUser - dataNutrition.CarbsNeeds
                            : 0,
                    color: const Color(0xFFD50000))
              ];
              DataNutrition dataNutritionEdited = DataNutrition(
                  data: data,
                  data1: data1,
                  data2: data2,
                  data3: data3,
                  DailyCaloricNeeds: dataNutrition.DailyCaloricNeeds,
                  FatsNeeds: dataNutrition.FatsNeeds,
                  CarbsNeeds: dataNutrition.CarbsNeeds,
                  ProtenNeeds: dataNutrition.ProtenNeeds,
                  DailyCaloricUser: dataNutrition.DailyCaloricUser,
                  FatsUser: dataNutrition.FatsUser,
                  CarbsUser: dataNutrition.CarbsUser,
                  ProtenUser: dataNutrition.ProtenUser,
                  CalariesOver: dataNutrition.DailyCaloricNeeds <
                          dataNutrition.DailyCaloricUser + food.cals
                      ? dataNutrition.DailyCaloricUser +
                          food.cals -
                          dataNutrition.DailyCaloricNeeds
                      : dataNutrition.DailyCaloricNeeds <
                              dataNutrition.DailyCaloricUser + food.cals
                          ? dataNutrition.DailyCaloricUser -
                              dataNutrition.DailyCaloricNeeds
                          : null,
                  FatsOver: dataNutrition.FatsNeeds <
                          dataNutrition.FatsUser +
                              double.parse(food.fats).round()
                      ? dataNutrition.FatsUser +
                          double.parse(food.fats).round() -
                          dataNutrition.FatsNeeds
                      : dataNutrition.FatsNeeds <
                              dataNutrition.FatsUser +
                                  double.parse(food.fats).round()
                          ? dataNutrition.FatsUser - dataNutrition.FatsNeeds
                          : null,
                  CarbsOver: dataNutrition.CarbsNeeds <
                          dataNutrition.CarbsUser +
                              double.parse(food.carbs).round()
                      ? dataNutrition.CarbsUser +
                          double.parse(food.carbs).round() -
                          dataNutrition.CarbsNeeds
                      : dataNutrition.CarbsNeeds <
                              dataNutrition.CarbsUser +
                                  double.parse(food.carbs).round()
                          ? dataNutrition.CarbsUser - dataNutrition.CarbsNeeds
                          : null,
                  ProtenOver: dataNutrition.ProtenNeeds <
                          dataNutrition.ProtenUser +
                              double.parse(food.protein).round()
                      ? dataNutrition.ProtenNeeds +
                          double.parse(food.protein).round() -
                          dataNutrition.ProtenNeeds
                      : dataNutrition.ProtenNeeds <
                              dataNutrition.ProtenUser +
                                  double.parse(food.protein).round()
                          ? dataNutrition.ProtenUser - dataNutrition.ProtenNeeds
                          : null,
                  CalariesItem: food.cals,
                  FatsItem: double.parse(food.fats),
                  CarbsItem: double.parse(food.carbs),
                  ProtenItem: double.parse(food.protein));
              print(response1.body);
              var push = Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return FoodRecognitionPage(
                      foodDetialsData: food,
                      imagePicked: null,
                      user: user,
                      dataNutrition: dataNutritionEdited);
                }),
              );
              print(jsonMap1);
            } else {
              print(response1.statusCode);
            }
          },
        );
      },
      itemCount: matchQuery.length,
    );
  }
}
