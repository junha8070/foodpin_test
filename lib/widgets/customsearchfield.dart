import 'package:flutter/material.dart';

class CustomSearchField extends StatefulWidget {
  // CustomSearchField 위젯의 속성 정의
  final String hintText; // 텍스트 필드에 기본적으로 표시될 힌트 텍스트
  final bool isDisabled; // 텍스트 필드가 비활성화된 상태인지 여부
  final Function(String)? onChanged; // 텍스트가 변경될 때 호출되는 콜백 함수
  final Function(String)? onSubmitted; // 텍스트가 제출될 때 호출되는 콜백 함수

  // 생성자
  const CustomSearchField({
    Key? key,
    this.hintText = 'Search', // 기본 힌트 텍스트는 'Search'
    this.isDisabled = false, // 기본값은 비활성화되지 않은 상태
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  _CustomSearchFieldState createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  // 텍스트 필드를 제어할 텍스트 편집기와 포커스를 관리할 FocusNode
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _isFocused = false; // 텍스트 필드가 포커스를 받았는지 여부

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange); // 포커스 상태 변경을 감지하는 리스너 추가
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange); // 리스너 제거
    _controller.dispose(); // 텍스트 편집기 해제
    _focusNode.dispose(); // FocusNode 해제
    super.dispose();
  }

  // 포커스 상태가 변경되면 호출되는 함수
  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus; // 포커스를 받았으면 true, 아니면 false
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller, // 텍스트 편집기 연결
      focusNode: _focusNode, // 포커스 노드 연결
      enabled: !widget.isDisabled, // 텍스트 필드가 비활성화되었으면 입력 불가
      onChanged: (value) {
        widget.onChanged?.call(value); // 텍스트가 변경되면 onChanged 콜백 호출
        setState(() {}); // 변경사항 반영하여 상태 갱신 (SuffixIcon 갱신)
      },
      onSubmitted: widget.onSubmitted, // 텍스트 제출 시 onSubmitted 콜백 호출
      decoration: InputDecoration(
        hintText: widget.hintText, // 힌트 텍스트 설정
        prefixIcon: const Icon(Icons.search), // 검색 아이콘을 텍스트 필드 앞에 추가
        suffixIcon: _isFocused && _controller.text.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.clear), // 텍스트 필드에 텍스트가 있으면 'clear' 아이콘 표시
          onPressed: () {
            _controller.clear(); // 텍스트 필드 내용 삭제
            widget.onChanged?.call(''); // 텍스트가 비어있음을 알리는 콜백 호출
            setState(() {}); // 상태 갱신하여 SuffixIcon 업데이트
          },
        )
            : null, // 텍스트 필드가 비어있거나 포커스를 받지 않으면 SuffixIcon 없음
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // 필드 테두리를 둥글게 설정
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey, // 비포커스 상태에서 테두리 색상
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.green, // 포커스 상태에서 테두리 색상
            width: 2, // 두께 설정
          ),
        ),
        filled: widget.isDisabled, // 텍스트 필드가 비활성화된 경우 배경 채우기
        fillColor: widget.isDisabled ? Colors.grey[200] : Colors.white, // 비활성화된 경우 회색 배경
      ),
      style: TextStyle(
        color: widget.isDisabled ? Colors.grey : Colors.black, // 비활성화된 텍스트 색상
      ),
    );
  }
}
