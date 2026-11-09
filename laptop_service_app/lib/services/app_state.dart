import 'package:flutter/foundation.dart';
import '../models/service_ticket.dart';
import '../models/sparepart.dart';
import '../models/transaction.dart';

class AppState extends ChangeNotifier {
  final List<ServiceTicket> _tickets = [];
  final List<Sparepart> _spareparts = [];
  final List<PosTransaction> _transactions = [];

  List<ServiceTicket> get tickets => List.unmodifiable(_tickets);
  List<Sparepart> get spareparts => List.unmodifiable(_spareparts);
  List<PosTransaction> get transactions => List.unmodifiable(_transactions);

  AppState() {
    _seedInitialData();
  }

  void _seedInitialData() {
    // 1. Data Inventaris Sparepart Awal
    _spareparts.addAll([
      Sparepart(
        id: 'sp-1',
        sku: 'SSD-NVME-512',
        name: 'SSD NVMe M.2 512GB Kingston NV2',
        category: 'Storage',
        compatibility: 'Semua laptop slot M.2 NVMe',
        buyPrice: 420000,
        sellPrice: 580000,
        stock: 12,
        minStock: 4,
        rackLocation: 'Rak A-1',
      ),
      Sparepart(
        id: 'sp-2',
        sku: 'RAM-DDR4-8GB',
        name: 'RAM Sodimm DDR4 8GB 3200MHz Samsung',
        category: 'Memory',
        compatibility: 'Laptop DDR4',
        buyPrice: 210000,
        sellPrice: 320000,
        stock: 8,
        minStock: 3,
        rackLocation: 'Rak A-2',
      ),
      Sparepart(
        id: 'sp-3',
        sku: 'THRM-ART-MX4',
        name: 'Thermal Paste Arctic MX-4 4gr (High Performance)',
        category: 'Cooling',
        compatibility: 'Universal CPU & GPU',
        buyPrice: 75000,
        sellPrice: 130000,
        stock: 2, // Low stock alert!
        minStock: 3,
        rackLocation: 'Laci B-01',
      ),
      Sparepart(
        id: 'sp-4',
        sku: 'KBD-ASUS-X441',
        name: 'Keyboard Asus Vivobook X441 Series',
        category: 'Keyboard',
        compatibility: 'Asus X441, X441U, X441N, X441S',
        buyPrice: 110000,
        sellPrice: 200000,
        stock: 5,
        minStock: 2,
        rackLocation: 'Rak C-3',
      ),
      Sparepart(
        id: 'sp-5',
        sku: 'LCD-14-30PIN-IPS',
        name: 'Layar LCD LED 14.0 Slim 30 Pin FHD IPS',
        category: 'Display',
        compatibility: 'Lenovo, Asus, Acer, HP 14 inch slim',
        buyPrice: 650000,
        sellPrice: 950000,
        stock: 3,
        minStock: 2,
        rackLocation: 'Etalase D-1',
      ),
      Sparepart(
        id: 'sp-6',
        sku: 'BAT-LEN-L16M2PB1',
        name: 'Baterai Original Lenovo Ideapad 320/330/520',
        category: 'Battery',
        compatibility: 'Lenovo Ideapad 320-14AST, 330-14IKB',
        buyPrice: 280000,
        sellPrice: 450000,
        stock: 1, // Low stock alert!
        minStock: 2,
        rackLocation: 'Rak E-2',
      ),
      Sparepart(
        id: 'sp-7',
        sku: 'SSD-NVME-1TB',
        name: 'SSD M.2 NVMe PCIe 4.0 1TB Samsung 980 Pro',
        category: 'Storage',
        compatibility: 'Laptop Gaming & High-End PC M.2 NVMe Gen4',
        buyPrice: 1150000,
        sellPrice: 1450000,
        stock: 6,
        minStock: 2,
        rackLocation: 'Rak A-1',
      ),
      Sparepart(
        id: 'sp-8',
        sku: 'SSD-SATA-256GB',
        name: 'SSD SATA 2.5 Inch 256GB V-GeN Platinum',
        category: 'Storage',
        compatibility: 'Semua laptop & PC slot SATA 2.5',
        buyPrice: 240000,
        sellPrice: 350000,
        stock: 15,
        minStock: 4,
        rackLocation: 'Rak A-3',
      ),
      Sparepart(
        id: 'sp-9',
        sku: 'KBD-LEN-T480-BL',
        name: 'Keyboard Lenovo ThinkPad T480 / T470 Backlit US Layout',
        category: 'Keyboard',
        compatibility: 'Lenovo ThinkPad T470, T480, A475, A485',
        buyPrice: 275000,
        sellPrice: 420000,
        stock: 4,
        minStock: 2,
        rackLocation: 'Rak C-1',
      ),
      Sparepart(
        id: 'sp-10',
        sku: 'KBD-ACR-A314',
        name: 'Keyboard Acer Aspire 3 A314-32 / A314-33 / A314-21',
        category: 'Keyboard',
        compatibility: 'Acer Aspire 3 A314 Series Black',
        buyPrice: 125000,
        sellPrice: 220000,
        stock: 7,
        minStock: 2,
        rackLocation: 'Rak C-2',
      ),
      Sparepart(
        id: 'sp-11',
        sku: 'RAM-DDR5-16GB',
        name: 'RAM Sodimm DDR5 16GB 4800MHz Crucial Micron',
        category: 'Memory',
        compatibility: 'Laptop Intel 12-14th Gen & AMD Ryzen 6000-8000 Series',
        buyPrice: 580000,
        sellPrice: 780000,
        stock: 5,
        minStock: 2,
        rackLocation: 'Rak A-2',
      ),
      Sparepart(
        id: 'sp-12',
        sku: 'FAN-ASUS-FX505',
        name: 'Kipas Fan CPU GPU Cooler Asus TUF FX505 FX505D FX505G',
        category: 'Cooling',
        compatibility: 'Asus TUF Gaming FX505, FX505DU, FX505DT, FX705',
        buyPrice: 135000,
        sellPrice: 250000,
        stock: 2, // Low stock alert!
        minStock: 3,
        rackLocation: 'Laci B-02',
      ),
    ]);

    // 2. Data Tiket Servis Awal
    final ticket1 = ServiceTicket(
      id: 't-1',
      ticketNo: 'SRV-20261012-001',
      customerName: 'Ahmad Fauzi',
      customerPhone: '081234561234',
      customerAddress: 'Jl. Merdeka No. 45',
      deviceBrand: 'Asus',
      deviceModel: 'ROG Zephyrus G14',
      serialNumber: 'SN-ASUS-98231',
      devicePassword: 'user123',
      physicalChecklist: {
        'Baret Halus Casing': true,
        'Retak / Pecah': false,
        'Baut Kurang': false,
        'Bawa Charger': true,
        'Bawa Tas': false,
      },
      status: 'in_progress',
      technicianName: 'Dony Ibnu Prakoso',
      serviceFee: 250000,
      estimatedCost: 750000,
      dpAmount: 200000,
      isApproved: true,
      warrantyDays: 30,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      usedSpareparts: [
        TicketSparepartItem(
          sparepartId: 'sp-3',
          name: 'Thermal Paste Arctic MX-4 4gr (High Performance)',
          qty: 1,
          unitPrice: 130000,
        ),
      ],
      workLogs: [
        '[12/10 10:15] Unit diterima di kasir dengan keluhan Overheat & Mati Mendadak saat main game.',
        '[12/10 14:00] Teknisi Dony Ibnu Prakoso: Diagnosa thermal paste kering dan kipas berdebu tebal.',
        '[13/10 09:30] Pelanggan menyetujui estimasi biaya pembersihan & repasting.',
        '[13/10 11:00] Pembersihan heatsink selesai, pengujian stres tes FurMark.',
      ],
    );

    final ticket2 = ServiceTicket(
      id: 't-2',
      ticketNo: 'SRV-20261018-002',
      customerName: 'Siti Rahma',
      customerPhone: '085788995678',
      customerAddress: 'Komplek Melati Indah B-10',
      deviceBrand: 'Lenovo',
      deviceModel: 'Ideapad Slim 3',
      serialNumber: 'LN-SLIM3-5511',
      devicePassword: 'tidak ada',
      physicalChecklist: {
        'Baret Halus Casing': false,
        'Retak / Pecah': true,
        'Baut Kurang': false,
        'Bawa Charger': true,
        'Bawa Tas': true,
      },
      status: 'ready',
      technicianName: 'Dony Ibnu Prakoso',
      serviceFee: 150000,
      estimatedCost: 1100000,
      dpAmount: 500000,
      isApproved: true,
      warrantyDays: 30,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      usedSpareparts: [
        TicketSparepartItem(
          sparepartId: 'sp-5',
          name: 'Layar LCD LED 14.0 Slim 30 Pin FHD IPS',
          qty: 1,
          unitPrice: 950000,
        ),
      ],
      workLogs: [
        '[18/10 11:30] Unit masuk dengan kondisi LCD bergaris dan pecah akibat terjepit buku.',
        '[18/10 15:45] Penggantian modul LCD baru 14.0 FHD selesai dilakukan.',
        '[19/10 10:00] QC lolos: Dead pixel nihil, kecerahan normal. Unit siap diambil pelanggan.',
      ],
    );

    final ticket3 = ServiceTicket(
      id: 't-3',
      ticketNo: 'SRV-20261025-003',
      customerName: 'Rian Saputra',
      customerPhone: '081399884321',
      deviceBrand: 'Acer',
      deviceModel: 'Aspire 5 A514',
      serialNumber: 'ACR-ASP5-7762',
      physicalChecklist: {
        'Baret Halus Casing': true,
        'Retak / Pecah': false,
        'Baut Kurang': false,
        'Bawa Charger': true,
        'Bawa Tas': false,
      },
      status: 'queue',
      technicianName: null,
      serviceFee: 100000,
      estimatedCost: 400000,
      dpAmount: 0,
      isApproved: false,
      warrantyDays: 30,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      workLogs: [
        '[Hari ini] Unit baru masuk antrean. Keluhan: Loading Windows sangat lambat dan disk usage 100%. Saran upgrade SSD.',
      ],
    );

    _tickets.addAll([ticket1, ticket2, ticket3]);

    // 3. Riwayat Transaksi POS Awal
    _transactions.add(
      PosTransaction(
        id: 'tx-1',
        invoiceNo: 'INV-20261020-008',
        ticketNo: 'SRV-20261010-099',
        customerName: 'Hendra Gunawan',
        totalAmount: 450000,
        paymentMethod: 'qris',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    );
  }

  // --- ACTIONS ---

  void addTicket(ServiceTicket ticket) {
    _tickets.insert(0, ticket);
    notifyListeners();
  }

  void updateTicketStatus(String ticketId, String newStatus) {
    final index = _tickets.indexWhere((t) => t.id == ticketId);
    if (index != -1) {
      _tickets[index].status = newStatus;
      _tickets[index].workLogs.add(
        '[Status Diperbarui] Status unit diubah menjadi: ${_tickets[index].statusLabel}',
      );
      notifyListeners();
    }
  }

  void assignTechnician(String ticketId, String techName) {
    final index = _tickets.indexWhere((t) => t.id == ticketId);
    if (index != -1) {
      _tickets[index].technicianName = techName;
      _tickets[index].workLogs.add(
        '[Penugasan] Teknisi $techName ditugaskan untuk menangani unit ini.',
      );
      notifyListeners();
    }
  }

  void addWorkLog(String ticketId, String logText) {
    final index = _tickets.indexWhere((t) => t.id == ticketId);
    if (index != -1 && logText.trim().isNotEmpty) {
      _tickets[index].workLogs.add('[Catatan] $logText');
      notifyListeners();
    }
  }

  bool addSparepartToTicket(String ticketId, Sparepart sparepart, int qty) {
    final partIndex = _spareparts.indexWhere((p) => p.id == sparepart.id);
    if (partIndex == -1 || _spareparts[partIndex].stock < qty) {
      return false; // Stok tidak cukup
    }

    final ticketIndex = _tickets.indexWhere((t) => t.id == ticketId);
    if (ticketIndex == -1) return false;

    // 1. Kurangi stok sparepart (Otomatis sesuai trigger DB)
    _spareparts[partIndex].stock -= qty;

    // 2. Tambahkan ke tiket
    _tickets[ticketIndex].usedSpareparts.add(
      TicketSparepartItem(
        sparepartId: sparepart.id,
        name: sparepart.name,
        qty: qty,
        unitPrice: sparepart.sellPrice,
      ),
    );

    // Update estimasi biaya
    _tickets[ticketIndex].estimatedCost = _tickets[ticketIndex].grandTotal;

    _tickets[ticketIndex].workLogs.add(
      '[Penggantian Part] Pemasangan $qty unit ${sparepart.name} (Stok gudang sisa ${_spareparts[partIndex].stock}).',
    );

    notifyListeners();
    return true;
  }

  void addSparepart(Sparepart part) {
    _spareparts.insert(0, part);
    notifyListeners();
  }

  void restockSparepart(String partId, int addStock) {
    final index = _spareparts.indexWhere((p) => p.id == partId);
    if (index != -1) {
      _spareparts[index].stock += addStock;
      notifyListeners();
    }
  }

  void processPayment({
    required String ticketId,
    required double amount,
    required String paymentMethod,
  }) {
    final ticketIndex = _tickets.indexWhere((t) => t.id == ticketId);
    if (ticketIndex == -1) return;

    final ticket = _tickets[ticketIndex];
    ticket.status = 'closed';
    ticket.workLogs.add(
      '[Pembayaran Kasir] Pembayaran lunas sebesar Rp $amount via $paymentMethod. Garansi berlaku ${ticket.warrantyDays} hari.',
    );

    final invoice = 'INV-${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}-${(100 + _transactions.length + 1)}';

    _transactions.insert(
      0,
      PosTransaction(
        id: 'tx-${DateTime.now().millisecondsSinceEpoch}',
        invoiceNo: invoice,
        ticketNo: ticket.ticketNo,
        customerName: ticket.customerName,
        totalAmount: amount,
        paymentMethod: paymentMethod,
        createdAt: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  ServiceTicket? findTicketByNoAndPhone(String ticketNo, String phoneSuffix) {
    try {
      return _tickets.firstWhere((t) {
        final matchNo = t.ticketNo.toLowerCase() == ticketNo.trim().toLowerCase();
        final matchPhone = t.customerPhone.endsWith(phoneSuffix.trim());
        return matchNo && matchPhone;
      });
    } catch (_) {
      return null;
    }
  }

  // Ringkasan Statistik
  int get activeTicketsCount =>
      _tickets.where((t) => t.status != 'closed' && t.status != 'cancelled').length;

  int get queueCount => _tickets.where((t) => t.status == 'queue').length;
  int get inProgressCount =>
      _tickets.where((t) => t.status == 'in_progress' || t.status == 'diagnosing').length;
  int get readyCount => _tickets.where((t) => t.status == 'ready').length;
  int get lowStockCount => _spareparts.where((s) => s.isLowStock).length;

  double get totalRevenue =>
      _transactions.fold(0.0, (sum, tx) => sum + tx.totalAmount);
}

