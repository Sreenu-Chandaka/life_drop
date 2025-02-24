import 'package:flutter/material.dart';
import 'package:heart_bpm/heart_bpm.dart';
import 'package:heart_bpm/chart.dart';

class PulseMonitorScreen extends StatefulWidget {
  @override
  _PulseMonitorScreenState createState() => _PulseMonitorScreenState();
}

class _PulseMonitorScreenState extends State<PulseMonitorScreen> {
  List<SensorValue> data = [];
  List<SensorValue> bpmValues = [];
  bool isMonitoring = false;
  Widget? dialog;
  int currentBPM = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pulse Monitor'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // BPM Display
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 40,
                ),
                SizedBox(width: 10),
                Text(
                  '$currentBPM BPM',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Camera BPM Widget
          isMonitoring
              ? HeartBPMDialog(
                  context: context,
                  showTextValues: true,
                  borderRadius: 10,
                  onRawData: (value) {
                    setState(() {
                      // Update graph with raw sensor data
                      if (data.length >= 100) data.removeAt(0);
                      data.add(value);
                    });
                  },
                  onBPM: (value) {
                    setState(() {
                      // Update BPM value
                      currentBPM = value.toInt();
                      
                      // Store BPM values for trending
                      if (bpmValues.length >= 100) bpmValues.removeAt(0);
                      bpmValues.add(SensorValue(
                        value: value.toDouble(),
                        time: DateTime.now(),
                      ));
                    });
                  },
                )
              : Container(
                  height: 200,
                  child: Center(
                    child: Text(
                      'Camera preview will appear here',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                ),

          // Raw Data Chart
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Raw Sensor Data',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: data.isEmpty
                        ? Center(
                            child: Text(
                              'No data available',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : BPMChart(data),
                  ),
                ],
              ),
            ),
          ),

          // BPM Trend Chart
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'BPM Trend',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: bpmValues.isEmpty
                        ? Center(
                            child: Text(
                              'No BPM data available',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : BPMChart(bpmValues),
                  ),
                ],
              ),
            ),
          ),

          // Control Button
          Container(
            padding: EdgeInsets.all(20),
            child: ElevatedButton.icon(
              icon: Icon(
                isMonitoring ? Icons.stop : Icons.favorite,
                size: 30,
              ),
              label: Text(
                isMonitoring ? 'Stop Measurement' : 'Measure BPM',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), backgroundColor: isMonitoring ? Colors.red : Colors.green,
              ),
              onPressed: () {
                setState(() {
                  isMonitoring = !isMonitoring;
                  if (!isMonitoring) {
                    // Clear data when stopping
                    data.clear();
                    bpmValues.clear();
                    currentBPM = 0;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
