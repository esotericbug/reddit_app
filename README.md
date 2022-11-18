 // SliverAnimatedOpacity(
                          //   opacity: listingScreenState.lastScrollDirection == ScrollDirection.forward ||
                          //           scollController.position.minScrollExtent == scollController.position.pixels ||
                          //           scollController.position.pixels < 500
                          //       ? 1
                          //       : 0,
                          //   duration: const Duration(milliseconds: 300),
                          //   sliver: SliverAppBar.large(
                          //     pinned: context.read<ListingScreenCubit>().state.floatingButtonVisible,
                          //     // floating: true,
                          //     titleSpacing: 0,
                          //     expandedHeight: 200,
                          //     leading: ModalRoute.of(context) != null && !ModalRoute.of(context)!.isFirst
                          //         ? IconButton(
                          //             icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
                          //             onPressed: () {
                          //               Navigator.of(context).pop();
                          //             },
                          //           )
                          //         : Builder(builder: (context) {
                          //             return IconButton(
                          //               icon: const Icon(Icons.menu),
                          //               onPressed: () {
                          //                 OverlappingPanels.of(context)?.reveal(RevealSide.left);
                          //               },
                          //             );
                          //           }),
                          //     actions: [
                          //       Row(
                          //         children: [
                          //           InkWell(
                          //             borderRadius: BorderRadius.circular(20),
                          //             child: const Padding(
                          //               padding: EdgeInsets.all(10.0),
                          //               child: Icon(Icons.search),
                          //             ),
                          //             onTap: () {},
                          //           ),
                          //           InkWell(
                          //             borderRadius: BorderRadius.circular(20),
                          //             child: const Padding(
                          //               padding: EdgeInsets.all(10.0),
                          //               child: Icon(Icons.sort),
                          //             ),
                          //             onTap: () {},
                          //           ),
                          //           InkWell(
                          //             borderRadius: BorderRadius.circular(20),
                          //             child: const Padding(
                          //               padding: EdgeInsets.all(10.0),
                          //               child: Icon(Icons.more_vert),
                          //             ),
                          //             onTap: () {},
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //     flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                          //       final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
                          //       final deltaExtent = settings!.maxExtent - settings.minExtent;
                          //       final factor = (settings.minExtent / constraints.maxHeight) -
                          //           (settings.minExtent / settings.maxExtent);
                          //       final t =
                          //           (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent).clamp(0.0, 1.0);
                          //       final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
                          //       const fadeEnd = 1.0;
                          //       final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);
                          //       return FlexibleSpaceBar(
                          //         titlePadding: EdgeInsets.only(
                          //           left: factor * settings.currentExtent,
                          //           bottom: 3,
                          //         ),
                          //         title: SafeArea(
                          //           child: Column(
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             mainAxisAlignment: settings.currentExtent == settings.minExtent
                          //                 ? MainAxisAlignment.center
                          //                 : MainAxisAlignment.end,
                          //             children: [
                          // Row(
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.only(left: 10),
                          //       child: Text(
                          //         'r/${listingState.subreddit}',
                          //         style: TextStyle(
                          //             color: Theme.of(context).textTheme.bodyText1?.color, fontSize: 18),
                          //       ),
                          //     ),
                          //     Opacity(
                          //       opacity: (1 - opacity).abs(),
                          //       // duration: const Duration(milliseconds: 200),
                          //       child: InkWell(
                          //         borderRadius: BorderRadius.circular(10),
                          //         onTap: () {},
                          //         child: const Icon(Icons.arrow_drop_down),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          //               Opacity(
                          //                 opacity: opacity,
                          //                 child: SizedBox(
                          //                   height: opacity == 1 ? null : 0,
                          //                   child: Padding(
                          //                     padding: const EdgeInsets.only(left: 10),
                          //                     child: Row(
                          //                       children: [
                          //                         InkWell(
                          //                           borderRadius: BorderRadius.circular(10),
                          //                           onTap: () {},
                          //                           child: Padding(
                          //                             padding: const EdgeInsets.all(2.0),
                          //                             child: Row(
                          //                               children: [
                          //                                 const Icon(Icons.sort, size: 12),
                          //                                 Text(
                          //                                   'Hot',
                          //                                   style: TextStyle(
                          //                                       fontSize: 11,
                          //                                       color: Theme.of(context).textTheme.bodyText1?.color),
                          //                                 ),
                          //                                 const Icon(Icons.arrow_drop_down, size: 12)
                          //                               ],
                          //                             ),
                          //                           ),
                          //                         )
                          //                       ],
                          //                     ),
                          //                   ),
                          //                 ),
                          //               )
                          //             ],
                          //           ),
                          //         ),
                          //       );
                          //     }),
                          //   ),
                          // ),