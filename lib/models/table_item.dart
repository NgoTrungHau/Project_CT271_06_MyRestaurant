class TableItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;

  TableItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  TableItem copyWith({
    String? id,
    String? title,
    int? quantity,
    double? price,
  }) {
    return TableItem(
      id: id ?? this.id,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      imageUrl: imageUrl,
    );
  }
}