// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reddit_app/src/cubits/listing/listing_cubit.dart';
import 'package:reddit_app/src/cubits/listing_screen/listing_screen_cubit.dart';
import 'package:reddit_app/src/helpers/general.dart';
import 'package:reddit_app/src/widgets/link_card_widget.dart';
import 'package:reddit_app/src/widgets/overlapping_panels.dart';

class CalcPosition {
  final double x;
  final double y;
  CalcPosition({
    required this.x,
    required this.y,
  });
}

class CalcSize {
  final double width;
  final double height;
  CalcSize({
    required this.width,
    required this.height,
  });
}

class ListingScreen extends StatefulWidget {
  static const routeName = 'listing_screen';
  final String subreddit;
  const ListingScreen({this.subreddit = 'supermodelindia', super.key});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  ScrollController scollController = ScrollController();
  GlobalKey<State> key = GlobalKey();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<ListingCubit>().fetchInitial(subreddit: widget.subreddit);
    });
    super.initState();
  }

  @override
  void dispose() {
    scollController.dispose();
    super.dispose();
  }

  CalcPosition getPositions(GlobalKey key) {
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset.zero);
    return CalcPosition(x: position?.dx ?? 0, y: position?.dy ?? 0);
  }

  CalcSize getSizes(GlobalKey key) {
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size;
    return CalcSize(width: size?.width ?? 0, height: size?.height ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListingCubit, ListingState>(
      builder: (context, listingState) {
        return BlocBuilder<ListingScreenCubit, ListingScreenState>(
          builder: (context, listingScreenState) {
            return Scaffold(
              floatingActionButton: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: listingScreenState.floatingButtonVisible
                    ? FloatingActionButton(
                        onPressed: () async {
                          context.read<ListingScreenCubit>().updateScrollPosition(scollController.position.pixels);
                          scollController.jumpTo(0);
                          if (!mounted) return;
                          await showSnackBar(
                            value: const Text('Go back ?'),
                            action: SnackBarAction(
                              label: 'OK',
                              textColor: Theme.of(context).primaryColorDark,
                              onPressed: () {
                                scollController.jumpTo(context.read<ListingScreenCubit>().state.scrollPosition);
                              },
                            ),
                          );
                        },
                        child: const Icon(Icons.arrow_upward),
                      )
                    : const SizedBox.shrink(),
              ),
              body: OverlappingPanels(
                left: Drawer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DrawerHeader(
                        decoration: BoxDecoration(color: Theme.of(context).primaryColorDark),
                        child: const Text('Welcome'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(),
                      )
                    ],
                  ),
                ),
                // right: Drawer(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.stretch,
                //     children: [
                //       DrawerHeader(
                //         decoration: BoxDecoration(color: Theme.of(context).primaryColorDark),
                //         child: const Text('Welcome'),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: TextFormField(),
                //       )
                //     ],
                //   ),
                // ),
                main: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification) {
                      if ((getPositions(key).y) > 0) {
                        final t = (1.0 - (getPositions(key).y) / getSizes(key).height).clamp(0.0, 1.0);
                        final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / getSizes(key).height);
                        final opacity = 1.0 - Interval(fadeStart, 1).transform(t);
                        context.read<ListingScreenCubit>().updateOpacity(opacity);
                      }
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
                    onRefresh: () => context.read<ListingCubit>().fetchInitial(subreddit: widget.subreddit),
                    child: BlocBuilder<ListingScreenCubit, ListingScreenState>(
                      builder: (context, listingScreenState) {
                        return CustomScrollView(
                          controller: scollController,
                          slivers: [
                            if (listingState.isFetching && listingState.children == null ||
                                listingState.children!.isEmpty)
                              const SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: Center(
                                    child: RefreshProgressIndicator(),
                                  ),
                                ),
                              )
                            else ...[
                              SliverAnimatedOpacity(
                                opacity: listingScreenState.lastScrollDirection == ScrollDirection.forward ||
                                        scollController.position.minScrollExtent == scollController.position.pixels ||
                                        scollController.position.pixels < 200
                                    ? 1
                                    : 0,
                                duration: const Duration(milliseconds: 300),
                                sliver: SliverIgnorePointer(
                                  ignoring: !(listingScreenState.lastScrollDirection == ScrollDirection.forward ||
                                      scollController.position.minScrollExtent == scollController.position.pixels ||
                                      scollController.position.pixels < 200),
                                  sliver: SliverAppBar.medium(
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
                                                OverlappingPanels.of(context)?.reveal(RevealSide.left);
                                              },
                                            );
                                          }),
                                    title: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${listingState.subreddit?.toTitleCase()}',
                                          style: TextStyle(
                                            color: Theme.of(context).textTheme.bodyText1?.color,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const Icon(Icons.arrow_drop_down)
                                      ],
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
                                            onTap: () {},
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
                                ),
                              ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    if (index == listingState.children!.length) {
                                      if (listingState.isFetching &&
                                          listingState.children != null &&
                                          listingState.children!.isNotEmpty) {
                                        return const Center(
                                          child: RefreshProgressIndicator(),
                                        );
                                      } else {
                                        context.read<ListingCubit>().fetchMore(subreddit: widget.subreddit);
                                        return const SizedBox();
                                      }
                                    }
                                    final item = listingState.children?[index];
                                    return LinkCardWidget(
                                      item: item,
                                      subreddit: listingState.subreddit,
                                    );
                                  },
                                  childCount: listingState.children!.length + 1,
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
      },
    );
  }
}
