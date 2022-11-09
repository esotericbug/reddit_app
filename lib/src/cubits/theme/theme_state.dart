part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final ThemeMode selectedTheme;
  const ThemeState({this.selectedTheme = ThemeMode.system});

  @override
  List<Object> get props => [selectedTheme];

  ThemeState copyWith({
    ThemeMode? selectedTheme,
  }) {
    return ThemeState(
      selectedTheme: selectedTheme ?? this.selectedTheme,
    );
  }
}
