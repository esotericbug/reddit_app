import 'dart:math';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reddit_app/src/cubits/link_detail_data/link_detail_data_cubit.dart';
import 'package:reddit_app/src/helpers/general.dart';
import 'package:reddit_app/src/models/link_data_model.dart';
import 'package:reddit_app/src/models/listing_response_model.dart';
import 'package:reddit_app/src/widgets/link_card_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LinkDetailScreen extends StatefulWidget {
  static const routeName = 'link_detail_screen';

  final LinkResponse? item;
  const LinkDetailScreen({this.item, super.key});

  @override
  State<LinkDetailScreen> createState() => _LinkDetailScreenState();
}

class _LinkDetailScreenState extends State<LinkDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await BlocProvider.of<LinkDetailDataCubit>(context).fetchLinkData(
        article: widget.item?.data?.name?.split(RegExp(r'_'))[1],
        subreddit: widget.item?.data?.subreddit,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () {
        Navigator.of(context).pop();
      },
      minScale: 1,
      startingOpacity: 0.3,
      maxTransformValue: 0.9,
      direction: DismissiblePageDismissDirection.startToEnd,
      child: BlocBuilder<LinkDetailDataCubit, LinkDetailDataState>(
        builder: (context, state) {
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  title: Text('${widget.item?.data?.subreddit}'),
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
                SliverToBoxAdapter(
                  child: LinkCardWidget(
                    item: widget.item,
                    subreddit: widget.item?.data?.subreddit,
                    bodyExpanded: true,
                  ),
                ),
                if (state.isFetching)
                  const SliverToBoxAdapter(
                    child: Center(child: RefreshProgressIndicator()),
                  )
                else if (state.error != null)
                  SliverToBoxAdapter(
                    child: Text('${state.error?.message}\nCode: ${state.error?.error}'),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final comment = state.linkDetailData?.commentData?.data?.children?[index];
                        if (comment?.kind != "more") {
                          return CommentWidget(comment, topLevel: true);
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                      childCount: state.linkDetailData?.commentData?.data?.children?.length,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CommentWidget extends StatefulWidget {
  final bool topLevel;
  final CommentData? comment;
  final bool expand;
  const CommentWidget(this.comment, {this.topLevel = false, this.expand = true, super.key});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> with SingleTickerProviderStateMixin<CommentWidget> {
  late AnimationController expandController;
  late Animation<double> animation;

  String? get _createdAt {
    final dateCreatedSeconds = widget.comment?.data?.created?.toInt();
    if (dateCreatedSeconds == null) return '';
    final dateCreated = DateTime.fromMillisecondsSinceEpoch(dateCreatedSeconds * 1000);
    final currentDate = DateTime.now();
    final durationDiff = currentDate.difference(dateCreated);

    if (durationDiff.inDays ~/ 365 > 0) {
      return '${durationDiff.inDays ~/ 365}y';
    } else if (durationDiff.inDays ~/ 30 > 0) {
      return '${durationDiff.inDays ~/ 30}m';
    } else if (durationDiff.inDays ~/ 7 > 0) {
      return '${durationDiff.inDays ~/ 7}w';
    } else if (durationDiff.inDays > 0) {
      return '${durationDiff.inDays}d';
    } else if (durationDiff.inHours > 0) {
      return '${durationDiff.inHours}h';
    } else if (durationDiff.inMinutes > 0) {
      return '${durationDiff.inMinutes}mins';
    } else if (durationDiff.inSeconds > 0) {
      return '${durationDiff.inSeconds}secs';
    }
    return null;
  }

  String? get _editedAt {
    if (widget.comment?.data?.edited != null &&
        (widget.comment?.data?.edited is double ||
            widget.comment?.data?.edited is num ||
            widget.comment?.data?.edited is int)) {
      final dateEditedSeconds = (widget.comment?.data?.edited as num).toInt();
      final dateEdited = DateTime.fromMillisecondsSinceEpoch(dateEditedSeconds * 1000);
      final currentDate = DateTime.now();
      final durationDiff = currentDate.difference(dateEdited);

      if (durationDiff.inDays ~/ 365 > 0) {
        return '${durationDiff.inDays ~/ 365}y';
      } else if (durationDiff.inDays ~/ 30 > 0) {
        return '${durationDiff.inDays ~/ 30}m';
      } else if (durationDiff.inDays ~/ 7 > 0) {
        return '${durationDiff.inDays ~/ 7}w';
      } else if (durationDiff.inDays > 0) {
        return '${durationDiff.inDays}d';
      } else if (durationDiff.inHours > 0) {
        return '${durationDiff.inHours}h';
      } else if (durationDiff.inMinutes > 0) {
        return '${durationDiff.inMinutes}mins';
      } else if (durationDiff.inSeconds > 0) {
        return '${durationDiff.inSeconds}secs';
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   await _runExpandCheck();
    // });
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100), value: 1);
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.easeInOut,
    );
  }

  Future<void> _runExpandCheck() async {
    if (widget.expand) {
      await expandController.forward();
    } else {
      await expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(CommentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  Future<void> _toggleContainer() async {
    if (animation.status != AnimationStatus.completed) {
      await expandController.forward();
    } else {
      await expandController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> openURL(dynamic url) async {
      await EasyLoading.show();
      final browser = ChromeSafariBrowser();
      if (await canLaunchUrlString(url)) {
        await browser.open(url: Uri.parse('$url'));
        await EasyLoading.dismiss();
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not able to lauch URL.')));
        }
      }
    }

    return GestureDetector(
      onTap: () async => await _toggleContainer(),
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  MdiIcons.reddit,
                  size: 20,
                  color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                ),
                Icon(
                  MdiIcons.circleSmall,
                  size: 10,
                  color: Colors.grey.shade500,
                ),
                Text(
                  'u/${widget.comment?.data?.author}',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    height: 1,
                  ),
                ),
                Icon(
                  MdiIcons.circleSmall,
                  size: 10,
                  color: Colors.grey.shade500,
                ),
                Text(
                  '$_createdAt',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    height: 1,
                  ),
                ),
                if (_editedAt != null) ...[
                  Icon(
                    MdiIcons.circleSmall,
                    size: 10,
                    color: Colors.grey.shade500,
                  ),
                  Text(
                    '(last edited $_editedAt)',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 11,
                      height: 1,
                    ),
                  ),
                ],
              ],
            ),
            MarkdownBody(
              data: parseHTMLToString(widget.comment?.data?.body),
              styleSheet: markdownDefaultTheme(context).copyWith(
                p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 12,
                      height: 1.15,
                    ),
              ),
              onTapLink: (text, href, title) async {
                await openURL(href);
              },
            ),
            if (widget.comment?.data?.replies?.data?.children?.isNotEmpty ?? false)
              Builder(builder: (context) {
                final children = widget.comment?.data?.replies?.data?.children?.where(
                  (commentChild) => commentChild.kind != "more",
                );
                if (children?.isNotEmpty ?? false) {
                  return SizeTransition(
                    sizeFactor: animation,
                    child: Container(
                      margin: const EdgeInsets.only(left: 2, top: 5),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            width: 2,
                            color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ...?children?.map(
                            (commentChild) => CommentWidget(commentChild),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              })
          ],
        ),
      ),
    );
  }
}
