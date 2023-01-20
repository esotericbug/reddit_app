import 'package:dynamic_color/dynamic_color.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/src/cubits/theme/theme_cubit.dart';
import 'package:reddit_app/src/helpers/general.dart';
import 'package:reddit_app/src/routes/routes.dart';
import 'package:reddit_app/src/screens/listing_screen.dart';

/// The Widget that configures your application.
class App extends StatefulWidget {
  const App({
    super.key,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    context.read<ThemeCubit>().onThemeChange(brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light);
    super.didChangePlatformBrightness();
  }

  ThemeData lightTheme(ColorScheme? lightDynamic) {
    final theme = FlexThemeData.light(
      colorScheme: lightDynamic,
      useMaterial3: true,
      lightIsWhite: true,
    );
    return theme;
  }

  ThemeData darkTheme(ColorScheme? darkDynamic) {
    final theme = FlexThemeData.dark(
      colorScheme: darkDynamic,
      useMaterial3: true,
      darkIsTrueBlack: true,
    );
    return theme;
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme(lightDynamic),
              darkTheme: darkTheme(darkDynamic),
              scaffoldMessengerKey: snackbarKey,
              themeMode: themeState.selectedTheme,
              initialRoute: ListingScreen.routeName,
              builder: (context, child) => ScrollConfiguration(
                behavior: CustomScrollBehavior(),
                child: child ?? const SizedBox.shrink(),
              ),
              onGenerateRoute: RouteGenerator.generateRoute,
            );
          },
        );
      },
    );
  }
}
