import '../models/news_item.dart';
import '../services/news_service.dart';

class NewsRepository {
  final NewsService _service;

  const NewsRepository(this._service);

  Future<List<NewsItem>> getNews({int itemsCount = 10}) async {
    return _service.fetchNews(itemsCount: itemsCount);
  }
}
