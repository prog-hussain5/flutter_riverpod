class NewsItem {
  final String id;
  final String title;
  final String picName;
  final String date;
  final String viewNum;

  const NewsItem({
    required this.id,
    required this.title,
    required this.picName,
    required this.date,
    required this.viewNum,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id']?.toString() ?? '',
      title: (json['title'] ?? '').toString(),
      picName: (json['pic_name'] ?? '').toString(),
      date: (json['date'] ?? '').toString(),
      viewNum: json['view_num']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'pic_name': picName,
    'date': date,
    'view_num': viewNum,
  };
}
