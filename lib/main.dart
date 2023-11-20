import 'package:flutter/material.dart';
import 'dart:async';

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
  _PomodoroTimerState createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  Timer? _timer;
  int _selectedTime = 15;
  int _timeLeft;
  int _cyclesCompleted = 0;
  int _roundsCompleted = 0;

  bool isRunning = false;

  _PomodoroTimerState() : _timeLeft = 15 * 60;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        isRunning = true;
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          timer.cancel();
          _cyclesCompleted++;
          if (_cyclesCompleted % 4 == 0) {
            _roundsCompleted++;
          }
          _timeLeft = _selectedTime * 60;
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void _resetTimer() {
    setState(() {
      _timer?.cancel();
      _timeLeft = _selectedTime * 60;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
                        child: Center(
                          child: Text(
                            '${_timeLeft ~/ 60}',
                            style: const TextStyle(
                              fontSize: 64,
                              color: Color(0xFFE64D3D),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
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
                        child: Center(
                          child: Text(
                            (_timeLeft % 60).toString().padLeft(2, '0'),
                            style: const TextStyle(
                              fontSize: 64,
                              color: Color(0xFFE64D3D),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [15, 20, 25, 30, 35].map((int value) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTime = value;
                              _timeLeft = _selectedTime * 60;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
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
    );
  }
}
