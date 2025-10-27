# تعلم Riverpod خطوة بخطوة (مع مثال حقيقي)

هذا المشروع يشرح Riverpod عمليًا باستخدام API الأخبار:

https://imamali.net/imamAliNetworkApp/get_news_items.php?itemsCount=10

ما قمنا به:

1) إعداد Riverpod
- أضفنا الحزمة flutter_riverpod إلى pubspec.yaml.
- لففنا التطبيق بـ ProviderScope في main.dart.

2) نموذج البيانات NewsItem
- ملف: lib/models/news_item.dart
- يحول JSON القادم من الـ API إلى كائنات Dart.

3) خدمة الجلب NewsService
- ملف: lib/services/news_service.dart
- تستخدم http.get لطلب البيانات وتحويلها إلى List<NewsItem>.

4) المزودات Providers
- ملف: lib/providers/news_providers.dart
- newsServiceProvider: لإنشاء الخدمة وقابلية الاستبدال في الاختبارات.
- newsRepositoryProvider: يغلّف الخدمة لإضافة منطق لاحقًا (كاش/دمج مصادر).
- newsListProvider: FutureProvider<List<NewsItem>> لجلب البيانات (مع عدد افتراضي من الريبو/الخدمة).

5) الواجهة UI
- ملف: lib/screens/news_list_screen.dart
- ConsumerWidget يراقب المزود newsListProvider ويعرض ثلاث حالات: تحميل/خطأ/بيانات.
- يدعم السحب للتحديث (RefreshIndicator).

مفاهيم Riverpod المستخدمة بإيجاز:
- ProviderScope: الجذر الذي يفعّل Riverpod.
- ref.watch: لمراقبة قيمة مزود وتحديث الواجهة عند تغيّره.
- ref.read: لقراءة القيمة مرة واحدة (دون إعادة بناء تلقائي).
- ref.invalidate: لإعادة تنفيذ provider (تحديث البيانات).
- StateProvider: حالة بسيطة قابلة للتغيير (int، String، إلخ).
- FutureProvider: لجلب البيانات غير المتزامنة مع إدارة حالة التحميل/الخطأ.

كيف تُشغِّل التطبيق:

1) تثبيت الاعتمادات
```
flutter pub get
```

2) التشغيل على المحاكي/الجهاز
```
flutter run
```

أماكن الملفات المهمة:
- main.dart: يلف التطبيق بـ ProviderScope ويحدد الصفحة الرئيسية.
- lib/models/news_item.dart: نموذج البيانات.
- lib/services/news_service.dart: مناداة الـ API.
- lib/providers/news_providers.dart: تعريف المزودات.
- lib/screens/news_list_screen.dart: واجهة عرض الأخبار.

ملاحظات:
- الحقل pic_name في الـ API يحوي مسار الصورة فقط. يمكنك لاحقًا تكوين عنوان كامل للصورة إذا توفرت قاعدة المسار الصحيحة من المصدر.
- يمكن إضافة مزود إضافي للتفاصيل/التصفية/البحث بسهولة عبر Riverpod.

## هيكلة مشروع قابلة للتوسع مع Riverpod (عند وجود عدة APIs)

عند توسّع المشروع وتعدد المصادر (APIs)، يُفضّل تنظيمه بأسلوب “features + core” بدل وضع كل شيء مباشرة تحت `lib/`.

بنية مقترحة:

```
lib/
	app/
		app.dart                 # تعريف MaterialApp والثيم والتنقل
		providers.dart           # مزودات عامة للتطبيق (اختياري)

	core/
		network/
			http_client.dart      # تغليف http (timeouts, headers، retry)
		errors/
			failures.dart         # نماذج أخطاء/نتائج مجال العمل
		utils/
			logger.dart           # تسجيل/تتبع موحّد (اختياري)

	features/
		news/
			data/
				models/news_item.dart
				sources/news_api.dart        # استدعاءات الشبكة الخام (خدمة)
				repositories/news_repository.dart  # واجهة + تنفيذ يجمع بين عدة مصادر
			presentation/
				providers/news_providers.dart
				screens/news_list_screen.dart
```

