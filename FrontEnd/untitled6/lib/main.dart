import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled6/dashboard.dart';
import 'package:untitled6/signup.dart';
import 'package:intl/intl.dart';

import 'homepage.dart';
import 'horizontalgraph.dart';

void main() {
  runApp(const MyApp());
}

class User {
  final int id;
  final String username;
  final String sex;
  final int weight;
  final int height;
  final String dob;
  final String activityLevel;
  final String password;

  User(
      {required this.id,
      required this.username,
      required this.sex,
      required this.weight,
      required this.height,
      required this.dob,
      required this.activityLevel,
      required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      sex: json['sex'],
      weight: json['weight'],
      height: json['height'],
      dob: json['dob'],
      activityLevel: json['activityLevel'],
      password: json['password'],
    );
  }
  @override
  String toString() {
    return 'User{id: $id, username: $username,sex: $sex, weight: $weight,height: $height, dob: $dob, activityLevel: $activityLevel,password: $password}';
  }
}

class DailyNutrionData {
  final int id;
  final String user_id;
  final String date;
  final int cals;
  final String protein;
  final String fats;
  final String carbs;

  DailyNutrionData({
    required this.id,
    required this.user_id,
    required this.date,
    required this.cals,
    required this.protein,
    required this.fats,
    required this.carbs,
  });

  factory DailyNutrionData.fromJson(Map<String, dynamic> json) {
    return DailyNutrionData(
      id: json['id'],
      user_id: json['user_id'],
      date: json['date'],
      cals: json['cals'],
      protein: json['protein'],
      fats: json['fats'],
      carbs: json['carbs'],
    );
  }
}

class DataNutrition {
  final data;
  final data1;
  final data2;
  late final data3;
  final DailyCaloricNeeds;
  final FatsNeeds;
  final CarbsNeeds;
  final ProtenNeeds;
  final DailyCaloricUser;
  final FatsUser;
  final CarbsUser;
  final ProtenUser;
  final CalariesOver;
  final FatsOver;
  final CarbsOver;
  final ProtenOver;
  final CalariesItem;
  final FatsItem;
  final CarbsItem;
  final ProtenItem;

  DataNutrition({
    required this.data,
    required this.data1,
    required this.data2,
    required this.data3,
    required this.DailyCaloricNeeds,
    required this.FatsNeeds,
    required this.CarbsNeeds,
    required this.ProtenNeeds,
    required this.DailyCaloricUser,
    required this.FatsUser,
    required this.CarbsUser,
    required this.ProtenUser,
    required this.CalariesOver,
    required this.FatsOver,
    required this.CarbsOver,
    required this.ProtenOver,
    required this.CalariesItem,
    required this.FatsItem,
    required this.CarbsItem,
    required this.ProtenItem,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      home: const RootPage(),
    );
  }

