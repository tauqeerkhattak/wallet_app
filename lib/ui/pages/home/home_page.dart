import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wallet_app/ui/painters/card_painter.dart';

import '../../../data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<AnimationController> _controllers = [];
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
  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final size = MediaQuery.sizeOf(context);
      outOfBoundsOffset = Offset(size.width * 2, size.height * 2);

      for (int i = 0; i < cardColors.length; i++) {
        final top = -(50 * i).toDouble();
        final left = (15 * i).toDouble();
        final angleInDegrees = (-25 + (i * 3));
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
      for (final _ in dataList) {
        final controller = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 400),
          upperBound: 1.0,
          lowerBound: 0.0,
        );
        _controllers.add(controller);
      }
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
        index: savedData.index,
      );
      savedData = current;
      dataList[i] = newCurrent;
    }

    final first = dataList.first;
    dataList[dataList.length - 1] = dataList.last.copyWith(
      top: first.top,
      left: first.left,
      angleInDegrees: first.angleInDegrees,
      index: first.index,
    );
    isFirstTime = false;
    _moveControllersForward();
    print('DONE ANIMATING');
  }

  Future<void> _moveControllersForward() async {
    for (final controller in _controllers) {
      await controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
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
            dataList[i],
          ),
      ],
    );
  }

  Widget _buildCard(Data data) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final controller = _controllers[data.index];
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        log('Build AGAIN!');
        return Positioned(
          // duration: const Duration(milliseconds: 500),
          top: data.top * controller.value,
          left: data.left,
          child: CustomPaint(
            painter: CardPainter(
              color: data.color,
              index: data.index,
            ),
            child: SizedBox(
              width: width,
              height: height,
            ),
          ),
        );
      },
    );
    // final width = MediaQuery.sizeOf(context).width;
    // return AnimatedPositioned(
    //   duration: const Duration(milliseconds: 500),
    //   top: data.top,
    //   left: data.left,
    //   width: width * 1.6,
    //   child: Transform.translate(
    //     offset: Offset(width * 0.62, 0),
    //     child: AnimatedRotation(
    //       duration: const Duration(milliseconds: 500),
    //       alignment: Alignment.bottomRight,
    //       turns: data.angleInDegrees.toDouble() / 360,
    //       child: Container(
    //         height: 800,
    //         width: width * 1.6,
    //         decoration: BoxDecoration(
    //           boxShadow: kElevationToShadow[1],
    //           gradient: LinearGradient(
    //             begin: Alignment.bottomCenter,
    //             end: Alignment.topCenter,
    //             colors: [
    //               data.color.shade900,
    //               data.color,
    //               data.color.shade100,
    //             ],
    //           ),
    //         ),
    //         child: Text('${data.index}'),
    //       ),
    //     ),
    //   ),
    // );
  }

  double toRadians(int degrees) {
    return degrees * (math.pi / 180);
  }

  double toDegrees(double radians) {
    return radians * (180 / math.pi);
  }
}
