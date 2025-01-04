import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final int itemCount;
  final int columns;
  final bool isSelectAllEnabled;
  final List<String> checkboxTexts;

  const CustomCheckbox({
    Key? key,
    required this.itemCount,
    required this.columns,
    required this.isSelectAllEnabled,
    required this.checkboxTexts,
  }) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool isAllSelected;
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    isAllSelected = false;
    isSelected = List<bool>.filled(widget.itemCount, false);
  }

  void toggleAll(bool? value) {
    setState(() {
      isAllSelected = value ?? false;
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = isAllSelected;
      }
    });
  }

  void toggleIndividual(int index, bool? value) {
    setState(() {
      isSelected[index] = value ?? false;
      isAllSelected = isSelected.every((element) => element);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final childAspectRatio = (screenWidth / widget.columns) / 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isSelectAllEnabled)
          Row(
            children: [
              GestureDetector(
                onTap: () => toggleAll(!isAllSelected),
                child: _buildCheckbox(isAllSelected, isAllSelected),
              ),
              const SizedBox(width: 8),
              const Text("전체 선택", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold )),
            ],
          ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.columns,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: widget.itemCount,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => toggleIndividual(index, !isSelected[index]),
              child: Row(
                children: [
                  _buildCheckbox(isSelected[index], isAllSelected),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.checkboxTexts.length > index
                          ? widget.checkboxTexts[index]
                          : "Checkbox ${index + 1}",
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCheckbox(bool isChecked, bool isAllChecked) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: isAllChecked && isChecked ? Color(0xff1275ff) : Colors.white,
        border: Border.all(
          color: isChecked ? Color(0xff1275ff) : Colors.grey, // 체크 여부에 따른 테두리 색상 변경
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: isChecked
          ? Icon(
        Icons.check,
        color: isAllChecked ? Colors.white : Color(0xff1275ff),
        size: 16,
      )
          : null,
    );
  }
}