لماذا هذا التقسيم؟
- sources (الخدمات) مسؤولة عن استدعاء HTTP فقط.
- repositories (المستودعات) تُجمّع وتنسّق البيانات من عدة مصادر وتقدّمها لطبقة العرض (providers/واجهات).
- presentation تحتوي مزودات Riverpod وواجهات المستخدم.
- core يحتوي أشياء مشتركة على مستوى التطبيق (شبكة، أخطاء، أدوات).

### اختيار نوع المزود المناسب
- قراءة حالة بسيطة (عدد، مفتاح تصفية): StateProvider<T>.
- جلب بيانات مرة واحدة أو عند تغيّر المعلمات: FutureProvider<T>.
- تدفق حي (WebSocket/Stream): StreamProvider<T>.
- منطق تفاعلي وتراكم حالة (تحميل/إضافة/حذف/تحرير/صفحات):
	- Notifier<T> للحالات المتزامنة البسيطة.
	- AsyncNotifier<T> للحالات غير المتزامنة مع إدارة AsyncValue تلقائيًا.

متى أستخدم Repository؟
- عندما تتعامل مع أكثر من مصدر (APIs متعددة، كاش محلي، قاعدة بيانات)، أو عندما تريد عزل منطق التجميع بعيدًا عن الواجهة.
- أنشئ `repositoryProvider` يعتمد على `apiProvider`، ثم تعتمد عليه مزودات الشاشة.

### تعدد الـ APIs
- لكل ميزة Feature لديك: API خاص بها (news_api.dart مثلًا)، وRepository يجمع المنطق.
- قم بإنشاء مزودات مستقلة لكل ميزة، وتجنّب “مزود ضخم” لكل شيء.
- اجعل القيم القابلة للتغيير (مثل filters, page, query) في StateProvider، واشترك عليها من Future/AsyncNotifier لإعادة الجلب عند تغيّرها.

### التعامل مع الأخطاء
- حوّل Exceptions إلى حالات مفهومة (Failure) داخل Repository.
- في الواجهة استخدم AsyncValue.when(…) لعرض رسالة ودية للمستخدم.
- أضف retry بسيط: زر “إعادة المحاولة” يستدعي ref.invalidate(provider) أو action على Notifier.

### التخزين المؤقت وإعادة الجلب
- استخدم autoDispose للمزودات المؤقتة أو keepAlive عند الحاجة للبقاء.
- استخدم ref.invalidate لإجبار إعادة الجلب بعد تنفيذ إجراء تغييري.
- يمكنك تحديد إستراتيجية cacheTime وdisposeDelay عند الحاجة.

### ترقيم الصفحات والفلترة
- اجعل الحالة عبارة عن كائن State (مثلاً Page, Items, IsLoading, Error) عبر Notifier/AsyncNotifier.
- عرّف Events (loadNextPage, refresh, applyFilter) كدوال داخل Notifier.

### الاختبارات
- استخدم ProviderContainer مع overrides لحقن بدائل (mocks/fakes) لـ NewsService/Repository.
- اختبر Notifiers كوحدات منطقية: استدعِ الدوال وتحقق من تغير الحالة.

### تحسينات اختيارية
- riverpod_annotation + build_runner لتوليد المزودات (تسهّل إدارة المعلمات وautoDispose).
- freezed لبناء نماذج وحالات غير قابلة للتغيير مع نسخ آمن.
- dio بدل http عند الحاجة لمزايا متقدمة (Interceptors, Retry, Cancelation).

> ملاحظة: لم ننقل ملفات المشروع إلى هذا التقسيم الآن لتبسيط التعلم. إذا رغبت، يمكنني إعادة هيكلة المشروع تلقائيًا لهذا الشكل وتحديث الواردات خطوة بخطوة.
