import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/sparepart.dart';
import '../services/app_state.dart';

class InventoryView extends StatefulWidget {
  const InventoryView({super.key});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  final _searchCtrl = TextEditingController();
  final String _selectedCategory = 'all';

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final allParts = state.spareparts;

    // Filter by query and category
    final query = _searchCtrl.text.toLowerCase();
    final filteredParts = allParts.where((p) {
      final matchQuery = p.name.toLowerCase().contains(query) ||
          p.sku.toLowerCase().contains(query) ||
          p.compatibility.toLowerCase().contains(query);
      final matchCat =
          _selectedCategory == 'all' || p.category.toLowerCase() == _selectedCategory.toLowerCase();
      return matchQuery && matchCat;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventaris Sparepart & Gudang'),
        actions: [
          IconButton(
            tooltip: 'Tambah Sparepart Baru',
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () => _showAddSparepartDialog(context, state),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Banner Gudang Sparepart
          Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/inventory.jpg',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.black.withValues(alpha: 0.85),
                          Colors.black.withValues(alpha: 0.2),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gudang Sparepart & Komponen',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Manajemen inventaris RAM, SSD, LCD, Baterai & Keyboard.',
                          style: TextStyle(color: Colors.white70, fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bar Pencarian & Filter
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Cari SKU, nama sparepart, tipe...',
                      prefixIcon: const Icon(Icons.search),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: _searchCtrl.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchCtrl.clear();
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
          ),

          // Total & Indikator Kritis
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ${filteredParts.length} jenis suku cadang',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                if (state.lowStockCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, size: 14, color: Colors.red),
                        const SizedBox(width: 4),
                        Text(
                          '${state.lowStockCount} Stok Kritis',
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const Divider(),

          // List Sparepart
          Expanded(
            child: filteredParts.isEmpty
                ? const Center(child: Text('Tidak ada suku cadang ditemukan.'))
                : ListView.builder(
                    itemCount: filteredParts.length,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    itemBuilder: (context, index) {
                      final p = filteredParts[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: p.isLowStock
                                        ? Colors.red.shade100
                                        : Colors.blue.shade100,
                                    child: Icon(
                                      Icons.memory,
                                      color: p.isLowStock ? Colors.red : Colors.blue.shade800,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'SKU: ${p.sku} • Kategori: ${p.category}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          'Kompatibilitas: ${p.compatibility}',
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Badge Stok
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: p.isLowStock
                                              ? Colors.red.shade600
                                              : Colors.green.shade600,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Stok: ${p.stock}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Rak: ${p.rackLocation}',
                                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Harga Jual: ${currencyFormatter.format(p.sellPrice)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                      Text(
                                        'Harga Modal: ${currencyFormatter.format(p.buyPrice)}',
                                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          visualDensity: VisualDensity.compact,
                                        ),
                                        icon: const Icon(Icons.add, size: 14),
                                        label: const Text('Restok (+5)'),
                                        onPressed: () {
                                          state.restockSparepart(p.id, 5);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Stok ${p.name} ditambah 5 unit.'),
                                              duration: const Duration(seconds: 1),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showAddSparepartDialog(BuildContext context, AppState state) {
    final skuCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final categoryCtrl = TextEditingController(text: 'Hardware');
    final compCtrl = TextEditingController();
    final buyPriceCtrl = TextEditingController();
    final sellPriceCtrl = TextEditingController();
    final stockCtrl = TextEditingController(text: '5');
    final rackCtrl = TextEditingController(text: 'Rak A-1');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Suku Cadang Baru'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: skuCtrl,
                decoration: const InputDecoration(labelText: 'Kode SKU *', hintText: 'SSD-512-SAMS'),
              ),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nama Sparepart *'),
              ),
              TextField(
                controller: categoryCtrl,
                decoration: const InputDecoration(labelText: 'Kategori'),
              ),
              TextField(
                controller: compCtrl,
                decoration: const InputDecoration(labelText: 'Kompatibilitas Tipe Laptop'),
              ),
              TextField(
                controller: buyPriceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga Beli Modal (Rp)'),
              ),
              TextField(
                controller: sellPriceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga Jual (Rp)'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: stockCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Jumlah Stok Awal'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: rackCtrl,
                      decoration: const InputDecoration(labelText: 'Lokasi Rak Gudang'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (skuCtrl.text.isNotEmpty && nameCtrl.text.isNotEmpty) {
                final part = Sparepart(
                  id: 'sp-${DateTime.now().millisecondsSinceEpoch}',
                  sku: skuCtrl.text.trim(),
                  name: nameCtrl.text.trim(),
                  category: categoryCtrl.text.trim(),
                  compatibility: compCtrl.text.trim(),
                  buyPrice: double.tryParse(buyPriceCtrl.text) ?? 0,
                  sellPrice: double.tryParse(sellPriceCtrl.text) ?? 0,
                  stock: int.tryParse(stockCtrl.text) ?? 1,
                  rackLocation: rackCtrl.text.trim(),
                );
                state.addSparepart(part);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sparepart berhasil ditambahkan ke inventaris!')),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}

