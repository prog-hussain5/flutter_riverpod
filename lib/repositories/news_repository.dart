import '../models/news_item.dart';
import '../services/news_service.dart';

class NewsRepository {
  final NewsService service;

  const NewsRepository(this.service);

  Future<List<NewsItem>> getNews({int itemsCount = 5}) async {
    return service.fetchNews(itemsCount: itemsCount);
  }
}
