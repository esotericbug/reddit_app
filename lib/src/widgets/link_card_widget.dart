import 'package:flutter/material.dart';
import 'package:reddit_app/src/models/listing_response_model.dart';

class LinkCardWidget extends StatelessWidget {
  final LinkResponse? item;
  const LinkCardWidget({this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('${item?.data?.title}'),
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
        ],
      ),
    );
  }
}
