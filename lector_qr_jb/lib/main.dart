import 'package:flutter/material.dart';
import 'package:lector_qr_jb/home/screens/home_screen.dart';
import 'package:lector_qr_jb/nfc/screens/nfc_screen.dart';
import 'package:lector_qr_jb/qr/screens/qr_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _pagina_actual = 0;
  List<Widget> _paginas_home = [HomeScreen(), QrScreen(), NfcScreen()];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: _paginas_home[_pagina_actual],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _pagina_actual = index;
            });
          },
          currentIndex: _pagina_actual,
          items: const [
            BottomNavigationBarItem(label: "", icon: Icon(Icons.home)),
            BottomNavigationBarItem(label: "", icon: Icon(Icons.qr_code)),
            BottomNavigationBarItem(label: "", icon: Icon(Icons.nfc_outlined)),
          ],
        ),
      ),
    );
  }
}
