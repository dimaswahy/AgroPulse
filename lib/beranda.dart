import 'package:flutter/material.dart';
import 'package:agropulse/grafik.dart';
import 'package:agropulse/pompa.dart';
import 'package:agropulse/suhu.dart';

class Beranda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Halo Selamat Datang'),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.teal],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Suhu()),
                  );
                },
                imageAsset: 'assets/images/kelembaban.png',
                text: 'Kondisi Hari Ini',
              ),
              SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Grafik()),
                  );
                },
                imageAsset: 'assets/images/grafik.png',
                text: 'Grafik Suhu & Kelembaban',
              ),
              SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Pompa()),
                  );
                },
                imageAsset: 'assets/images/pompa.png',
                text: 'Status Pompa',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String imageAsset;
  final String text;

  CustomElevatedButton({
    required this.onPressed,
    required this.imageAsset,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
      ),
      child: Row(
        children: [
          Image.asset(
            imageAsset,
            width: 50,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
