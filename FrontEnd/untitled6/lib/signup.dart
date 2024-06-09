import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled6/main.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import 'dashboard.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class ActivityLevel {
  final String value;
  final String text;

  ActivityLevel({required this.value, required this.text});
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  String? _error;
  List<String> _sexOptions = ['Male', 'Female'];
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

  String _selectedSex = "Male";
  String _selectedActivityLevel = "Sedentary";

  void _toggleSignInSignUp() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) => MyApp(),
    ));
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
      final url = Uri.parse('http://100.91.248.174:8000/users');
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
      final response = await http.post(url, headers: headers, body: body);
      print("Ssssssssssssss+${response.statusCode}");
      if (response.statusCode == 201) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => MyApp(),
        ));
      } else if (response.statusCode == 400) {
        setState(() {
          _error = "User already exists";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Image.asset(
                    'images/FoodGuruLogo.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                Text(
                  "FoodGuru",
                  style: GoogleFonts.zenDots(
                    textStyle: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 20, right: 20),
                  child: Form(
                    key: _formKey,
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
                          obscureText: true,
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
                          obscureText: true,
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
                              locale: LocaleType
                                  .en, // Change to your desired locale
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
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text(
                            'Sign Up',
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
                            'Already have an account? Sign In',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
    ;
  }
}
