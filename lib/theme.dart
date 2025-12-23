import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color posColor;
  final Color clubNameColor;
  final Color surfaceColor;
  final Color surfaceColorLight;
  final Color darkGreen;
  final Color green;
  final Color lightGreen;
  final Color red;
  final Color yellow;

  const AppColors({
    required this.posColor,
    required this.clubNameColor,
    required this.surfaceColor,
    required this.surfaceColorLight,
    required this.darkGreen,
    required this.green,
    required this.lightGreen,
    required this.red,
    required this.yellow,
  });

  @override
  AppColors copyWith({
    Color? posColor,
    Color? clubNameColor,
    Color? surfaceColor,
    Color? surfaceColorLight,
    Color? darkGreen,
    Color? green,
    Color? lightGreen,
    Color? red,
    Color? yellow,
  }) {
    return AppColors(
      posColor: posColor ?? this.posColor,
      clubNameColor: clubNameColor ?? this.clubNameColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      surfaceColorLight: surfaceColorLight ?? this.surfaceColorLight,
      darkGreen: darkGreen ?? this.darkGreen,
      green: green ?? this.green,
      lightGreen: lightGreen ?? this.lightGreen,
      red: red ?? this.red,
      yellow: yellow ?? this.yellow,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      posColor: Color.lerp(posColor, other.posColor, t)!,
      clubNameColor: Color.lerp(clubNameColor, other.clubNameColor, t)!,
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t)!,
      surfaceColorLight:
          Color.lerp(surfaceColorLight, other.surfaceColorLight, t)!,
      darkGreen: Color.lerp(darkGreen, other.darkGreen, t)!,
      green: Color.lerp(green, other.green, t)!,
      lightGreen: Color.lerp(lightGreen, other.lightGreen, t)!,
      red: Color.lerp(red, other.red, t)!,
      yellow: Color.lerp(yellow, other.yellow, t)!,
    );
  }
}

class ThemeClass {
  static const Color _posColor = Color(0xffccff00);
  static const Color _clubNameColor = Color(0xff4af1f2);
  static const Color _surfaceColor = Color(0xFF1E2228);
  static const Color _surfaceColorLight = Color(0xFF2C3036);
  static const Color _darkGreen = Color(0xff007700);
  static const Color _green = Color(0xff00aa00);
  static const Color _lightGreen = Color(0xff75df3d);
  static const Color _red = Color(0xffdd4400);
  static const Color _yellow = Color(0xffe6b600);

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      secondary: _posColor,
    ),
    extensions: const <ThemeExtension<dynamic>>[
      AppColors(
        posColor: _posColor,
        clubNameColor: _clubNameColor,
        surfaceColor: Color(0xFFF0F0F0), // Light mode alternative?
        surfaceColorLight: Color(0xFFFFFFFF),
        darkGreen: _darkGreen,
        green: _green,
        lightGreen: _lightGreen,
        red: _red,
        yellow: _yellow,
      ),
    ],
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark(
      primary: _clubNameColor, // Cyan as primary in dark mode
      secondary: _posColor, // Lime as secondary
      surface: _surfaceColor,
      background: Colors.black,
    ),
    extensions: const <ThemeExtension<dynamic>>[
      AppColors(
        posColor: _posColor,
        clubNameColor: _clubNameColor,
        surfaceColor: _surfaceColor,
        surfaceColorLight: _surfaceColorLight,
        darkGreen: _darkGreen,
        green: _green,
        lightGreen: _lightGreen,
        red: _red,
        yellow: _yellow,
      ),
    ],
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.grey[600]),
    ),
  );
}
