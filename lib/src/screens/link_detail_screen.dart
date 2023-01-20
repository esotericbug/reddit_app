import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:reddit_app/src/models/listing_response_model.dart';
import 'package:reddit_app/src/widgets/link_card_widget.dart';

class LinkDetailScreen extends StatelessWidget {
  static const routeName = 'link_detail_screen';

  final LinkResponse? item;
  const LinkDetailScreen({this.item, super.key});

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
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: Text('${item?.data?.subreddit}'),
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
                item: item,
                subreddit: item?.data?.subreddit,
                bodyExpanded: true,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    color: Colors.black12,
                    height: 100.0,
                    child: Center(
                      child: Text('$index', textScaleFactor: 5),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
