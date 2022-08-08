import 'package:amtstester/home.dart';
import 'package:amtstester/http_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

late HttpClient httpClient;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  httpClient = HttpClient(Client());
  runApp(const MyApp());
}

MaterialColor materialStateColor = const MaterialColor(500, <int, Color>{
  50: Color(0x00033c99),
  100: Color(0x00033c99),
  200: Color(0x00033c99),
  300: Color(0x00033c99),
  400: Color(0x00033c99),
  500: Color(0x0000033c),
  600: Color(0x00033c99),
  700: Color(0x00033c99),
  800: Color(0x00033c99),
  900: Color(0x00033c99),
});

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AntiAMTS Tester',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        primarySwatch: materialStateColor,
      ),
      home: const Home(),
    );
  }
}
