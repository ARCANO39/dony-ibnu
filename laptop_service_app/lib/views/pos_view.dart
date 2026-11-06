import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/service_ticket.dart';
import '../services/app_state.dart';

class PosView extends StatefulWidget {
  const PosView({super.key});

  @override
  State<PosView> createState() => _PosViewState();
}

class _PosViewState extends State<PosView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    // Tiket yang siap dibayar (siap diambil atau sedang diproses)
    final pendingPaymentTickets = state.tickets
        .where((t) => t.status != 'closed' && t.status != 'cancelled')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasir & Pembayaran (POS)'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Tagihan Berjalan (${pendingPaymentTickets.length})'),
            Tab(text: 'Riwayat Transaksi (${state.transactions.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Tagihan yang perlu diselesaikan
          _buildPendingTicketsTab(pendingPaymentTickets, state),

          // Tab 2: Riwayat Transaksi Selesai
          _buildTransactionHistoryTab(state),
        ],
      ),
    );
  }

  Widget _buildPendingTicketsTab(List<ServiceTicket> tickets, AppState state) {
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: tickets.isEmpty ? 2 : tickets.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
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
                    'assets/images/pos.jpg',
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
                          'Kasir & Pembayaran Pandhawa',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Penyelesaian nota servis, pelunasan sisa DP & cetak struk kasir.',
                          style: TextStyle(color: Colors.white70, fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (tickets.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Center(
              child: Text(
                'Tidak ada unit yang menunggu pembayaran kasir.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        final t = tickets[index - 1];
        final isReady = t.status == 'ready';

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      t.ticketNo,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isReady
                            ? Colors.teal.shade100
                            : Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        t.statusLabel,
                        style: TextStyle(
                          color: isReady
                              ? Colors.teal.shade900
                              : Colors.orange.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${t.deviceBrand} ${t.deviceModel} • Pelanggan: ${t.customerName}',
                  style: const TextStyle(fontSize: 13),
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jasa: ${currencyFormatter.format(t.serviceFee)}',
                            style: const TextStyle(fontSize: 12)),
                        Text(
                            'Part: ${currencyFormatter.format(t.sparepartTotal)}',
                            style: const TextStyle(fontSize: 12)),
                        Text(
                            'DP Masuk: ${currencyFormatter.format(t.dpAmount)}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.green)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Sisa Tagihan:',
                            style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text(
                          currencyFormatter.format(t.remainingBill),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isReady ? Colors.teal : Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isReady ? Colors.teal : null,
                      foregroundColor: isReady ? Colors.white : null,
                    ),
                    icon: const Icon(Icons.payment),
                    label: Text(
                      isReady
                          ? 'Bayar & Ambil Unit (Pelunasan)'
                          : 'Proses Pembayaran / DP',
                    ),
                    onPressed: () => _showPaymentDialog(context, t, state),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransactionHistoryTab(AppState state) {
    final txs = state.transactions;
    if (txs.isEmpty) {
      return const Center(child: Text('Belum ada riwayat transaksi kasir.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: txs.length,
      itemBuilder: (context, index) {
        final tx = txs[index];
        final dateStr = DateFormat('dd/MM/yyyy HH:mm').format(tx.createdAt);

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.receipt_long, color: Colors.white),
            ),
            title: Text(
              '${tx.invoiceNo} • ${currencyFormatter.format(tx.totalAmount)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${tx.customerName} (${tx.ticketNo})\nMetode: ${tx.paymentMethodLabel} • $dateStr',
              style: const TextStyle(fontSize: 12),
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  void _showPaymentDialog(
      BuildContext context, ServiceTicket ticket, AppState state) {
    String selectedMethod = 'qris';
    final amountToPay =
        ticket.remainingBill > 0 ? ticket.remainingBill : ticket.grandTotal;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: Text('Pelunasan: ${ticket.ticketNo}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pelanggan: ${ticket.customerName}'),
                Text('Unit: ${ticket.deviceBrand} ${ticket.deviceModel}'),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Biaya:'),
                    Text(currencyFormatter.format(ticket.grandTotal)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Uang Muka (DP):'),
                    Text('- ${currencyFormatter.format(ticket.dpAmount)}'),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Yang Harus Dibayar:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      currencyFormatter.format(amountToPay),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Pilih Metode Pembayaran:',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: selectedMethod,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), isDense: true),
                  items: const [
                    DropdownMenuItem(
                        value: 'qris', child: Text('QRIS (BCA / Gopay / OVO)')),
                    DropdownMenuItem(
                        value: 'cash', child: Text('Tunai (Cash)')),
                    DropdownMenuItem(
                        value: 'transfer',
                        child: Text('Transfer Bank Mandiri / BCA')),
                    DropdownMenuItem(
                        value: 'edc',
                        child: Text('Kartu Debit / Kredit (EDC)')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDialogState(() => selectedMethod = val);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.pop(ctx);
                  state.processPayment(
                    ticketId: ticket.id,
                    amount: amountToPay,
                    paymentMethod: selectedMethod,
                  );

                  // Tampilkan Nota Struk Lunas
                  _showReceiptModal(
                      context, ticket, amountToPay, selectedMethod);
                },
                child: const Text('Konfirmasi & Selesaikan'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showReceiptModal(
    BuildContext context,
    ServiceTicket ticket,
    double paidAmount,
    String method,
  ) {
    final now = DateTime.now();
    final invoice =
        'INV-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-099';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Pembayaran Berhasil!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('No. Invoice: $invoice',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            QrImageView(
              data: 'https://service-tracking.app/invoice/$invoice',
              version: QrVersions.auto,
              size: 130.0,
            ),
            const SizedBox(height: 12),
            Text('Unit: ${ticket.deviceBrand} ${ticket.deviceModel}'),
            Text('Total Dibayar: ${currencyFormatter.format(paidAmount)}'),
            Text('Metode: ${method.toUpperCase()}'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Garansi Servis Berlaku: ${ticket.warrantyDays} Hari',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