  ThemeData _buildTheme(brightness) {
    MaterialColor mycolor = const MaterialColor(
      0xFF69F0AE,
      <int, Color>{
        50: Color(0xFF69F0AE),
        100: Color(0xFF69F0AE),
        200: Color(0xFF69F0AE),
        300: Color(0xFF69F0AE),
        400: Color(0xFF69F0AE),
        500: Color(0xFF69F0AE),
        600: Color(0xFF69F0AE),
        700: Color(0xFF69F0AE),
        800: Color(0xFF69F0AE),
        900: Color(0xFF69F0AE),
      },
    );
    var baseTheme = ThemeData(
      brightness: brightness,
      primarySwatch: mycolor,
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   Timer(
  //     Duration(seconds: 1),
  //     () => Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(
  //         builder: (BuildContext context) => SignInSignUp(),
  //       ),
  //     ),
  //   );
  // }
  String? _errorPassword;
  String? _errorName;

  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    DateTime today = DateTime.now().toLocal();
    DateTime datetoday = DateTime(today.year, today.month, today.day);

    void _toggleSignInSignUp() {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => SignUp(),
      ));
    }

    Future<void> fetchEndpoint() async {}
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
      String name = _nameController.text.trim();
      String password = _passwordController.text.trim();
      int DailyCaloricNeeds = 0;
      int ProtenNeeds = 0;
      int CarbsNeeds = 0;
      int FatsNeeds = 0;
      int? CaloricOver = 0;
      int? ProtenOver = 0;
      int? CarbsOver = 0;
      int? FatsOver = 0;
      List<SearchData> searchData = [];

      // Perform form validation and sign up or sign in logic here
      // You can implement your own logic for sign up and sign in, such as calling APIs or interacting with a database

      // Sign in logic
      print('Signing in with email: $name and password: $password');

      final url = Uri.parse('http://100.91.248.174:8000/user/verification');
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode({'username': name, 'password': password});
      final response = await http.post(url, headers: headers, body: body);
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

      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        User user = User.fromJson(jsonMap);
        final url2 =
            Uri.parse('http://100.91.248.174:8000/dailyNutritionForUser');
        final headers2 = {'Content-Type': 'application/json'};
        final body2 = json.encode({
          "user_id": user.id,
          "date": DateFormat('yyyy-MM-dd').format(datetoday),
        });
        final response2 = await http.post(url2, headers: headers2, body: body2);

        if (response2.statusCode == 200 || response2.statusCode == 201) {
          final jsonMap2 = jsonDecode(response2.body);
          print(response2.statusCode);
          print(jsonMap2);
          DailyNutrionData dailyNutrionData =
              DailyNutrionData.fromJson(jsonMap2);
          print(dailyNutrionData);
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
            setState(() {
              DailyCaloricNeeds = (BMR * 1.2).round();
            });
            ;
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
          CaloricOver = (dailyNutrionData.cals > DailyCaloricNeeds
              ? dailyNutrionData.cals - DailyCaloricNeeds
              : null);
          ProtenOver =
              double.parse(dailyNutrionData.protein).round() > ProtenNeeds
                  ? double.parse(dailyNutrionData.protein).round() - ProtenNeeds
                  : null;
          CarbsOver = double.parse(dailyNutrionData.carbs).round() > CarbsNeeds
              ? double.parse(dailyNutrionData.carbs).round() - CarbsNeeds
              : null;
          FatsOver = double.parse(dailyNutrionData.fats).round() > FatsNeeds
              ? double.parse(dailyNutrionData.fats).round() - FatsNeeds
              : null;
          final data = [
            Data(units: DailyCaloricNeeds > dailyNutrionData.cals
                    ? dailyNutrionData.cals
                    : DailyCaloricNeeds, color: Colors.lightBlueAccent),
            Data(units: 0, color: Colors.blueAccent),
            Data(
                units: DailyCaloricNeeds > dailyNutrionData.cals
                    ? DailyCaloricNeeds - dailyNutrionData.cals
                    : 0,
                color: Colors.white),
            Data(
                units: DailyCaloricNeeds < dailyNutrionData.cals
                    ? dailyNutrionData.cals - DailyCaloricNeeds
                    : 0,
                color: const Color(0xFFD50000))
          ];
          final data1 = [
            Data(
                units: ProtenNeeds > double.parse(dailyNutrionData.protein).round()
                    ? double.parse(dailyNutrionData.protein).round()
                    : ProtenNeeds,
                color: Colors.redAccent),
            Data(units: 0, color: const Color(0xFFFF1744)),
            Data(
                units:
                    ProtenNeeds > double.parse(dailyNutrionData.protein).round()
                        ? ProtenNeeds -
                            double.parse(dailyNutrionData.protein).round()
                        : 0,
                color: Colors.white),
            Data(
                units:
                    ProtenNeeds < double.parse(dailyNutrionData.protein).round()
                        ? double.parse(dailyNutrionData.protein).round() -
                            ProtenNeeds
                        : 0,
                color: const Color(0xFFD50000)),
          ];
          final data2 = [
            Data(
                units: FatsNeeds > double.parse(dailyNutrionData.fats).round()
                    ? double.parse(dailyNutrionData.fats).round()
                    : FatsNeeds,
                color: Colors.orangeAccent),
            Data(units: 0, color: Colors.deepOrangeAccent),
            Data(
                units:
                    FatsNeeds > double.parse(dailyNutrionData.fats).round()
                        ? FatsNeeds -
                            double.parse(dailyNutrionData.fats).round()
                        : 0,
                color: Colors.white),
            Data(
                units: FatsNeeds < double.parse(dailyNutrionData.fats).round()
                    ? double.parse(dailyNutrionData.fats).round() - FatsNeeds
                    : 0,
                color: const Color(0xFFD50000)),
          ];
          final data3 = [
            Data(
                units: CarbsNeeds > double.parse(dailyNutrionData.carbs).round()
                    ? double.parse(dailyNutrionData.carbs).round()
                    : CarbsNeeds,
                color: Colors.yellow),
            Data(units: 0, color: Color(0xFFF9A825)),
            Data(
                units: CarbsNeeds > double.parse(dailyNutrionData.carbs).round()
                    ? CarbsNeeds - double.parse(dailyNutrionData.carbs).round()
                    : 0,
                color: Colors.white),
            Data(
                units: CarbsNeeds < double.parse(dailyNutrionData.carbs).round()
                    ? double.parse(dailyNutrionData.carbs).round() - CarbsNeeds
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
            DailyCaloricUser: dailyNutrionData.cals,
            FatsUser: double.parse(dailyNutrionData.fats).round(),
            ProtenUser: double.parse(dailyNutrionData.protein).round(),
            CarbsUser: double.parse(dailyNutrionData.carbs).round(),
            CalariesOver: CaloricOver,
            FatsOver: FatsOver,
            CarbsOver: CarbsOver,
            ProtenOver: ProtenOver,
            CalariesItem: null,
            FatsItem: null,
            CarbsItem: null,
            ProtenItem: null,
          );

          // handle successful response
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => DashBoard(
                user: user,
                dataNutrition: dataNutrition,
                searchData: searchData),
          ));
        }
      } else if (response.statusCode == 404) {
        setState(() {
          _errorName = "User not found";
          _errorPassword = null;
        });
      } else if (response.statusCode == 403) {
        setState(() {
          _errorPassword = "Password incorrect";
          _errorName = null;
        });
      }
    }

    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        // Box decoration takes a gradient
        gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Colors.green,
            Colors.greenAccent,
            Colors.greenAccent,
            Colors.white,
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 128),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Image.asset('images/FoodGuruLogo.png'),
                ),
                Text(
                  "FoodGuru",
                  style: GoogleFonts.zenDots(
                    textStyle: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        obscureText: true,
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
                      if (_errorName != null)
                        Text(
                          _errorName!,
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
                      if (_errorPassword != null)
                        Text(
                          _errorPassword!,
                          style: TextStyle(color: Colors.red),
                        ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextButton(
                        onPressed: _toggleSignInSignUp,
                        child: Text(
                          'Don\'t have an account? Sign Up',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
