import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<MaterialColor> cardColors = [
    Colors.pink,
    Colors.amber,
    Colors.cyan,
    Colors.orange,
    Colors.green,
    Colors.yellow,
    Colors.red,
    Colors.blue,
  ];
  List<Data> dataList = [];
  bool isAnimating = false;
  late Offset outOfBoundsOffset;
  late Data savedData;
  int count = 0;
  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final size = MediaQuery.sizeOf(context);
      outOfBoundsOffset = Offset(size.width * 2, size.height * 2);

      for (int i = 0; i < cardColors.length; i++) {
        final top =
            size.width > 600 ? -(60 * i).toDouble() : -(50 * i).toDouble();
        final left = (15 * i).toDouble();
        final angleInDegrees =
            size.width > 600 ? (-18 + (i * 3)) : (-25 + (i * 3));
        final data = Data(
          index: i,
          top: top,
          left: left,
          angleInDegrees: angleInDegrees,
          color: cardColors[i],
        );
        dataList.add(data);
      }
      dataList.add(
        Data(
          index: 7,
          top: outOfBoundsOffset.dy,
          left: outOfBoundsOffset.dx,
          angleInDegrees: (-25 + (7 * 3)),
          color: cardColors[7],
        ),
      );
      count = dataList.length;
    });
  }

  Future<void> _handleDownGesture() async {
    savedData = dataList.last;
    for (int i = dataList.length - 1; i >= 0; i--) {
      Data current = dataList[i];
      Data newCurrent = current.copyWith(
        top: savedData.top,
        left: savedData.left,
        angleInDegrees: savedData.angleInDegrees,
      );
      savedData = current;
      dataList[i] = newCurrent;
    }

    final first = dataList.first;
    dataList[dataList.length - 1] = dataList.last.copyWith(
      top: first.top,
      left: first.left,
      // index: count,
      angleInDegrees: first.angleInDegrees,
    );
    count++;
    isFirstTime = false;
    _controller.forward(from: 0.0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (isAnimating) {
          return;
        }
        isAnimating = true;
        if (details.delta.dy > 0) {
          _handleDownGesture();
        } else if (details.delta.dy < 0) {
          print('UP');
        }
      },
      onPanEnd: (details) {
        isAnimating = false;
        print('DONE ANIMATING');
      },
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    dataList.sort((date1, date2) {
      return date2.index.compareTo(date1.index);
    });
    return Stack(
      children: [
        for (int i = 0; i < dataList.length; i++)
          _buildCard(
            _controller.value,
            dataList[i],
          ),
      ],
    );
  }

  Widget _buildCard(double animation, Data data) {
    final width = MediaQuery.sizeOf(context).width;
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      top: data.top,
      left: data.left,
      width: width * 1.6,
      child: Transform.translate(
        offset: Offset(
          width > 600 ? 280 : width * 0.725,
          width > 600 ? -300 : 0,
        ),
        child: Transform.rotate(
          angle: toRadians(data.angleInDegrees),
          alignment: Alignment.bottomRight,
          child: Container(
            height: width > 600 ? 1200 : 800,
            width: width * 1.6,
            decoration: BoxDecoration(
              boxShadow: kElevationToShadow[1],
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  data.color.shade900,
                  data.color,
                  data.color.shade100,
                ],
              ),
            ),
            // child: Text(
            //   '${data.index}',
            //   style: TextStyle(
            //     fontSize: 100,
            //   ),
            // ),
          ),
        ),
      ),
    );
  }

  double toRadians(int degrees) {
    return degrees * (math.pi / 180);
  }

  double toDegrees(double radians) {
    return radians * (180 / math.pi);
  }
}
