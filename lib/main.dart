import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myassistantv2/core/services/get_language.dart';
import 'package:myassistantv2/ui/pages/splash.dart';
import 'package:myassistantv2/ui/widgets/theme.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: <AppTheme>[
        customLight(),
        customDark(),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ThemeConsumer(
          child: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    Timer(Duration(milliseconds: 800), () => GetLanguage.initPlatformState(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: Scaffold(body: Splash()),
    );
  }
}
