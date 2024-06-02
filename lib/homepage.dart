import 'package:flutter/material.dart';
import 'beranda.dart'; // Import halaman login

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('AGROPULSE'),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.purple],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo AGROPULSE
                Image.asset(
                  'assets/images/logo.png',
                  width: 200, // Ubah ukuran gambar agar sesuai
                  height: 200, // Ubah ukuran gambar agar sesuai
                ),
                SizedBox(height: 20),
                Text(
                  'The Best Solution For Your Garden',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Beranda()),
                    );
                  },
                  child: Text("MASUK"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
