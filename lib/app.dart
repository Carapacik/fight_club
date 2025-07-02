import 'package:fightclub/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(textTheme: GoogleFonts.pressStart2pTextTheme()),
    title: 'Fight club',
    home: const MainPage(),
  );
}
