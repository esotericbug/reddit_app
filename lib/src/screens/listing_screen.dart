import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/src/cubits/listing/listing_cubit.dart';
import 'package:reddit_app/src/widgets/link_card_widget.dart';

class ListingScreen extends StatefulWidget {
  static const routeName = 'listing_screen';
  const ListingScreen({super.key});

  @override
  State<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<ListingCubit>().fetchInitial();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListingCubit, ListingState>(
      builder: (context, listingState) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: context.read<ListingCubit>().fetchInitial,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  if (listingState.isFetching)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Center(
                          child: RefreshProgressIndicator(),
                        ),
                      ),
                    )
                  else
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
                    )
                ];
              },
              body: listingState.isFetching
                  ? const SizedBox()
                  : ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        final item = listingState.children?[index];
                        return LinkCardWidget(item: item);
                      },
                      itemCount: listingState.children?.length,
                    ),
            ),
          ),
        );
      },
    );
  }
}
