class TableB {
  final String? id;
  final String title;
  final int status;

  TableB(
    {
    this.id, 
    required this.title,
    required this.status,
  });

  TableB copyWith({
    String? id,
    String? title,
    int? status,
  }) {
    return TableB(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'status': status,
    };
  }

  static TableB fromJson(Map<String, dynamic> json) {
    return TableB(
      id: json['id'],
      title: json['title'],
      status: json['status'], 
    );
  }

}