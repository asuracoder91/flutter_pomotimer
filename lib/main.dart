import 'package:chal2/flip_clock.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:lottie/lottie.dart';

void main() {
  runApp(const Pomotimer());
}

class Pomotimer extends StatelessWidget {
  const Pomotimer({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Pomotimer',
      debugShowCheckedModeBanner: false,
      home: PomodoroTimer(),
    );
  }
}

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer>
    with SingleTickerProviderStateMixin {
  bool showAnimation = false;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 500,
    ),
  );

  Timer? _timer;
  int _selectedTime = 15;
  int _timeLeft;
  int _cyclesCompleted = 0;
  int _roundsCompleted = 0;
  final ScrollController _scrollController = ScrollController();
  bool isRunning = false;

  double buttonWidth = 60.0;

  _PomodoroTimerState() : _timeLeft = 15 * 60;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    setState(() {
      isRunning = true;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _stopTimer();

        setState(() {
          _roundsCompleted++;
          showAnimation = true;
          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              showAnimation = false;
            });
          });
          if (_roundsCompleted % 4 == 0) {
            _roundsCompleted = 0;
            _cyclesCompleted++;
          }
          _timeLeft = _selectedTime * 60;
        });
      }
    });
  }

  void _stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      setState(() {
        isRunning = false;
      });
    }
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _timer?.cancel();
      _timeLeft = _selectedTime * 60;
    });
  }

  void _scrollToCenter(int value) {
    double buttonWidth = 60;
    double buttonSpacing = 20;

    double buttonStart = (buttonWidth + buttonSpacing) * value;
    double centerPosition = buttonStart + buttonSpacing / 2;

    _scrollController.animateTo(
      centerPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE64D3D),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'POMOTIMER',
                          style: TextStyle(
                            fontSize: 18,
                            letterSpacing: 2,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      fit: FlexFit.tight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              width: 120,
                              height: 140,
                              child: FlipClock(
                                currentTime: _timeLeft ~/ 60,
                              )),
                          const SizedBox(
                            width: 20,
                            height: 140,
                            child: Center(
                              child: Text(
                                ':',
                                style: TextStyle(
                                  fontSize: 64,
                                  color: Color(0xFFF0918A),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            width: 120,
                            height: 140,
                            child: FlipClock(
                              currentTime: _timeLeft % 60,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 2 -
                                buttonWidth / 2),
                        children: [15, 20, 25, 30, 35].map((int value) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedTime = value;
                                _timeLeft = _selectedTime * 60;
                              });
                              _scrollToCenter(
                                  [15, 20, 25, 30, 35].indexOf(value));
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: 60,
                              decoration: BoxDecoration(
                                  color: value == _selectedTime
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: const Color(0xFFFFA59D),
                                    width: 1,
                                  )),
                              child: Center(
                                child: Text(
                                  '$value',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: value == _selectedTime
                                        ? const Color(0xFFE64D3D)
                                        : const Color(0xFFFFA59D),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      fit: FlexFit.tight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(isRunning
                                ? Icons.pause_circle_outline
                                : Icons.play_circle_outline),
                            onPressed: isRunning ? _stopTimer : _startTimer,
                            iconSize: 80,
                            color: Colors.white,
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: _resetTimer,
                            iconSize: 80,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text('$_roundsCompleted/4',
                                  style: const TextStyle(
                                      color: Color(0xFFFFA59D),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600)),
                              const Text('ROUND',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ))
                            ],
                          ),
                          Column(
                            children: [
                              Text('$_cyclesCompleted/12',
                                  style: const TextStyle(
                                      color: Color(0xFFFFA59D),
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600)),
                              const Text('GOAL',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Visibility(
              visible: showAnimation,
              child: Lottie.asset(
                'assets/done.json',
                repeat: false,
                onLoaded: (composition) {
                  _controller.duration = composition.duration;
                  _controller.forward();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
