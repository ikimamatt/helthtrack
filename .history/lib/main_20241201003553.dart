import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'bmi.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthTrack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isImperial = true;
  String? selectedGender;
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  final _nameController = TextEditingController(); // Name field

  // Save data to Firestore
  void saveDataToFirestore() {
    FirebaseFirestore.instance.collection('users').add({
      'name': _nameController.text,
      'gender': selectedGender,
      'height': _heightController.text,
      'weight': _weightController.text,
      'age': _ageController.text,
    }).then((value) {
      print('Data saved successfully!');
    }).catchError((error) {
      print('Failed to save data: $error');
    });
  }

  Widget buildInputField(String label, String hint1, String? hint2,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 113, 0, 0),
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller, // Use the passed controller here
                decoration: InputDecoration(
                  hintText: hint1,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 30),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            if (hint2 != null) ...[
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: hint2,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 30),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget buildSingleInputField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 113, 0, 0),
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _ageController,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 30),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 113, 0, 0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'HealthTrack',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Icon(Icons.language, color: Colors.white),
                SizedBox(width: 16),
                Icon(Icons.search, color: Colors.white),
                SizedBox(width: 16),
                Icon(Icons.menu, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
            ),
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Periksa IMT Anda!',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 113, 0, 0),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _nameController, // Name input field
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = 'Laki-laki';
                        });
                      },
                      child: GenderWidget(
                        imageUrl:
                            'https://storage.googleapis.com/a1aa/image/qPK628f1bE1SSyAlu07M2cHSZ2JhswBjley29tJUboEAO5rTA.jpg',
                        label: 'Laki-laki',
                        labelColor: selectedGender == 'Laki-laki'
                            ? const Color.fromARGB(255, 113, 0, 0)
                            : Colors.grey,
                      ),
                    ),
                    SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = 'Perempuan';
                        });
                      },
                      child: GenderWidget(
                        imageUrl:
                            'https://storage.googleapis.com/a1aa/image/GkJ4YYgGDXYMHhYUG4s4uo1S2cWBk2I7cYboW5WwZXrgTe1JA.jpg',
                        label: 'Perempuan',
                        labelColor: selectedGender == 'Perempuan'
                            ? const Color.fromARGB(255, 113, 0, 0)
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Metric',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Switch(
                      value: isImperial,
                      onChanged: (value) {
                        setState(() {
                          isImperial = value;
                        });
                      },
                      activeColor: Color.fromARGB(255, 113, 0, 0),
                    ),
                    Text(
                      'Imperial',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 113, 0, 0)),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                buildInputField(
                  'Height',
                  isImperial ? 'ft' : 'cm',
                  isImperial ? 'in' : null,
                  _heightController, // Pass height controller
                ),
                SizedBox(height: 16),
                buildInputField(
                  'Weight',
                  isImperial ? 'st' : 'kg',
                  isImperial ? 'lb' : null,
                  _weightController, // Pass weight controller
                ),
                SizedBox(height: 16),
                buildSingleInputField('Age', 'years'),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    saveDataToFirestore(); // Save data to Firestore
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BMICalculator(
                          height: _heightController.text,
                          weight: _weightController.text,
                          isImperial: isImperial,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 113, 0, 0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Hitung BMI',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget tambahan untuk gender
class GenderWidget extends StatelessWidget {
  final String imageUrl;
  final String label;
  final Color labelColor;

  const GenderWidget({
    Key? key,
    required this.imageUrl,
    required this.label,
    required this.labelColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(
          imageUrl,
          width: 100,
          height: 100,
          color: labelColor == Colors.blue ? Colors.blue : null,
          colorBlendMode: labelColor == Colors.blue ? BlendMode.srcATop : null,
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: labelColor, fontSize: 16),
        ),
      ],
    );
  }
}
