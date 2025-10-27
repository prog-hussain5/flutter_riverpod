import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/news_providers.dart';

class NewsListScreen extends ConsumerWidget {
  const NewsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncNews = ref.watch(newsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأخبار'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Invalidate and then wait for the new future to complete
          ref.invalidate(newsListProvider);
          await ref.read(newsListProvider.future);
        },
        child: asyncNews.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, st) => ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('حدث خطأ: \n$err', textAlign: TextAlign.center),
              ),
              Center(
                child: FilledButton.icon(
                  onPressed: () => ref.invalidate(newsListProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة المحاولة'),
                ),
              ),
            ],
          ),
          data: (items) {
            if (items.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 80),
                  Center(child: Text('لا توجد بيانات متاحة.')),
                ],
              );
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 5),
              itemBuilder: (context, index) {
                final item = items[index];
                final imageUrl =
                    'http://imamali.net/rpic.php?i=files/${item.picName}&wh=700&noenlarge=1';
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      // Placeholders and error handling
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          width: 72,
                          height: 72,
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? (loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1))
                                    : null,
                              ),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 72,
                        height: 72,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                  title: Text(
                    item.title.trim(),
                    textDirection: TextDirection.rtl,
                  ),
                  subtitle: Text(
                    item.date,
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.remove_red_eye, size: 16),
                      const SizedBox(width: 4),
                      Text(item.viewNum),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
