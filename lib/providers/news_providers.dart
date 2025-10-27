import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/news_item.dart';
import '../services/news_service.dart';
import '../repositories/news_repository.dart';

// A provider for the service itself (good for testing/overrides)
final newsServiceProvider = Provider<NewsService>((ref) {
  return NewsService();
});

// Repository provider that composes the service and can add caching/logic later
final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  final service = ref.watch(newsServiceProvider);
  return NewsRepository(service);
});

// FutureProvider that fetches the news list
final newsListProvider = FutureProvider<List<NewsItem>>((ref) async {
  final repo = ref.watch(newsRepositoryProvider);
  return repo.getNews();
});
