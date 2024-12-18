import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BMICalculator extends StatefulWidget {
  final String height;
  final String weight;
  final bool isImperial;

  const BMICalculator(
      {super.key, required this.height, required this.weight, required this.isImperial});

  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  late double bmi;
  late String resultText;

  @override
  void initState() {
    super.initState();
    calculateBMI();
  }

  void calculateBMI() {
    double height = double.tryParse(widget.height) ?? 0;
    double weight = double.tryParse(widget.weight) ?? 0;

    if (widget.isImperial) {
      height = height * 0.0254; // inches to meters
      weight = weight * 0.453592; // pounds to kg
    } else {
      height = height / 100; // cm to meters
    }

    if (height > 0 && weight > 0) {
      setState(() {
        bmi = weight / (height * height);
        resultText = getBMICategory();
      });
    } else {
      setState(() {
        bmi = 0.0;
        resultText = 'Please enter valid height and weight.';
      });
    }
  }

  String getBMICategory() {
    if (bmi < 18.5) {
      return 'Underweight. Increase your calorie intake.';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Normal weight. Maintain your current lifestyle.';
    } else if (bmi >= 25 && bmi < 29.9) {
      return 'Overweight. Consider a balanced diet and exercise.';
    } else {
      return 'Obesity. Consult a healthcare provider for guidance.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 113, 0, 0),
        title: const Text(
          'BMI Calculator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.orangeAccent, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12.0,
                spreadRadius: 6.0,
              ),
            ],
          ),
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10.0),
              const Icon(
                Icons.accessibility_new,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 15.0),
              const Text(
                'Your BMI Results',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Your BMI: ${bmi.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                resultText,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton.icon(
                onPressed: () async {
                  const url = 'https://www.halodoc.com/tanya-dokter';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 113, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                ),
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                label: const Text(
                  'Consult with Nutritionist',
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
    );
  }
}
