import 'dart:math';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reddit_app/src/helpers/enums.dart';
import 'package:reddit_app/src/helpers/general.dart';
import 'package:reddit_app/src/models/listing_response_model.dart';
import 'package:reddit_app/src/screens/link_detail_screen.dart';
import 'package:reddit_app/src/screens/listing_screen.dart';
import 'package:reddit_app/src/widgets/gallery_widget.dart';
import 'package:reddit_app/src/widgets/video_player_widget.dart';

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

  Future<void> _openURL(dynamic url) async {
    final browser = ChromeSafariBrowser();
    await browser.open(url: Uri.parse('$url'));
  }

  String? get _createdAt {
    final dateCreatedSeconds = item?.data?.created?.toInt();
    if (dateCreatedSeconds == null) return '';
    final dateCreated = DateTime.fromMillisecondsSinceEpoch(dateCreatedSeconds * 1000);
    final currentDate = DateTime.now();
    final durationDiff = currentDate.difference(dateCreated);

    if (durationDiff.inDays ~/ 365 > 0) {
      return '${durationDiff.inDays ~/ 365} years';
    } else if (durationDiff.inDays ~/ 30 > 0) {
      return '${durationDiff.inDays ~/ 30} months';
    } else if (durationDiff.inDays ~/ 7 > 0) {
      return '${durationDiff.inDays ~/ 7} weeks';
    } else if (durationDiff.inDays > 0) {
      return '${durationDiff.inDays} days';
    } else if (durationDiff.inHours > 0) {
      return '${durationDiff.inHours} hours';
    } else if (durationDiff.inMinutes > 0) {
      return '${durationDiff.inMinutes} minutes';
    } else if (durationDiff.inSeconds > 0) {
      return '${durationDiff.inSeconds} seconds';
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
        return '${durationDiff.inDays ~/ 365} years';
      } else if (durationDiff.inDays ~/ 30 > 0) {
        return '${durationDiff.inDays ~/ 30} months';
      } else if (durationDiff.inDays ~/ 7 > 0) {
        return '${durationDiff.inDays ~/ 7} weeks';
      } else if (durationDiff.inDays > 0) {
        return '${durationDiff.inDays} days';
      } else if (durationDiff.inHours > 0) {
        return '${durationDiff.inHours} hours';
      } else if (durationDiff.inMinutes > 0) {
        return '${durationDiff.inMinutes} minutes';
      } else if (durationDiff.inSeconds > 0) {
        return '${durationDiff.inSeconds} seconds';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
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
            children: [
              Row(
                children: [
                  if (subreddit?.toLowerCase() != item?.data?.subreddit?.toLowerCase())
                    const CircleAvatar(
                      radius: 15,
                      child: Text('r'),
                    ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: subreddit?.toLowerCase() != item?.data?.subreddit?.toLowerCase() ? 7 : 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                text: 'u/',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 11,
                                  height: 1,
                                ),
                              ),
                              TextSpan(
                                text: '${item?.data?.author}',
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
                                  text: '$_createdAt ago',
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
                                  text: '(last edited $_editedAt ago)',
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
                                const TextSpan(
                                  text: 'NSFW',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 11,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              MarkdownBody(
                styleSheet: markdownDefaultTheme(context).copyWith(
                  p: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
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
                  p: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontSize: 12,
                        height: 1.1,
                      ),
                ),
                onTapLink: (text, href, title) async {
                  await _openURL(href);
                  Dev.log(href);
                },
              ),
              Builder(builder: (context) {
                final redditMediaList = item?.data?.getImagesAndVideos;
                final random = Random();
                openGallery() {
                  final galleryItems = redditMediaList
                          ?.map(
                            (media) => media.type == MediaType.image
                                ? (media.url != null
                                    ? ImageWithLoader(
                                        media.url,
                                        width: media.width,
                                        height: media.height,
                                        withCacheHeight: false,
                                      )
                                    : null)
                                : (media.type == MediaType.video && media.url != null)
                                    ? VideoPlayerWidget(
                                        url: media.url.toString(),
                                      )
                                    : media.type == MediaType.embed
                                        ? InAppWebView(
                                            initialUrlRequest: URLRequest(url: Uri.parse('${media.url}')),
                                          )
                                        : null,
                          )
                          .whereType<Widget>()
                          .toList() ??
                      [];
                  if (galleryItems.isNotEmpty) {
                    context.pushTransparentRoute(
                      Hero(
                        transitionOnUserGestures: true,
                        tag: random,
                        child: GalleryWidget(
                          children: galleryItems,
                        ),
                      ),
                    );
                  }
                }

                if (item?.data?.getPreviewImage != null) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: GestureDetector(
                        onTap: openGallery,
                        child: Stack(
                          fit: StackFit.loose,
                          alignment: Alignment.bottomRight,
                          children: [
                            Hero(
                              tag: random,
                              transitionOnUserGestures: true,
                              child: ImageWithLoader(
                                item?.data?.getPreviewImage?.url,
                                width: item?.data?.getPreviewImage?.width,
                                height: item?.data?.getPreviewImage?.height,
                              ),
                            ),
                            if (item?.data?.getPreviewImage?.url != null &&
                                item!.data!.getPreviewImage!.url!.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.all(7),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black87.withOpacity(0.8),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 0.5,
                                  ),
                                ),
                                child: Icon(
                                  redditMediaList != null && redditMediaList.isNotEmpty
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
                }
                return const SizedBox.shrink();
              }),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      padding: const EdgeInsets.all(2),
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
                              padding: EdgeInsets.all(2),
                              child: Icon(Icons.expand_less),
                            ),
                          ),
                          Text(
                            NumberFormat.compactCurrency(
                              decimalDigits: 0,
                              locale: 'en_US',
                              symbol: '',
                            ).format(item?.data?.score ?? 0),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.all(2),
                              child: Icon(Icons.expand_more),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade800,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(7),
                      onTap: !bodyExpanded
                          ? () {
                              Navigator.maybeOf(context)?.pushNamed(LinkDetailScreen.routeName, arguments: {
                                'item': item,
                              });
                            }
                          : () {},
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.forum_outlined,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 7),
                              child: Text(
                                NumberFormat.compactCurrency(
                                  decimalDigits: 0,
                                  locale: 'en_US',
                                  symbol: '',
                                ).format(item?.data?.numComments ?? 0),
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

class EmojiText extends StatelessWidget {
  const EmojiText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: _buildText(text),
    );
  }

  TextSpan _buildText(String text) {
    final children = <TextSpan>[];
    final runes = text.runes;

    for (int i = 0; i < runes.length; /* empty */) {
      int current = runes.elementAt(i);

      // we assume that everything that is not
      // in Extended-ASCII set is an emoji...
      final isEmoji = current > 255;
      final shouldBreak = isEmoji ? (x) => x <= 255 : (x) => x > 255;

      final chunk = <int>[];
      while (!shouldBreak(current)) {
        chunk.add(current);
        if (++i >= runes.length) break;
        current = runes.elementAt(i);
      }

      children.add(
        TextSpan(
          text: String.fromCharCodes(chunk),
          style: TextStyle(
            fontFamily: isEmoji ? 'EmojiOne' : null,
          ),
        ),
      );
    }

    return TextSpan(children: children);
  }
}
