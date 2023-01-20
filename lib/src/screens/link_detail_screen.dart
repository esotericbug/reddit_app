import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:reddit_app/src/cubits/link_detail_data/link_detail_data_cubit.dart';
import 'package:reddit_app/src/helpers/general.dart';
import 'package:reddit_app/src/models/listing_response_model.dart';
import 'package:reddit_app/src/widgets/link_card_widget.dart';

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
                        return Container(
                          color: Colors.transparent,
                          child: MarkdownBody(
                            data: parseHTMLToString(comment?.data?.body),
                            styleSheet: markdownDefaultTheme(context),
                          ),
                        );
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
