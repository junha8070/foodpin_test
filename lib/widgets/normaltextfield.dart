import 'package:flutter/material.dart';

class NormalTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final String helperText;
  final bool isDisabled;
  final bool isEmailType; // 이메일 타입 여부
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? Function(String)? validation;

  const NormalTextField({
    Key? key,
    this.label = "Label",
    this.hintText = 'Search',
    this.helperText = "Helper",
    this.isDisabled = false,
    this.isEmailType = false, // 기본값 false
    this.onChanged,
    this.onSubmitted,
    this.validation,
  }) : super(key: key);

  @override
  _NormalTextFieldState createState() => _NormalTextFieldState();
}

class _NormalTextFieldState extends State<NormalTextField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String? _errorText;
  bool _isFocused = false;

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
    } else if (widget.isEmailType) {
      setState(() {
        final emailRegex =
        RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
        _errorText =
        emailRegex.hasMatch(value) ? null : "Please enter a valid email address";
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
          keyboardType: widget.isEmailType ? TextInputType.emailAddress : TextInputType.text,
          onChanged: (value) {
            widget.onChanged?.call(value);
            _validate(value);
          },
          onSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: _isFocused && _controller.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                widget.onChanged?.call('');
                setState(() {});
                _validate('');
              },
            )
                : null,
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
