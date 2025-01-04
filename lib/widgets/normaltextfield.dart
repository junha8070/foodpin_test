import 'package:flutter/material.dart';

class NormalTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final String helperText;
  final bool isDisabled;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? Function(String)? validation; // 조건 검증 함수



  const NormalTextField({
    Key? key,
    this.label = "Label",
    this.hintText = 'Search',
    this.helperText = "Helper",
    this.isDisabled = false,
    this.onChanged,
    this.onSubmitted,
    this.validation, // 검증 함수 전달
  }) : super(key: key);

  @override
  _NormalTextFieldState createState() => _NormalTextFieldState();
}

class _NormalTextFieldState extends State<NormalTextField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String? _errorText; // 조건 위반 시 표시할 에러 메시지

  bool _isFocused = false; // 텍스트 필드가 포커스를 받았는지 여부

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange); // 포커스 상태 변경을 감지하는 리스너 추가
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // 포커스 상태가 변경되면 호출되는 함수
  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus; // 포커스를 받았으면 true, 아니면 false
    });
  }

  void _validate(String value) {
    if (widget.validation != null) {
      setState(() {
        _errorText = widget.validation!(value); // 조건 위반 시 에러 메시지 설정
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: widget.isDisabled ? Colors.grey : Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: !widget.isDisabled,
          onChanged: (value) {
            widget.onChanged?.call(value);
            _validate(value); // 입력값이 변경될 때 검증
          },
          onSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: _isFocused && _controller.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear), // 텍스트 필드에 텍스트가 있으면 'clear' 아이콘 표시
              onPressed: () {
                _controller.clear(); // 텍스트 필드 내용 삭제
                widget.onChanged?.call(''); // 텍스트가 비어있음을 알리는 콜백 호출
                setState(() {}); // 상태 갱신하여 SuffixIcon 업데이트
                _validate(''); // 입력값이 변경될 때 검증
              },
            )
                : null, // 텍스트 필드가 비어있거나 포커스를 받지 않으면 SuffixIcon 없음
            helper: _errorText != null
                ? Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  _errorText!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            )
                : Text(
              widget.helperText,
              style: const TextStyle(color: Colors.grey),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: _errorText != null ? Colors.red : Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: _errorText != null ? Colors.red : Colors.green,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            filled: widget.isDisabled,
            fillColor: widget.isDisabled ? Colors.grey[200] : Colors.white,
          ),
          style: TextStyle(
            color: widget.isDisabled ? Colors.grey : Colors.black,
          ),
        ),
      ],
    );
  }

}
