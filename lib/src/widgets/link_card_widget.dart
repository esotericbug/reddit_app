import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
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
  const LinkCardWidget({this.bodyExpanded = false, this.item, this.subreddit, super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> openURL(dynamic url) async {
      final browser = ChromeSafariBrowser();
      await browser.open(url: Uri.parse('$url'));
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
            children: [
              Row(
                children: [
                  if (subreddit?.toLowerCase() != item?.data?.subreddit?.toLowerCase())
                    const CircleAvatar(
                      radius: 15,
                      child: Text('r'),
                    ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: subreddit?.toLowerCase() != item?.data?.subreddit?.toLowerCase() ? 5 : 0),
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
                                  const TextSpan(text: 'r/'),
                                  TextSpan(
                                    text: '${item?.data?.subreddit}',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColorLight,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'u/',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: '${item?.data?.author}',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              if (!bodyExpanded)
                MarkdownBody(
                  styleSheet: markdownDefaultTheme(context).copyWith(
                    p: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                  ),
                  data: parseHTMLToString(item?.data?.title),
                ),
              MarkdownBody(
                data: !bodyExpanded && parseHTMLToString(item?.data?.selftext).length > 250
                    ? '${parseHTMLToString(item?.data?.selftext).substring(0, 250)}...'
                    : parseHTMLToString(item?.data?.selftext),
                styleSheet: markdownDefaultTheme(context).copyWith(
                  p: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontSize: 12,
                        height: 1.3,
                      ),
                ),
                onTapLink: (text, href, title) async {
                  await openURL(href);
                  Dev.log(href);
                },
              ),
              Builder(builder: (context) {
                final redditMediaList = item?.data?.getImagesAndVideos;
                openGallery() {
                  final galleryItems = redditMediaList
                          ?.map(
                            (media) => media.type == MediaType.image
                                ? ImageWithLoader(
                                    media.url,
                                    width: media.width,
                                    height: media.height,
                                    withCacheHeight: false,
                                  )
                                : media.url != null
                                    ? VideoPlayerWidget(
                                        url: media.url.toString(),
                                      )
                                    : null,
                          )
                          .whereType<Widget>()
                          .toList() ??
                      [];
                  if (galleryItems.isNotEmpty) {
                    context.pushTransparentRoute(
                      GalleryWidget(
                        children: [
                          ...galleryItems,
                        ],
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
                            ImageWithLoader(
                              item?.data?.getPreviewImage?.url,
                              width: item?.data?.getPreviewImage?.width,
                              height: item?.data?.getPreviewImage?.height,
                            ),
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
                                redditMediaList?.first.type == MediaType.gif
                                    ? Icons.gif
                                    : redditMediaList?.first.type == MediaType.video
                                        ? Icons.videocam_rounded
                                        : Icons.image,
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
                            ).format(item?.data?.score),
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
                                ).format(item?.data?.numComments),
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
