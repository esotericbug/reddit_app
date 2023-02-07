import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/src/cubits/theme/theme_cubit.dart';
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );
  await SystemChrome.setPreferredOrientations(
    DeviceOrientation.values,
  );
//    await SystemChrome.setEnabledSystemUIMode(
//     SystemUiMode.edgeToEdge,
//     overlays: SystemUiOverlay.values,
//   );
// await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
// SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       systemNavigationBarContrastEnforced: false,
//       systemNavigationBarColor: Colors.transparent,
//       systemNavigationBarIconBrightness: Brightness.dark,
//       statusBarIconBrightness: Brightness.dark,
//       statusBarColor: Colors.transparent,
//     ),
//   );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: const App(),
    ),
  );
}
