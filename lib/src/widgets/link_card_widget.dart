import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:reddit_app/src/helpers/general.dart';
import 'package:reddit_app/src/models/listing_response_model.dart';

class LinkCardWidget extends StatelessWidget {
  final LinkResponse? item;
  const LinkCardWidget({this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              const CircleAvatar(
                radius: 15,
                child: Text('r'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: 'r/'),
                          TextSpan(
                            text: '${item?.data?.subreddit}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${item?.data?.author}',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          MarkdownBody(
            styleSheet: markdownDefaultTheme(context).copyWith(
              p: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 18),
            ),
            data: '${item?.data?.title}',
          ),
          MarkdownBody(
            data: '${item?.data?.selftext}'.replaceAll(RegExp(r'&#x200B;'), '').length > 250
                ? '${'${item?.data?.selftext}'.replaceAll(RegExp(r'&#x200B;'), '').substring(0, 250)}....'
                : '${item?.data?.selftext}'.replaceAll(RegExp(r'&#x200B;'), ''),
            styleSheet: markdownDefaultTheme(context),
          ),
          if (item?.data?.preview?.images?.first.source?.url != null)
            LayoutBuilder(builder: (context, contraints) {
              return AspectRatio(
                aspectRatio: item!.data!.preview!.images!.first.source!.width!.toDouble() /
                    item!.data!.preview!.images!.first.source!.height!.toDouble(),
                child: Image.network(
                  '${item?.data?.preview?.images?.first.source?.url}',
                  fit: BoxFit.contain,
                  cacheHeight: contraints.maxWidth.toInt(),
                ),
              );
            }),
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
                      child: const Icon(Icons.expand_less),
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
                      child: const Icon(Icons.expand_more),
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
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.forum_outlined,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
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
    );
  }
}
