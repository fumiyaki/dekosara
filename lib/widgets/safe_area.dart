
import 'package:flutter/material.dart';

class SafeAreaSample extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
              child: Row(
                children: <Widget>[
                  Container(
                    color: Colors.blue,
                    width: 200,
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
}