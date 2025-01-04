import 'package:flutter/material.dart';

class HideTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final String helperText;
  final bool isDisabled;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? Function(String)? validation;

  const HideTextField({
    Key? key,
    this.label = "Password",
    this.hintText = 'Enter your password',
    this.helperText = "Helper",
    this.isDisabled = false,
    this.onChanged,
    this.onSubmitted,
    this.validation,
  }) : super(key: key);

  @override
  _HideTextFieldState createState() => _HideTextFieldState();
}

class _HideTextFieldState extends State<HideTextField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String? _errorText;
  bool _isFocused = false;
  bool _isObscured = true; // 비밀번호 숨김 여부

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _validate(String value) {
    if (widget.validation != null) {
      setState(() {
        _errorText = widget.validation!(value);
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
            _validate(value);
          },
          onSubmitted: widget.onSubmitted,
          obscureText: _isObscured, // 입력값 숨김 여부
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_controller.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      widget.onChanged?.call('');
                      setState(() {}); // 상태 갱신
                      _validate(''); // 입력값 검증
                    },
                  ),
                IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured; // 숨김 상태 토글
                    });
                  },
                ),
              ],
            ),
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
