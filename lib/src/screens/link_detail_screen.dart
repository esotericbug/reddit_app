import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';

class LinkDetailScreen extends StatelessWidget {
  static const routeName = 'link_detail_screen';
  const LinkDetailScreen({super.key});

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
                childCount: 100000,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
