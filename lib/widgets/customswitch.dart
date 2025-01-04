import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final String text;
  final bool initialValue;
  final ValueChanged<bool> onChanged;
  final bool showBorder; // CustomSwitch 전체에 테두리 표시 여부

  CustomSwitch({
    required this.text,
    required this.initialValue,
    required this.onChanged,
    this.showBorder = false, // 기본값: 테두리 없음
  });

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  late bool _isToggled;

  @override
  void initState() {
    super.initState();
    _isToggled = widget.initialValue;
  }

  void _toggleSwitch(bool value) {
    setState(() {
      _isToggled = value;
    });
    widget.onChanged(_isToggled);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.showBorder
          ? BoxDecoration(
        border: Border.all(
          color: Colors.grey, // 테두리 색상
          width: 1.0, // 테두리 두께
        ),
        borderRadius: BorderRadius.circular(10.0), // 둥근 테두리
      )
          : null, // 테두리 없음
      padding: const EdgeInsets.all(8.0), // 테두리와 내용 사이의 간격
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.text), // 왼쪽 텍스트
          GestureDetector(
            onTap: () => _toggleSwitch(!_isToggled),
            child: Container(
              width: 60.0,
              height: 30.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: _isToggled ? Color(0xff1275ff) : Colors.grey,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: AnimatedAlign(
                  duration: Duration(milliseconds: 200),
                  alignment: _isToggled ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 22.0,
                    height: 22.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
