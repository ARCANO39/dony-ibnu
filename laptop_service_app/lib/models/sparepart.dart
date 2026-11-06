class Sparepart {
  final String id;
  final String sku;
  final String name;
  final String category;
  final String compatibility;
  final double buyPrice;
  final double sellPrice;
  int stock;
  final int minStock;
  final String rackLocation;

  Sparepart({
    required this.id,
    required this.sku,
    required this.name,
    required this.category,
    required this.compatibility,
    required this.buyPrice,
    required this.sellPrice,
    required this.stock,
    this.minStock = 3,
    required this.rackLocation,
  });

  bool get isLowStock => stock <= minStock;

  factory Sparepart.fromJson(Map<String, dynamic> json) {
    return Sparepart(
      id: json['id']?.toString() ?? '',
      sku: json['sku'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      compatibility: json['compatibility'] ?? '',
      buyPrice: (json['buy_price'] as num?)?.toDouble() ?? 0.0,
      sellPrice: (json['sell_price'] as num?)?.toDouble() ?? 0.0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      minStock: (json['min_stock'] as num?)?.toInt() ?? 3,
      rackLocation: json['rack_location'] ?? '-',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'name': name,
      'category': category,
      'compatibility': compatibility,
      'buy_price': buyPrice,
      'sell_price': sellPrice,
      'stock': stock,
      'min_stock': minStock,
      'rack_location': rackLocation,
    };
  }
}

