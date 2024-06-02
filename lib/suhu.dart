import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Suhu extends StatefulWidget {
  @override
  _SuhuState createState() => _SuhuState();
}

class _SuhuState extends State<Suhu> {
  String currentDate = '';
  String currentTime = '';
  int temperature = 0;
  int moisture = 0;
  int keudara = 0;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    FirebaseDatabase database = FirebaseDatabase(
      databaseURL: "https://agropulse-e6818-default-rtdb.asia-southeast1.firebasedatabase.app",
    );

    database.ref().child('suhu').onValue.listen((event) {
      print('Nilai dari Firebase (suhu): ${event.snapshot.value}');
      if (event.snapshot.value != null) {
        int newTemperature = int.tryParse(event.snapshot.value.toString()) ?? 0;
        setState(() {
          temperature = newTemperature;
        });
        _saveToFirestore(newTemperature, moisture, keudara);
      }
    });

    database.ref().child('kelembaban').onValue.listen((event) {
      print('Nilai dari Firebase (kelembaban): ${event.snapshot.value}');
      if (event.snapshot.value != null) {
        int newMoisture = int.tryParse(event.snapshot.value.toString()) ?? 0;
        setState(() {
          moisture = newMoisture;
        });
        _saveToFirestore(temperature, newMoisture, keudara);
      }
    });

    database.ref().child('humidity').onValue.listen((event) {
      print('Nilai dari Firebase (humidity): ${event.snapshot.value}');
      if (event.snapshot.value != null) {
        int newKeudara = int.tryParse(event.snapshot.value.toString()) ?? 0;
        setState(() {
          keudara = newKeudara;
        });
        _saveToFirestore(temperature, moisture, newKeudara);
      }
    });
  }

  void _updateDateTime() {
    setState(() {
      currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      currentTime = DateFormat('HH:mm').format(DateTime.now());
    });
  }

  Future<void> _saveToFirestore(int temperature, int moisture, int keudara) async {
    if (temperature != 0 && moisture != 0 && keudara != 0) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('agropulse').add({
        'suhu': temperature,
        'kelembaban': moisture,
        'keudara': keudara,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Kondisi Hari Ini'),
        backgroundColor: Colors.white,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildText('Tanggal:'),
            SizedBox(height: 8.0),
            _buildBox(currentDate),
            SizedBox(height: 16.0),
            _buildText('Waktu:'),
            SizedBox(height: 8.0),
            _buildBox(currentTime),
            SizedBox(height: 16.0),
            _buildText('Suhu:'),
            SizedBox(height: 8.0),
            _buildBox('$temperature °C'),
            SizedBox(height: 16.0),
            _buildText('Kelembaban:'),
            SizedBox(height: 8.0),
            _buildBox('$moisture %'),
            SizedBox(height: 16.0),
            _buildText('Kelembaban Udara:'),
            SizedBox(height: 8.0),
            _buildBox('$keudara %'),
          ],
        ),
      ),
    );
  }

  Widget _buildText(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  Widget _buildBox(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
