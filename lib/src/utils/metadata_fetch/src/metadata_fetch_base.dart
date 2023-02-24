import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;
import 'package:reddit_app/src/helpers/validators.dart';
import '../metadata_fetch.dart';
import '../src/parsers/parsers.dart';
import '../src/utils/util.dart';

class MetadataFetch {
  /// Fetches a [url], validates it, and returns [Metadata].
  static Future<Metadata?> extract(String? url) async {
    if (!isURL(url ?? '')) {
      return null;
    }

    /// Sane defaults; Always return the Domain name as the [title], and a [description] for a given [url]
    final defaultOutput = Metadata();
    defaultOutput.title = getDomain(url ?? '');
    defaultOutput.description = url;

    try {
      // Make our network call
      final response = await Dio(
        BaseOptions(
          validateStatus: (_) => true,
          responseType: ResponseType.plain,
          headers: {'Cache-Control': 'no-store'},
        ),
      ).get(url ?? '');
      final headerContentTypes = response.headers['content-type'];

      if (headerContentTypes != null && headerContentTypes[0].startsWith(r'image/')) {
        defaultOutput.title = '';
        defaultOutput.description = '';
        defaultOutput.image = url;
        return defaultOutput;
      }

      final document = responseToDocument(response);

      if (document == null) {
        return defaultOutput;
      }

      final data = _extractMetadata(document);
      if (data == null) {
        return defaultOutput;
      }

      return data;
    } on DioError catch (_) {
      return defaultOutput;
    }
  }

  /// Takes an [http.Response] and returns a [html.Document]
  static Document? responseToDocument(Response response) {
    if (response.statusCode != 200) {
      return null;
    }

    Document? document;
    try {
      document = parser.parse(response.data);
    } catch (err) {
      return document;
    }

    return document;
  }

  /// Returns instance of [Metadata] with data extracted from the [html.Document]
  /// Provide a given url as a fallback when there are no Document url extracted
  /// by the parsers.
  ///
  /// Future: Can pass in a strategy i.e: to retrieve only OpenGraph, or OpenGraph and Json+LD only
  static Metadata? _extractMetadata(Document document, {String? url}) {
    return MetadataParser.parse(document, url: url);
  }
}
