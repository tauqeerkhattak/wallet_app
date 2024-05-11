import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MaterialColor> cardColors = [
    Colors.purple,
    Colors.amber,
    Colors.cyan,
    Colors.orange,
    Colors.green,
    Colors.yellow,
    Colors.red,
    Colors.blue,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        for (int i = cardColors.length - 1; i >= 0; i--) _buildContainer(i),
      ],
    );
  }

  Widget _buildContainer(int index) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Positioned(
      top: -(50 * index).toDouble(),
      left: (15 * index).toDouble(),
      width: width * 1.6,
      child: Transform.translate(
        offset: Offset(width * 0.3, height * 0.2),
        child: RotationTransition(
          turns: AlwaysStoppedAnimation((-25 + (index * 3)) / 360),
          child: Container(
            height: 700,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  cardColors[index].shade900,
                  cardColors[index],
                  cardColors[index].shade100,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double toRadians(int degrees) {
    return degrees * (pi / 180);
  }
}
