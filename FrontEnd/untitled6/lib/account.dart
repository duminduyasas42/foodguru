import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:untitled6/dashboard.dart';
import 'package:untitled6/recommendationpage.dart';
import 'package:untitled6/signup.dart';
import 'package:http/http.dart' as http;

import 'foodrecognitionpage.dart';
import 'homepage.dart';
import 'horizontalgraph.dart';
import 'main.dart';

class Acoount extends StatefulWidget {
  final user;
  final dataNutrition;

  const Acoount({required this.user, required this.dataNutrition});

  @override
  State<Acoount> createState() => _AcoountState();
}

class _AcoountState extends State<Acoount> {
  File? imagePicked;

  final imagePicker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();
  late TextEditingController _confirmPasswordController =
      TextEditingController();
  late TextEditingController _dobController = TextEditingController();
  late TextEditingController _heightController = TextEditingController();
  late TextEditingController _weightController = TextEditingController();
  late var _user;
  late var _dataNutrition;
  String? _error;
  String? _success;
  String _selectedSex = "Male";
  String _selectedActivityLevel = "Sedentary";
  final List<String> _sexOptions = ['Male', 'Female'];
  final List<ActivityLevel> _activityOptions = [
    ActivityLevel(
        value: "Sedentary",
        text:
            "Little or no exercise, desk job or mainly sitting down during the day"),
    ActivityLevel(
        value: "Lightly",
        text:
            "Light exercise or sports 1-3 days a week, such as leisurely walking or stretching."),
    ActivityLevel(
        value: "Moderately",
        text:
            "Moderate exercise or sports 3-5 days a week, such as jogging or swimming for 30-60 minutes."),
    ActivityLevel(
        value: "Very",
        text:
            "Hard exercise or sports 6-7 days a week, such as running or playing a sport for 60+ minutes."),
    ActivityLevel(
        value: "Extremely",
        text:
            "Very hard exercise or sports, physical job or training multiple times a day."),
  ];
  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Future<void> _submitForm() async {
    print("ffffff");
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String password = _passwordController.text.trim();
      int height = int.parse(_heightController.text.trim());
      String dob = _dobController.text.trim();
      int weight = int.parse(_weightController.text.trim());
      String sex = _selectedSex;
      String activityLevel = _selectedActivityLevel;
      final url =
          Uri.parse('http://100.91.248.174:8000/users/${widget.user.id}');
      print('http://100.91.248.174:8000/users/${widget.user.id}');
      final headers = {'Content-Type': 'application/json'};
      print("$name=$password=$height=$dob=$weight=$sex=$activityLevel");
      final body = json.encode({
        "username": name,
        "password": password,
        "sex": sex,
        "weight": weight,
        "height": height,
        "dob": dob,
        "activityLevel": activityLevel
      });
      final response = await http.put(url, headers: headers, body: body);
      print("Ssssssssssssss+${response.statusCode}");
      if (response.statusCode == 200) {
        int DailyCaloricNeeds = 0;
        int ProtenNeeds = 0;
        int CarbsNeeds = 0;
        int FatsNeeds = 0;
        int? CaloricOver = 0;
        int? ProtenOver = 0;
        int? CarbsOver = 0;
        int? FatsOver = 0;
        final jsonMap = jsonDecode(response.body);
        User user = User.fromJson(jsonMap);

        String dateString = user.dob;
        DateTime date = DateTime.parse(dateString);
        double BMR = 0;
        int age = calculateAge(date);
        if (user.sex == "Male") {
          BMR = 88.362 +
              (13.397 * user.weight) +
              (4.799 * user.height) -
              (5.677 * age);
        } else if (user.sex == "Female") {
          BMR = 447.593 +
              (9.247 * user.weight) +
              (3.098 * user.height) -
              (4.330 * age);
        }
        if (user.activityLevel == "Sedentary") {
          DailyCaloricNeeds = (BMR * 1.2).round();
        } else if (user.activityLevel == "Lightly") {
          DailyCaloricNeeds = (BMR * 1.375).round();
        } else if (user.activityLevel == "Moderately") {
          DailyCaloricNeeds = (BMR * 1.55).round();
        } else if (user.activityLevel == "Very") {
          DailyCaloricNeeds = (BMR * 1.725).round();
        } else if (user.activityLevel == "Extremely") {
          DailyCaloricNeeds = (BMR * 1.9).round();
        }

        ProtenNeeds = (DailyCaloricNeeds * 0.2 / 4).round();
        CarbsNeeds = (DailyCaloricNeeds * 0.5 / 4).round();
        FatsNeeds = (DailyCaloricNeeds * 0.25 / 9).round();
        CaloricOver = (widget.dataNutrition.DailyCaloricUser > DailyCaloricNeeds
            ? widget.dataNutrition.DailyCaloricUser - DailyCaloricNeeds
            : null);
        ProtenOver =
            double.parse(widget.dataNutrition.ProtenUser).round() > ProtenNeeds
                ? double.parse(widget.dataNutrition.ProtenUser).round() -
                    ProtenNeeds
                : null;
        CarbsOver = double.parse(widget.dataNutrition.CarbsUser).round() >
                CarbsNeeds
            ? double.parse(widget.dataNutrition.CarbsUser).round() - CarbsNeeds
            : null;
        FatsOver = double.parse(widget.dataNutrition.FatsUser).round() >
                FatsNeeds
            ? double.parse(widget.dataNutrition.FatsUser).round() - FatsNeeds
            : null;
        final data = [
          Data(
              units: DailyCaloricNeeds > widget.dataNutrition.DailyCaloricUser
                  ? widget.dataNutrition.DailyCaloricUser
                  : DailyCaloricNeeds,
              color: Colors.lightBlueAccent),
          Data(units: 0, color: Colors.blueAccent),
          Data(
              units: DailyCaloricNeeds > widget.dataNutrition.DailyCaloricUser
                  ? (DailyCaloricNeeds - widget.dataNutrition.DailyCaloricUser)
                      .toInt()
                  : 0,
              color: Colors.white),
          Data(
              units: DailyCaloricNeeds < widget.dataNutrition.DailyCaloricUser
                  ? widget.dataNutrition.DailyCaloricUser - DailyCaloricNeeds
                  : 0,
              color: const Color(0xFFD50000))
        ];
        final data1 = [
          Data(
              units: ProtenNeeds >
                      double.parse(widget.dataNutrition.ProtenUser).round()
                  ? double.parse(widget.dataNutrition.ProtenUser).round()
                  : ProtenNeeds,
              color: Colors.redAccent),
          Data(units: 0, color: const Color(0xFFFF1744)),
          Data(
              units: ProtenNeeds >
                      double.parse(widget.dataNutrition.ProtenUser).round()
                  ? ProtenNeeds -
                      double.parse(widget.dataNutrition.ProtenUser).round()
                  : 0,
              color: Colors.white),
          Data(
              units: ProtenNeeds <
                      double.parse(widget.dataNutrition.ProtenUser).round()
                  ? double.parse(widget.dataNutrition.ProtenUser).round() -
                      ProtenNeeds
                  : 0,
              color: const Color(0xFFD50000)),
        ];
        final data2 = [
          Data(
              units: FatsNeeds >
                      double.parse(widget.dataNutrition.FatsUser).round()
                  ? double.parse(widget.dataNutrition.FatsUser).round()
                  : FatsNeeds,
              color: Colors.orangeAccent),
          Data(units: 0, color: Colors.deepOrangeAccent),
          Data(
              units: FatsNeeds >
                      double.parse(widget.dataNutrition.FatsUser).round()
                  ? FatsNeeds -
                      double.parse(widget.dataNutrition.FatsUser).round()
                  : 0,
              color: Colors.white),
          Data(
              units: FatsNeeds <
                      double.parse(widget.dataNutrition.FatsUser).round()
                  ? double.parse(widget.dataNutrition.FatsUser).round() -
                      FatsNeeds
                  : 0,
              color: const Color(0xFFD50000)),
        ];
        final data3 = [
          Data(
              units: CarbsNeeds >
                      double.parse(widget.dataNutrition.CarbsUser).round()
                  ? double.parse(widget.dataNutrition.CarbsUser).round()
                  : CarbsNeeds,
              color: Colors.yellow),
          Data(units: 0, color: Color(0xFFF9A825)),
          Data(
              units: CarbsNeeds >
                      double.parse(widget.dataNutrition.CarbsUser).round()
                  ? CarbsNeeds -
                      double.parse(widget.dataNutrition.CarbsUser).round()
                  : 0,
              color: Colors.white),
          Data(
              units: CarbsNeeds <
                      double.parse(widget.dataNutrition.CarbsUser).round()
                  ? double.parse(widget.dataNutrition.CarbsUser).round() -
                      CarbsNeeds
                  : 0,
              color: const Color(0xFFD50000)),
        ];
        DataNutrition dataNutrition = DataNutrition(
          data: data,
          data1: data1,
          data2: data2,
          data3: data3,
          ProtenNeeds: ProtenNeeds,
          FatsNeeds: FatsNeeds,
          CarbsNeeds: CarbsNeeds,
          DailyCaloricNeeds: DailyCaloricNeeds,
          DailyCaloricUser: widget.dataNutrition.DailyCaloricUser,
          FatsUser: widget.dataNutrition.FatsUser,
          ProtenUser: widget.dataNutrition.ProtenUser,
          CarbsUser: widget.dataNutrition.CarbsUser,
          CalariesOver: null,
          FatsOver: null,
          CarbsOver: null,
          ProtenOver: null,
          CalariesItem: null,
          FatsItem: null,
          CarbsItem: null,
          ProtenItem: null,
        );
        setState(() {
          _user = user;
          _dataNutrition = dataNutrition;
          _success = "Changes Made Successful";
          _error = null;
        });
      } else {
        setState(() {
          _error = "User already exists";
          _success = null;
        });
      }
    }
  }

  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    print(widget.user.toString());
    _nameController = TextEditingController(text: widget.user.username);
    _passwordController = TextEditingController(text: widget.user.password);

    _confirmPasswordController =
        TextEditingController(text: widget.user.password);
    _dobController = TextEditingController(text: widget.user.dob);
    _heightController =
        TextEditingController(text: widget.user.height.toString());
    _weightController =
        TextEditingController(text: widget.user.weight.toString());
    _selectedSex = widget.user.sex;
    _selectedActivityLevel = widget.user.activityLevel;
    _user = widget.user;
    _dataNutrition = widget.dataNutrition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Account")),
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
                user: _user,
                dataNutrition: _dataNutrition,
                searchData: searchData,
              ),
            ));
          }
          if (index == 0) {
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
              builder: (BuildContext context) => DashBoard(
                user: _user,
                dataNutrition: _dataNutrition,
                searchData: searchData,
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
        child: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.only(top: 16.0, left: 20, right: 20, bottom: 65),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          labelText: 'UserName',
                          labelStyle: TextStyle(color: Colors.black)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your UserName';
                        }

                        return null;
                      },
                    ),
                    if (_error != null)
                      Text(
                        _error!,
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.black)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(color: Colors.black)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        String password = _passwordController.text.trim();
                        print(password);
                        print(value);

                        if (password != value) {
                          return 'Password does not match';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Weight Kg',
                          labelStyle: TextStyle(color: Colors.black)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Weight';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Height',
                          labelStyle: TextStyle(color: Colors.black)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Height';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.none,
                      controller: _dobController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your date of birth';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Date of Birth',
                          labelStyle: TextStyle(color: Colors.black)),
                      onTap: () {
                        // Show date picker when the field is tapped
                        DatePicker.showDatePicker(
                          context,
                          onConfirm: (date) {
                            // When the user confirms the date, update the text field
                            _dobController.text =
                                DateFormat('yyyy-MM-dd').format(date);
                          },
                          currentTime: DateTime.now(),
                          locale:
                              LocaleType.en, // Change to your desired locale
                        );
                      },
                    ),
                    DropdownButtonFormField<String>(
                      dropdownColor: Colors.green[100],
                      value: _selectedSex,
                      items: _sexOptions.map((String sex) {
                        return DropdownMenuItem<String>(
                          value: sex,
                          child: Text(sex),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedSex = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: 'Sex',
                          labelStyle: TextStyle(color: Colors.black)),
                    ),
                    DropdownButtonFormField<String>(
                      dropdownColor: Colors.green[100],
                      value: _selectedActivityLevel,
                      items: _activityOptions.map((ActivityLevel activity) {
                        return DropdownMenuItem<String>(
                          value: activity.value,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activity.value,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black),
                                ),
                                Text(activity.text),
                                SizedBox(height: 16.0),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedActivityLevel = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: 'Activity Level',
                          labelStyle: TextStyle(color: Colors.black)),
                      selectedItemBuilder: (BuildContext context) {
                        return _activityOptions
                            .map<Widget>((ActivityLevel activityLevel) {
                          return Text('${activityLevel.value}');
                        }).toList();
                      },
                    ),
                    SizedBox(height: 12.0),
                    if (_success == null)
                      SizedBox(
                        width: 400,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          child: Text(
                            'Change User Detials',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                        ),
                      ),
                    if (_success != null)
                      Container(
                        width: 400,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.greenAccent,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              _success!,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: 12.0),
                    SizedBox(
                      width: 400,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) => MyApp()));
                        },
                        child: Text(
                          'Log out',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
