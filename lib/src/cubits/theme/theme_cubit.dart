import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  onThemeChange(ThemeMode? theme) {
    final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: theme == ThemeMode.system
            ? (brightness == Brightness.dark ? Colors.black : Colors.white)
            : (theme == ThemeMode.dark ? Colors.black : Colors.white),
      ),
    );
    emit(state.copyWith(selectedTheme: theme));
  }
}
