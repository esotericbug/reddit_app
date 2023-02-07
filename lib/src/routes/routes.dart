import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reddit_app/src/blocs/drawer_search/drawer_search_bloc.dart';
import 'package:reddit_app/src/cubits/link_detail_data/link_detail_data_cubit.dart';
import 'package:reddit_app/src/cubits/listing/listing_cubit.dart';
import 'package:reddit_app/src/cubits/listing_screen/listing_screen_cubit.dart';
import 'package:reddit_app/src/models/listing_response_model.dart';
import 'package:reddit_app/src/screens/link_detail_screen.dart';
import 'package:reddit_app/src/screens/listing_screen.dart';
import 'package:reddit_app/src/screens/settings_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    return PageTransition(
      type: PageTransitionType.rightToLeftWithFade,
      settings: routeSettings,
      child: Builder(
        builder: (context) {
          final arguments = routeSettings.arguments;
          switch (routeSettings.name) {
            case SettingsView.routeName:
              {
                return const SettingsView();
              }
            case ListingScreen.routeName:
              {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context) => ListingCubit()),
                    BlocProvider(create: (context) => ListingScreenCubit()),
                    BlocProvider(create: (context) => DrawerSearchBloc()),
                  ],
                  child: Builder(
                    builder: (context) {
                      if (arguments == null) return const ListingScreen();
                      final args = arguments as Map<String, dynamic>;
                      return ListingScreen(subreddit: args['subreddit'] as String);
                    },
                  ),
                );
              }
            case LinkDetailScreen.routeName:
              {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context) => LinkDetailDataCubit()),
                  ],
                  child: Builder(
                    builder: (context) {
                      if (arguments == null) return const LinkDetailScreen();
                      final args = arguments as Map<String, dynamic>;
                      return LinkDetailScreen(item: args['item'] as LinkResponse);
                    },
                  ),
                );
              }
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
