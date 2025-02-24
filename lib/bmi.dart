import 'package:flutter/material.dart';
import 'dart:math' as math;




class BMICalculator extends StatefulWidget {
  const BMICalculator({Key? key}) : super(key: key);

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  double _weight = 70;
  double _height = 170;
  String _weightUnit = 'kg';
  String _heightUnit = 'cm';
  double _bmi = 0;
  String _bmiCategory = '';
  Color _bmiColor = Colors.grey;

  // Conversion factors TO base unit (kg or cm)
  final Map<String, double> _weightConversion = {
    'kg': 1,
    'lbs': 0.453592,
    'stone': 6.35029,
  };

  final Map<String, double> _heightConversion = {
    'cm': 1,
    'm': 100,
    'ft': 30.48,
    'in': 2.54,
  };

  // Slider ranges for different units
  final Map<String, Map<String, double>> _weightRanges = {
    'kg': {'min': 20, 'max': 200},
    'lbs': {'min': 44, 'max': 440},
    'stone': {'min': 3, 'max': 31},
  };

  final Map<String, Map<String, double>> _heightRanges = {
    'cm': {'min': 100, 'max': 250},
    'm': {'min': 1, 'max': 2.5},
    'ft': {'min': 3.28, 'max': 8.2},
    'in': {'min': 39.37, 'max': 98.43},
  };

  // Convert value from one unit to another
  double _convertValue(double value, String fromUnit, String toUnit, Map<String, double> conversionFactors) {
    // First convert to base unit (kg or cm)
    double baseValue = value * conversionFactors[fromUnit]!;
    // Then convert to target unit
    return baseValue / conversionFactors[toUnit]!;
  }

  void _updateWeight(String newUnit) {
    double newWeight = _convertValue(_weight, _weightUnit, newUnit, _weightConversion);
    setState(() {
      _weight = newWeight;
      _weightUnit = newUnit;
    });
    _calculateBMI();
  }

  void _updateHeight(String newUnit) {
    double newHeight = _convertValue(_height, _heightUnit, newUnit, _heightConversion);
    setState(() {
      _height = newHeight;
      _heightUnit = newUnit;
    });
    _calculateBMI();
  }

  void _calculateBMI() {
    // Convert weight to kg
    double weightInKg = _weight * _weightConversion[_weightUnit]!;

    // Convert height to meters
    double heightInM = _height * _heightConversion[_heightUnit]! / 100;

    double bmi = weightInKg / (heightInM * heightInM);
    
    String category;
    Color color;
    
    if (bmi < 18.5) {
      category = 'Underweight';
      color = Colors.blue;
    } else if (bmi < 25) {
      category = 'Normal';
      color = Colors.green;
    } else if (bmi < 30) {
      category = 'Overweight';
      color = Colors.orange;
    } else {
      category = 'Obese';
      color = Colors.red;
    }

    setState(() {
      _bmi = bmi;
      _bmiCategory = category;
      _bmiColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Weight',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _weight.clamp(
                              _weightRanges[_weightUnit]!['min']!,
                              _weightRanges[_weightUnit]!['max']!,
                            ),
                            min: _weightRanges[_weightUnit]!['min']!,
                            max: _weightRanges[_weightUnit]!['max']!,
                            onChanged: (value) {
                              setState(() {
                                _weight = value;
                              });
                              _calculateBMI();
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        DropdownButton<String>(
                          value: _weightUnit,
                          items: ['kg', 'lbs', 'stone']
                              .map((unit) => DropdownMenuItem(
                                    value: unit,
                                    child: Text(unit),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              _updateWeight(value);
                            }
                          },
                        ),
                      ],
                    ),
                    Text(
                      '${_weight.toStringAsFixed(1)} $_weightUnit',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Height',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _height.clamp(
                              _heightRanges[_heightUnit]!['min']!,
                              _heightRanges[_heightUnit]!['max']!,
                            ),
                            min: _heightRanges[_heightUnit]!['min']!,
                            max: _heightRanges[_heightUnit]!['max']!,
                            onChanged: (value) {
                              setState(() {
                                _height = value;
                              });
                              _calculateBMI();
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        DropdownButton<String>(
                          value: _heightUnit,
                          items: ['cm', 'm', 'ft', 'in']
                              .map((unit) => DropdownMenuItem(
                                    value: unit,
                                    child: Text(unit),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              _updateHeight(value);
                            }
                          },
                        ),
                      ],
                    ),
                    Text(
                      '${_height.toStringAsFixed(1)} $_heightUnit',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            CustomPaint(
              size: const Size(200, 200),
              painter: BMIGaugePainter(
                bmi: _bmi,
                category: _bmiCategory,
                color: _bmiColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'BMI: ${_bmi.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              _bmiCategory,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: _bmiColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class BMIGaugePainter extends CustomPainter {
  final double bmi;
  final String category;
  final Color color;

  BMIGaugePainter({
    required this.bmi,
    required this.category,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0;

    // Draw background arc
    paint.color = Colors.grey.withOpacity(0.2);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      paint,
    );

    // Draw BMI indicator
    if (bmi > 0) {
      paint.color = color;
      double sweepAngle = math.pi * (bmi - 15) / 25;
      sweepAngle = sweepAngle.clamp(0, math.pi);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        math.pi,
        sweepAngle,
        false,
        paint,
      );
    }

    // Draw category markers
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final categories = ['Underweight', 'Normal', 'Overweight', 'Obese'];
    final angles = [0.0, 0.33, 0.66, 1.0];

    for (var i = 0; i < categories.length; i++) {
      final angle = math.pi + (math.pi * angles[i]);
      final x = center.dx + (radius - 40) * math.cos(angle);
      final y = center.dy + (radius - 40) * math.sin(angle);

      textPainter.text = TextSpan(
        text: categories[i],
        style: TextStyle(
          color: category == categories[i] ? color : Colors.grey,
          fontSize: 12,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant BMIGaugePainter oldDelegate) {
    return oldDelegate.bmi != bmi ||
        oldDelegate.category != category ||
        oldDelegate.color != color;
  }
}
