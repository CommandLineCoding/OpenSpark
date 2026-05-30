import 'package:flutter/material.dart';

@immutable
class TerminalColors extends ThemeExtension<TerminalColors> {
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color neutralBg;

  const TerminalColors({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.neutralBg,
  });

  @override
  TerminalColors copyWith({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? neutralBg,
  }) {
    return TerminalColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      neutralBg: neutralBg ?? this.neutralBg,
    );
  }

  @override
  TerminalColors lerp(ThemeExtension<TerminalColors>? other, double t) {
    if (other is! TerminalColors) return this;
    return TerminalColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      neutralBg: Color.lerp(neutralBg, other.neutralBg, t)!,
    );
  }
}

extension TerminalThemeOnContext on BuildContext {
  TerminalColors get terminalColors =>
      Theme.of(this).extension<TerminalColors>()!;
  TextTheme get terminalText => Theme.of(this).textTheme;
}
