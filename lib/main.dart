import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foodpin/widgets/customswitch.dart'; // Import the CustomSwitch widget
import 'package:foodpin/widgets/hidetextfield.dart';
import 'package:foodpin/widgets/normaltextfield.dart';
import 'package:foodpin/widgets/customcheckbox.dart'; // Import the CustomCheckbox widget
import 'firebase_options.dart';
import 'widgets/customsearchfield.dart'; // Import the SearchBar widget

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is properly initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomSearchField(
                  hintText: '검색',
                  onChanged: (text) {
                    print('Search Field Searching: $text');
                  },
                  onSubmitted: (text) {
                    print('Search Field Search Completed: $text');
                  },
                ),
                const SizedBox(height: 16),
                NormalTextField(
                  label: 'Email',
                  hintText: '이메일을 입력해주세요.',
                  helperText: '',
                  validation: (value) {
                    if (value.isEmpty) {
                      return '빈 칸은 좀..';
                    } else if (!value.contains('@')) {
                      return '골뱅이 넣어봐';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    print('Input: $text');
                  },
                ),
                HideTextField(
                  label: '비밀번호',
                  hintText: '비밀번호',
                  helperText: '',
                  validation: (value) {
                    if (value.isEmpty) {
                      return '빈칸은 No~';
                    } else if (value.length < 6) {
                      return '6자리 이상 입력해주세요.';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    print('Input: $text');
                  },
                ),
                const SizedBox(height: 16),
                CustomCheckbox(
                  itemCount: 5, // Total number of checkboxes
                  columns: 2, // Number of columns
                  isSelectAllEnabled: true, // Enable "전체 선택"
                  checkboxTexts: [
                    "체크박스 1",
                    "체크박스 2",
                    "체크박스 3",
                    "체크박스 4",
                    "체크박스 5"
                  ], // Custom texts for checkboxes
                ),
                const SizedBox(height: 16),
                // CustomSwitch 추가 부분
                CustomSwitch(
                  text: '알림', // 왼쪽 텍스트
                  showBorder: true,
                  initialValue: true, // 초기 상태 true (켜짐)
                  onChanged: (value) {
                    print("Notification Setting: $value");
                  },
                ),
                const SizedBox(height: 16),
                CustomSwitch(
                  text: '추천 받기', // 다른 텍스트와 초기 상태
                  showBorder: false,
                  initialValue: false, // 초기 상태 false (꺼짐)
                  onChanged: (value) {
                    print("Location Setting: $value");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
