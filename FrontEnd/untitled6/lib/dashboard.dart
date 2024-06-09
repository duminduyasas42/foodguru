import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled6/account.dart';
import 'package:untitled6/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:untitled6/recommendationpage.dart';

import 'foodrecognitionpage.dart';
import 'history.dart';
import 'horizontalgraph.dart';
import 'main.dart';

class DashBoard extends StatefulWidget {
  final User user;
  final dataNutrition;
  final searchData;
  const DashBoard({
    required this.user,
    required this.dataNutrition,
    required this.searchData,
  });

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int currentPage = 0;
  File? imagePicked;

  final imagePicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.green[200],
        elevation: 100,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home, size: 40), label: "Home"),
          NavigationDestination(
              icon: Icon(Icons.person, size: 40), label: "Account"),
          NavigationDestination(
              icon: Icon(Icons.dining_rounded, size: 40), label: "Food"),
          NavigationDestination(
              icon: Icon(Icons.camera_alt, size: 40), label: "Camera"),
          NavigationDestination(
              icon: Icon(Icons.calendar_today_rounded, size: 40),
              label: "History")
        ],
        onDestinationSelected: (int index) async {
          if (index == 4) {
            List<SearchData> searchData = [];
            final url1 = Uri.parse('http://100.91.248.174:8000/foods');
            final response1 = await http.get(url1);
            print("============================================");

            if (response1.statusCode == 200) {
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
            } else {
              print(response1.statusCode);
              print(response1.body);
            }
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => History(
                user: widget.user,
                dataNutrition: widget.dataNutrition,
                searchData: searchData,
              ),
            ));
          }
          if (index == 2) {
            List<SearchData> searchData = [];
            final url1 = Uri.parse('http://100.91.248.174:8000/foods');
            final response1 = await http.get(url1);
            print("============================================");

            if (response1.statusCode == 200) {
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
            } else {
              print(response1.statusCode);
              print(response1.body);
            }
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => FoodRecommendation(
                user: widget.user,
                dataNutrition: widget.dataNutrition,
                searchData: searchData,
              ),
            ));
          }
          if (index == 1) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => Acoount(
                user: widget.user,
                dataNutrition: widget.dataNutrition,
              ),
            ));
          }
          if (index == 3) {
            final image =
                await imagePicker.getImage(source: ImageSource.camera);
            setState(() {
              imagePicked = File(image!.path);
            });
            final url = Uri.parse('http://100.91.248.174:8000/foods/predict');
            final request = http.MultipartRequest('POST', url);
            request.files.add(
                await http.MultipartFile.fromPath('image', imagePicked!.path));
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
                                widget.dataNutrition.DailyCaloricUser +
                                    food.cals
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
                    units: widget.dataNutrition.FatsNeeds >
                            widget.dataNutrition.FatsUser
                        ? widget.dataNutrition.FatsUser
                        : widget.dataNutrition.FatsNeeds,
                    color: Colors.orangeAccent),
                Data(
                    units: widget.dataNutrition.FatsNeeds >
                            widget.dataNutrition.FatsUser +
                                double.parse(food.fats).round()
                        ? double.parse(food.fats).round()
                        : widget.dataNutrition.FatsNeeds >
                                widget.dataNutrition.FatsUser
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
                    units: widget.dataNutrition.CarbsNeeds >
                            widget.dataNutrition.CarbsUser
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
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
      body: Container(
          color: Colors.green[100],
          child: Homepage(
              user: widget.user,
              dataNutrition: widget.dataNutrition,
              searchData: widget.searchData)),
    );
  }
}
