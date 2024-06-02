import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Grafik extends StatefulWidget {
  @override
  _GrafikState createState() => _GrafikState();
}

class _GrafikState extends State<Grafik> {
  List<double> temperature = [];
  List<double> moisture = [];

  @override
  void initState() {
    super.initState();
    initFirestoreData();
  }

  void initFirestoreData() {
    FirebaseFirestore.instance.collection('agropulse').snapshots().listen((event) {
      List<double> tempData = [];
      List<double> moistureData = [];
      
      for (var doc in event.docs) {
        var suhu = doc.data()['suhu'];
        var kelembaban = doc.data()['kelembaban'];

        if (suhu is num) {
          tempData.add(suhu.toDouble());
        }
        if (kelembaban is num) {
          moistureData.add(kelembaban.toDouble());
        }
      }
      setState(() {
        temperature = tempData;
        moisture = moistureData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (temperature.isEmpty || moisture.isEmpty) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Grafik Suhu dan Kelembapan'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.teal],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Text(
              "Grafik Suhu",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: LineChart(
                buildLineChartData(temperature),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Grafik Kelembapan",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: LineChart(
                buildLineChartData(moisture),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData buildLineChartData(List<double> data) {
    return LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(data.length, (index) {
            return FlSpot(index.toDouble(), data[index]);
          }),
          isCurved: true,
          barWidth: 4,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(show: false),
        ),
      ],
      minX: 0,
      maxX: data.length > 0 ? data.length.toDouble() - 1 : 0,
      minY: data == temperature ? 0 : 0,
      maxY: data == temperature ? 50 : 100,
      titlesData: FlTitlesData(
        leftTitles: SideTitles(
          showTitles: true,
          reservedSize: 28,
          getTextStyles: (value) => const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          margin: 12,
          interval: data == temperature ? 10 : 10,
          getTitles: (value) {
            return data == temperature ? '${value.toInt()}°C' : '${value.toInt()}%';
          },
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          margin: 12,
          interval: 1,
          getTitles: (value) {
            return '${value.toInt()}';
          },
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      gridData: FlGridData(
        show: true,
        horizontalInterval: 10,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.white,
          strokeWidth: 0.5,
        ),
        getDrawingVerticalLine: (value) => FlLine(
          color: Colors.white,
          strokeWidth: 0.5,
        ),
      ),
    );
  }
}
