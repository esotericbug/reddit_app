// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:reddit_app/src/cubits/listing_screen/listing_screen_cubit.dart';
import 'package:reddit_app/src/cubits/search/search_cubit.dart';
import 'package:reddit_app/src/helpers/general.dart';
import 'package:reddit_app/src/widgets/global_left_drawer.dart';
import 'package:reddit_app/src/widgets/inner_drawer.dart';
import 'package:reddit_app/src/widgets/link_card_widget.dart';
import 'package:rxdart/rxdart.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = 'search_screen';
  final String? subreddit;
  final String? query;
  final bool? restrict;
  const SearchScreen({this.subreddit, this.query, this.restrict = true, super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ModalRoute<dynamic>? _route;
  ScrollController scollController = ScrollController();
  // GlobalKey<State> key = GlobalKey();
  final BehaviorSubject<bool> _isOpenController = BehaviorSubject<bool>.seeded(false);

  bool get isOpen => _isOpenController.value;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context
          .read<SearchCubit>()
          .search(subreddit: widget.subreddit, query: widget.query, restrict: widget.restrict ?? true);
    });
    super.initState();
  }

  @override
  void dispose() {
    _route?.removeScopedWillPopCallback(askForExit);
    _route = null;
    scollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _route?.removeScopedWillPopCallback(askForExit);
    _route = ModalRoute.of(context);
    _route?.addScopedWillPopCallback(askForExit);
  }

  Future<bool> askForExit() async {
    if (!isOpen) return showExitPopup(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, listingState) {
        return InnerDrawer(
          innerDrawerCallback: (isOpened) {
            _isOpenController.add(isOpened);
          },
          context: context,
          leftChild: const GlobalSearch(),
          scaffold: Scaffold(
            floatingActionButton: BlocBuilder<ListingScreenCubit, ListingScreenState>(
              builder: (context, listingScreenState) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: listingScreenState.floatingButtonVisible
                      ? FloatingActionButton(
                          onPressed: () async {
                            context.read<ListingScreenCubit>().updateScrollPosition(scollController.position.pixels);
                            scollController.jumpTo(0);
                            if (!mounted) return;
                            await showSnackBar(
                              value: const Text('Go back ?'),
                              duration: const Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'OK',
                                textColor:
                                    Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                                onPressed: () {
                                  scollController.jumpTo(context.read<ListingScreenCubit>().state.scrollPosition);
                                },
                              ),
                            );
                          },
                          child: const Icon(Icons.arrow_upward),
                        )
                      : const SizedBox.shrink(),
                );
              },
            ),
            body: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollUpdateNotification) {
                  if (scrollNotification.metrics.pixels < 500) {
                    context.read<ListingScreenCubit>().updateFloatingVisibility(false);
                  } else if (scrollNotification.metrics.pixels == scrollNotification.metrics.minScrollExtent) {
                    context.read<ListingScreenCubit>().updateFloatingVisibility(false);
                  } else {
                    if (scrollNotification.scrollDelta! > 0) {
                      context.read<ListingScreenCubit>().updateFloatingVisibility(false);
                      context.read<ListingScreenCubit>().updateScrollDirection(ScrollDirection.reverse);
                    } else {
                      context.read<ListingScreenCubit>().updateFloatingVisibility(true);
                      context.read<ListingScreenCubit>().updateScrollDirection(ScrollDirection.forward);
                    }
                  }
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () => context.read<SearchCubit>().fetchMoreSearch(
                    subreddit: widget.subreddit, restrict: widget.restrict ?? true, query: widget.query),
                child: Builder(
                  builder: (context) {
                    if (listingState.isFetching && (listingState.children?.isEmpty ?? true)) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Center(
                          child: RefreshProgressIndicator(),
                        ),
                      );
                    }
                    return CustomScrollView(
                      controller: scollController,
                      slivers: [
                        if (listingState.isFetching && (listingState.children?.isEmpty ?? true))
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Center(
                                child: RefreshProgressIndicator(),
                              ),
                            ),
                          )
                        else ...[
                          SliverAppBar(
                            floating: true,
                            leading: ModalRoute.of(context) != null && !ModalRoute.of(context)!.isFirst
                                ? IconButton(
                                    icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                : Builder(builder: (context) {
                                    return IconButton(
                                      icon: const Icon(Icons.menu),
                                      onPressed: () {
                                        InnerDrawer.of(context)?.open(direction: InnerDrawerDirection.start);
                                      },
                                    );
                                  }),
                            title: Text(
                              (listingState.subreddit ?? ''),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                                fontSize: 20,
                              ),
                            ),
                            actions: [
                              Row(
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Icon(Icons.search),
                                    ),
                                    onTap: () {
                                      showMaterialModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            constraints:
                                                BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .8),
                                            child: GlobalSearch(inSubreddit: true, subreddit: listingState.subreddit),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Icon(Icons.sort),
                                    ),
                                    onTap: () {},
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Icon(Icons.more_vert),
                                    ),
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (!listingState.isFetching && listingState.error != null)
                            SliverToBoxAdapter(
                                child: Text('${listingState.error?.message}\nCode: ${listingState.error?.error}'))
                          else
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  if (index == listingState.children?.length) {
                                    if (listingState.isFetching && (listingState.children?.isNotEmpty ?? true)) {
                                      return const Center(
                                        child: RefreshProgressIndicator(),
                                      );
                                    } else {
                                      context.read<SearchCubit>().fetchMoreSearch(
                                          subreddit: widget.subreddit,
                                          restrict: widget.restrict ?? true,
                                          query: widget.query);
                                      return const SizedBox();
                                    }
                                  }
                                  final item = listingState.children?[index];
                                  return LinkCardWidget(
                                    item: item,
                                    subreddit: listingState.subreddit,
                                  );
                                },
                                childCount: (listingState.children?.length ?? 0) + 1,
                              ),
                            )
                        ]
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
