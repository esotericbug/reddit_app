import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/src/blocs/drawer_search/drawer_search_bloc.dart';
import 'package:reddit_app/src/cubits/theme/theme_cubit.dart';
import 'package:reddit_app/src/screens/listing_screen.dart';
import 'package:reddit_app/src/screens/search_screen.dart';

class GlobalSearch extends StatelessWidget {
  final bool inSubreddit;
  final String? subreddit;
  const GlobalSearch({this.inSubreddit = false, this.subreddit, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DrawerSearchBloc(),
      child: _SearchWrap(inSubreddit, subreddit: subreddit),
    );
  }
}

class _SearchWrap extends StatefulWidget {
  final bool inSubreddit;
  final String? subreddit;
  const _SearchWrap(this.inSubreddit, {this.subreddit});

  @override
  State<_SearchWrap> createState() => __SearchWrapState();
}

class __SearchWrapState extends State<_SearchWrap> {
  DrawerSearchBloc? searchBloc;
  Timer? _debounce;
  TextEditingController textController = TextEditingController();

  _onSearchChanged(String value) {
    if (value.isNotEmpty) {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 200), () {
        context.read<DrawerSearchBloc>().add(DrawerSearchItems(value));
      });
    } else {
      _debounce?.cancel();
      context.read<DrawerSearchBloc>().add(const DrawerSearchItems(null));
    }
  }

  @override
  void didChangeDependencies() {
    final DrawerSearchBloc filtersBloc = BlocProvider.of<DrawerSearchBloc>(context);
    setState(() {
      searchBloc = filtersBloc;
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchBloc?.add(const DrawerSearchItems(null));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: [
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Theme',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      DropdownButton<ThemeMode>(
                        value: themeState.selectedTheme,
                        onChanged: context.read<ThemeCubit>().onThemeChange,
                        items: const [
                          DropdownMenuItem(
                            value: ThemeMode.system,
                            child: Text(
                              'System Theme',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                            ),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.light,
                            child: Text(
                              'Light Theme',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                            ),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.dark,
                            child: Text(
                              'Dark Theme',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            BlocBuilder<DrawerSearchBloc, DrawerSearchState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: TextFormField(
                        controller: textController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          suffixIcon: textController.text.isNotEmpty
                              ? InkWell(
                                  child: const Icon(
                                    Icons.close,
                                    size: 20,
                                  ),
                                  onTap: () {
                                    _debounce?.cancel();
                                    textController.clear();
                                    searchBloc?.add(const DrawerSearchItems(null));
                                  },
                                )
                              : null,
                        ),
                        onChanged: _onSearchChanged,
                      ),
                    ),
                    if (textController.text.isNotEmpty)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: const Text('Search all'),
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                Navigator.of(context).pushNamed(SearchScreen.routeName, arguments: {
                                  'subreddit': null,
                                  'query': textController.text,
                                  'restrict': false,
                                });
                              },
                            ),
                          ),
                          if (widget.inSubreddit && widget.subreddit != null && (widget.subreddit?.isNotEmpty ?? false))
                            Expanded(
                              child: OutlinedButton(
                                child: Text('Search ${widget.subreddit}'),
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  Navigator.of(context).pushNamed(SearchScreen.routeName, arguments: {
                                    'subreddit': widget.subreddit,
                                    'query': textController.text,
                                    'restrict': true
                                  });
                                },
                              ),
                            )
                        ],
                      ),
                    if (state.isFetching && (state.children == null))
                      const Center(
                        child: RefreshProgressIndicator(),
                      )
                    else
                      ...?state.children
                          ?.where((child) => child.data?.displayName != null && child.data!.displayName!.isNotEmpty)
                          .map(
                            (child) => InkWell(
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                Navigator.of(context).pushNamed(ListingScreen.routeName, arguments: {
                                  'subreddit': child.data?.displayName,
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15.0,
                                      foregroundImage:
                                          child.data?.communityIcon != null && child.data!.communityIcon!.isNotEmpty
                                              ? Image.network(
                                                  "${child.data?.communityIcon}",
                                                  fit: BoxFit.contain,
                                                  cacheHeight: 50,
                                                ).image
                                              : null,
                                      child: const Text('r'),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text('${child.data?.displayName}'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
