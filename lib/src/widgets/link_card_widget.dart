import 'dart:math';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reddit_app/src/helpers/enums.dart';
import 'package:reddit_app/src/helpers/general.dart';
import 'package:reddit_app/src/models/listing_response_model.dart';
import 'package:reddit_app/src/screens/link_detail_screen.dart';
import 'package:reddit_app/src/screens/listing_screen.dart';
import 'package:reddit_app/src/utils/metadata_fetch/metadata_fetch.dart';
import 'package:reddit_app/src/widgets/gallery_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LinkCardWidget extends StatelessWidget {
  final String? subreddit;
  final LinkResponse? item;
  final bool bodyExpanded;
  const LinkCardWidget({
    this.bodyExpanded = false,
    this.item,
    this.subreddit,
    super.key,
  });

  String? get _createdAt {
    final dateCreatedSeconds = item?.data?.created?.toInt();
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
    if (item?.data?.edited != null &&
        (item?.data?.edited is double || item?.data?.edited is num || item?.data?.edited is int)) {
      final dateEditedSeconds = (item?.data?.edited as num).toInt();
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
  Widget build(BuildContext context) {
    Future<void> openURL(dynamic url) async {
      EasyLoading.show();
      final browser = ChromeSafariBrowser();
      if (await canLaunchUrlString(url)) {
        await browser.open(url: Uri.parse('$url'));
        EasyLoading.dismiss();
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not able to lauch URL.')));
        }
      }
    }

    return Material(
      child: GestureDetector(
        onTap: () {
          if (!bodyExpanded) {
            Navigator.maybeOf(context)?.pushNamed(LinkDetailScreen.routeName, arguments: {
              'item': item,
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: .5, color: Colors.grey.shade800),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (subreddit?.toLowerCase() != item?.data?.subreddit?.toLowerCase())
                    const CircleAvatar(
                      radius: 15,
                      child: Text('r'),
                    ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: subreddit?.toLowerCase() != item?.data?.subreddit?.toLowerCase() ? 7 : 0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (subreddit?.toLowerCase() != item?.data?.subreddit?.toLowerCase())
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(ListingScreen.routeName, arguments: {
                                  'subreddit': item?.data?.subreddit,
                                });
                              },
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'r/',
                                      style: TextStyle(
                                        height: 1,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${item?.data?.subreddit}',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColorLight,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        height: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'u/'.useCorrectEllipsis(),
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 11,
                                    height: 1,
                                  ),
                                ),
                                TextSpan(
                                  text: '${item?.data?.author}'.useCorrectEllipsis(),
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 11,
                                    height: 1,
                                  ),
                                ),
                                if (_createdAt != null) ...[
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Icon(
                                      MdiIcons.circleSmall,
                                      size: 10,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '$_createdAt'.useCorrectEllipsis(),
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 11,
                                      height: 1,
                                    ),
                                  ),
                                ],
                                if (_editedAt != null) ...[
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Icon(
                                      MdiIcons.circleSmall,
                                      size: 10,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '(last edited $_editedAt)'.useCorrectEllipsis(),
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 11,
                                      height: 1,
                                    ),
                                  ),
                                ],
                                if (item?.data?.over18 == true) ...[
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Icon(
                                      MdiIcons.circleSmall,
                                      size: 10,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'NSFW'.useCorrectEllipsis(),
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 11,
                                      height: 1,
                                    ),
                                  ),
                                ],
                                if (item?.data?.domain != null) ...[
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Icon(
                                      MdiIcons.circleSmall,
                                      size: 10,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: (item?.data?.domain ?? '').useCorrectEllipsis(),
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 11,
                                      height: 1,
                                    ),
                                  ),
                                ],
                                if (bodyExpanded) ...[
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Icon(
                                      MdiIcons.circleSmall,
                                      size: 10,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${((item?.data?.upvoteRatio ?? 0) * 100).toInt()}% upvoted'
                                        .useCorrectEllipsis(),
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 11,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              MarkdownBody(
                styleSheet: markdownDefaultTheme(context).copyWith(
                  p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.15,
                      ),
                ),
                data: parseHTMLToString(item?.data?.title),
              ),
              const SizedBox(
                height: 5,
              ),
              MarkdownBody(
                data: !bodyExpanded && parseHTMLToString(item?.data?.selftext).length > 250
                    ? '${parseHTMLToString(item?.data?.selftext).substring(0, 250)}...'
                    : parseHTMLToString(item?.data?.selftext),
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
              LinkWidget(item),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade800,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.all(1),
                              child: Icon(Icons.expand_less),
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            NumberFormat.compactCurrency(
                              decimalDigits: 0,
                              locale: 'en_US',
                              symbol: '',
                            ).format(item?.data?.score ?? 0),
                            style: const TextStyle(fontSize: 11),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.all(1),
                              child: Icon(Icons.expand_more),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade800,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(7),
                      onTap: () {
                        if (!bodyExpanded) {
                          Navigator.maybeOf(context)?.pushNamed(LinkDetailScreen.routeName, arguments: {
                            'item': item,
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.forum_outlined,
                              size: 18,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 7),
                              child: Text(
                                NumberFormat.compactCurrency(
                                  decimalDigits: 0,
                                  locale: 'en_US',
                                  symbol: '',
                                ).format(item?.data?.numComments ?? 0),
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LinkWidget extends StatefulWidget {
  final LinkResponse? item;
  const LinkWidget(this.item, {super.key});

  @override
  State<LinkWidget> createState() => _LinkWidgetState();
}

class _LinkWidgetState extends State<LinkWidget> {
  final random = Random();
  bool get isPostLink => widget.item?.data?.postHint == 'link';
  Metadata? get linkMeta => widget.item?.data?.linkMeta;
  List<RedditMedia> get redditMediaList => widget.item?.data?.getImagesAndVideos ?? [];
  OverlayEntry? popupDialog;

  void createPopupDialog(Widget child) {
    popupDialog = OverlayEntry(builder: (context) => child);
    if (popupDialog == null) return;
    Overlay.of(context).insert(popupDialog!);
  }

  Future<void> openURL(dynamic url) async {
    EasyLoading.show();
    final browser = ChromeSafariBrowser();
    if (await canLaunchUrlString(url)) {
      await browser.open(url: Uri.parse('$url'));
      EasyLoading.dismiss();
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not able to lauch URL.')));
      }
    }
  }

  Future<void> linkHandler() async {
    Dev.log(isPostLink || linkMeta != null);
    if (isPostLink || linkMeta != null) {
      await openURL(widget.item?.data?.urlOverriddenByDest);
    } else {
      if (redditMediaList.isNotEmpty) {
        await context.pushTransparentRoute(
          Hero(
            transitionOnUserGestures: true,
            tag: random,
            child: GalleryWidget(redditMediaList: redditMediaList),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item?.data?.getPreviewImage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: GestureDetector(
            onLongPressStart: (_) {
              if (isPostLink) return;
              createPopupDialog(
                Hero(
                  transitionOnUserGestures: true,
                  tag: random,
                  child: GalleryWidget(redditMediaList: redditMediaList),
                ),
              );
            },
            onLongPressEnd: (_) {
              popupDialog?.remove();
            },
            onTap: () async {
              await linkHandler();
            },
            child: Stack(
              fit: StackFit.loose,
              alignment: isPostLink ? Alignment.bottomCenter : Alignment.bottomRight,
              children: [
                Hero(
                  tag: random,
                  transitionOnUserGestures: true,
                  child: ImageWithLoader(
                    widget.item?.data?.getPreviewImage?.url,
                    width: widget.item?.data?.getPreviewImage?.width,
                    height: widget.item?.data?.getPreviewImage?.height,
                  ),
                ),
                if (widget.item?.data?.getPreviewImage?.url != null &&
                    (widget.item?.data?.getPreviewImage?.url?.isNotEmpty ?? true))
                  Container(
                    margin: EdgeInsets.all(!isPostLink ? 7 : 0),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black87.withOpacity(0.8),
                      shape: BoxShape.rectangle,
                      borderRadius: !isPostLink ? BorderRadius.circular(5) : null,
                      border: !isPostLink
                          ? Border.all(
                              color: Colors.white,
                              width: 0.5,
                            )
                          : null,
                    ),
                    child: isPostLink
                        ? Center(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.item?.data?.urlOverriddenByDest ?? '',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          )
                        : Icon(
                            redditMediaList.isNotEmpty
                                ? (redditMediaList.first.type == MediaType.gif
                                    ? Icons.gif
                                    : redditMediaList.first.type == MediaType.video
                                        ? Icons.videocam_rounded
                                        : redditMediaList.first.type == MediaType.embed
                                            ? Icons.link
                                            : Icons.image)
                                : null,
                            size: 20,
                            color: Colors.white,
                          ),
                  )
              ],
            ),
          ),
        ),
      );
    } else if (linkMeta?.url != null &&
        linkMeta?.title != null &&
        linkMeta?.description != null &&
        linkMeta?.image != null) {
      return GestureDetector(
        onTap: () async {
          await linkHandler();
        },
        child: Stack(
          fit: StackFit.loose,
          alignment: Alignment.bottomCenter,
          children: [
            Hero(
              tag: random,
              transitionOnUserGestures: true,
              child: ImageWithLoader(
                linkMeta?.image,
              ),
            ),
            if (linkMeta?.url != null && (linkMeta?.url?.isNotEmpty ?? true))
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black87.withOpacity(0.8),
                  shape: BoxShape.rectangle,
                ),
                child: Center(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      linkMeta?.url ?? '',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              )
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
