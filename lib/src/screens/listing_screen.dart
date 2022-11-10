import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/src/cubits/listing/listing_cubit.dart';
import 'package:reddit_app/src/cubits/listing_screen/listing_screen_cubit.dart';
import 'package:reddit_app/src/helpers/general.dart';
import 'package:reddit_app/src/widgets/link_card_widget.dart';

class ListingScreen extends StatefulWidget {
  static const routeName = 'listing_screen';
  const ListingScreen({super.key});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  ScrollController scollController = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<ListingCubit>().fetchInitial();
    });
    super.initState();
  }

  @override
  void dispose() {
    scollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListingCubit, ListingState>(
      builder: (context, listingState) {
        return BlocBuilder<ListingScreenCubit, ListingScreenState>(
          builder: (context, listingScreenState) {
            return Scaffold(
              floatingActionButton: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: listingScreenState.floatingButtonVisible ? 1 : 0,
                child: FloatingActionButton(
                  onPressed: () async {
                    context.read<ListingScreenCubit>().updateScrollPosition(scollController.position.pixels);
                    await scollController.animateTo(0,
                        duration: const Duration(milliseconds: 1000), curve: Curves.ease);
                    if (!mounted) return;
                    await showSnackBar(
                      value: const Text('Go back ?'),
                      action: SnackBarAction(
                        label: 'Ok',
                        textColor: Theme.of(context).primaryColorDark,
                        onPressed: () async {
                          await scollController.animateTo(context.read<ListingScreenCubit>().state.scrollPosition,
                              duration: const Duration(milliseconds: 1000), curve: Curves.ease);
                        },
                      ),
                    );
                  },
                  child: const Icon(Icons.arrow_upward),
                ),
              ),
              body: RefreshIndicator(
                onRefresh: context.read<ListingCubit>().fetchInitial,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification) {
                      if (scrollNotification.metrics.pixels == scrollNotification.metrics.minScrollExtent) {
                        context.read<ListingScreenCubit>().updateFloatingVisibility(false);
                      } else {
                        if (scrollNotification.scrollDelta! > 0) {
                          context.read<ListingScreenCubit>().updateFloatingVisibility(false);
                        } else {
                          context.read<ListingScreenCubit>().updateFloatingVisibility(true);
                        }
                      }
                    }
                    return true;
                  },
                  child: CustomScrollView(
                    controller: scollController,
                    slivers: [
                      if (listingState.isFetching && listingState.children == null || listingState.children!.isEmpty)
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
                          pinned: true,
                          snap: false,
                          // floating: true,
                          expandedHeight: 160.0,
                          actions: [
                            Row(
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Icon(Icons.search),
                                  ),
                                  onTap: () {},
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Icon(Icons.sort),
                                  ),
                                  onTap: () {},
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Icon(Icons.more_vert),
                                  ),
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                          flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                            return FlexibleSpaceBar(
                              titlePadding:
                                  EdgeInsets.only(left: constraints.maxHeight > 150 ? 10 : AppBar().leadingWidth ?? 40),
                              title: SafeArea(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      constraints.maxHeight > 150 ? MainAxisAlignment.end : MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'r/${listingState.subreddit}',
                                          style: TextStyle(
                                            color: Theme.of(context).textTheme.bodyText1?.color,
                                          ),
                                        ),
                                        if (constraints.maxHeight < 150)
                                          InkWell(
                                            borderRadius: BorderRadius.circular(10),
                                            onTap: () {},
                                            child: const Icon(Icons.arrow_drop_down),
                                          )
                                      ],
                                    ),
                                    if (constraints.maxHeight > 150)
                                      Row(
                                        children: [
                                          InkWell(
                                            borderRadius: BorderRadius.circular(10),
                                            onTap: () {},
                                            child: Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.sort, size: 12),
                                                  Text('Hot',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color: Theme.of(context).textTheme.bodyText1?.color)),
                                                  const Icon(Icons.arrow_drop_down, size: 12)
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                  ],
                                ),
                              ),
                            );
                          }),
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
                                  context.read<ListingCubit>().fetchMore();
                                  return const SizedBox();
                                }
                              }
                              final item = listingState.children?[index];
                              return LinkCardWidget(item: item);
                            },
                            childCount: listingState.children!.length + 1,
                          ),
                        )
                      ]
                    ],
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
