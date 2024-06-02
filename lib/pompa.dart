import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Pompa extends StatefulWidget {
  @override
  _PompaState createState() => _PompaState();
}

class _PompaState extends State<Pompa> {
  bool _pompaStatus = false; // Default status pompa mati

  @override
  void initState() {
    super.initState();
    _fetchPompaStatus();
  }

  void _fetchPompaStatus() {
    FirebaseDatabase database = FirebaseDatabase(
      databaseURL: "https://agropulse-e6818-default-rtdb.asia-southeast1.firebasedatabase.app/",
    );
    database.ref().child('pompa').onValue.listen((event) {
      print('Nilai dari Firebase: ${event.snapshot.value}');
      if (event.snapshot.value != null) {
        setState(() {
          _pompaStatus = event.snapshot.value as bool;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pompa Air'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.purple],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Status Pompa',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Container(
              height: 200,
              color: Colors.black12,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/pompa air.png',
                      width: 100,
                    ),
                    SizedBox(height: 8.0),
                    _pompaStatus
                        ? Text(
                            'Pompa Menyala',
                            style: TextStyle(color: Colors.green, fontSize: 24),
                          )
                        : Text(
                            'Pompa Mati',
                            style: TextStyle(color: Colors.red, fontSize: 24),
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}
