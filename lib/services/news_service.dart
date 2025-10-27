import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_item.dart';

class NewsService {
  static const String _baseUrl =
      'https://imamali.net/imamAliNetworkApp/get_news_items.php';

  Future<List<NewsItem>> fetchNews({int itemsCount = 10}) async {
    final uri = Uri.parse('$_baseUrl?itemsCount=$itemsCount');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}: failed to load news');
    }

    final body = response.body;
    final decoded = jsonDecode(body);
    if (decoded is! List) {
      throw Exception('Unexpected response format');
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map((e) => NewsItem.fromJson(e))
        .toList(growable: false);
  }
}
