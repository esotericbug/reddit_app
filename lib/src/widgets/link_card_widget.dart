import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:reddit_app/src/helpers/general.dart';
import 'package:reddit_app/src/models/listing_response_model.dart';
import 'package:reddit_app/src/screens/link_detail_screen.dart';
import 'package:reddit_app/src/screens/listing_screen.dart';

class LinkCardWidget extends StatelessWidget {
  final String? subreddit;
  final LinkResponse? item;
  const LinkCardWidget({this.item, this.subreddit, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          // context.pushTransparentRoute(const LinkDetailScreen());
          Navigator.maybeOf(context)?.pushNamed(LinkDetailScreen.routeName);
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
              MarkdownBody(
                styleSheet: markdownDefaultTheme(context).copyWith(
                  p: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 17, height: 1.3),
                ),
                data: parseHTMLToString(item?.data?.title),
              ),
              MarkdownBody(
                data: parseHTMLToString(item?.data?.selftext).length > 250
                    ? '${parseHTMLToString(item?.data?.selftext).substring(0, 250)}...'
                    : parseHTMLToString(item?.data?.selftext),
                styleSheet: markdownDefaultTheme(context).copyWith(
                  p: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 13, height: 1.3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Builder(builder: (context) {
                    if (item?.data?.preview?.images?.first.source?.url != null) {
                      return LayoutBuilder(builder: (context, contraints) {
                        return AspectRatio(
                          aspectRatio: item!.data!.preview!.images!.first.source!.width!.toDouble() /
                              item!.data!.preview!.images!.first.source!.height!.toDouble(),
                          child: Image.network(
                            '${item?.data?.preview?.images?.first.source?.url}',
                            fit: BoxFit.contain,
                            cacheHeight: contraints.maxWidth.toInt(),
                          ),
                        );
                      });
                    } else if (item?.data?.mediaMetadata != null) {
                      final mediaDatum = item?.data?.mediaMetadata?.values.toList().first;
                      final aspectRatio = mediaDatum!.s!.x! / mediaDatum.s!.y!;
                      return LayoutBuilder(builder: (context, contraints) {
                        return AspectRatio(
                          aspectRatio: aspectRatio,
                          child: Image.network(
                            '${mediaDatum.s?.u}',
                            fit: BoxFit.contain,
                            cacheHeight: contraints.maxWidth.toInt(),
                          ),
                        );
                      });
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                ),
              ),
              Row(
                children: [
                  Container(
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
                            padding: EdgeInsets.all(4),
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
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.expand_more),
                          ),
                        ),
                      ],
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
                      onTap: () {
                        Navigator.maybeOf(context)?.pushNamed(LinkDetailScreen.routeName);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6),
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
