import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reddit_app/src/cubits/listing/listing_cubit.dart';
import 'package:reddit_app/src/cubits/listing_screen/listing_screen_cubit.dart';
import 'package:reddit_app/src/screens/listing_screen.dart';
import 'package:reddit_app/src/screens/settings_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    return PageTransition(
      type: PageTransitionType.rightToLeftWithFade,
      settings: routeSettings,
      child: Builder(
        builder: (context) {
          switch (routeSettings.name) {
            case SettingsView.routeName:
              return const SettingsView();
            case ListingScreen.routeName:
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => ListingCubit(),
                  ),
                  BlocProvider(
                    create: (context) => ListingScreenCubit(),
                  ),
                ],
                child: const ListingScreen(),
              );
            default:
              return const ErrorRoute();
          }
        },
      ),
    );
  }
}

class ErrorRoute extends StatelessWidget {
  const ErrorRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: const Text('Error'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Page Not Found'),
      ),
    );
  }
}
