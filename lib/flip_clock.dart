import 'package:flutter/material.dart';

class FlipClock extends StatefulWidget {
  final int currentTime;

  const FlipClock({Key? key, required this.currentTime}) : super(key: key);

  @override
  State<FlipClock> createState() => _FlipClockState();
}

class _FlipClockState extends State<FlipClock>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late int _displayedTime; // 화면에 표시될 시간

  @override
  void initState() {
    super.initState();
    _displayedTime = widget.currentTime; // 초기 표시 시간 설정
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 0.5).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          // 애니메이션이 완료되면 화면에 표시될 시간을 업데이트
          _displayedTime = widget.currentTime;
        });
        _controller.reset();
      }
    });
  }

  @override
  void didUpdateWidget(FlipClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    // currentTime이 바뀌었는지 체크하고 애니메이션 시작
    if (widget.currentTime != oldWidget.currentTime) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 애니메이션 값에 따라 카드가 플립되는 각도 계산
    final angle = (_animation.value) * 3.1415926535897932;
    return Transform(
      alignment: Alignment.bottomCenter,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // 3D 효과를 위한 perspective
        ..rotateX(angle),
      child: CardContainer(time: _displayedTime),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CardContainer extends StatelessWidget {
  final int time;

  const CardContainer({Key? key, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 시간을 문자열로 변환하고, 한 자리 숫자일 경우 앞에 0을 채워줍니다.
    final String displayTime = time.toString().padLeft(2, '0');

    return Container(
      width: 120,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Text(
          displayTime,
          style: const TextStyle(
            fontSize: 64,
            color: Color(0xFFE64D3D),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
