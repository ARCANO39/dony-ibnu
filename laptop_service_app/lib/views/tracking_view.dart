import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/service_ticket.dart';
import '../services/app_state.dart';

class TrackingView extends StatefulWidget {
  const TrackingView({super.key});

  @override
  State<TrackingView> createState() => _TrackingViewState();
}

class _TrackingViewState extends State<TrackingView> {
  final _ticketController = TextEditingController(text: 'SRV-20261012-001');
  final _phoneController = TextEditingController(text: '1234');
  bool _isLoading = false;
  ServiceTicket? _foundTicket;
  String? _errorMessage;

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void dispose() {
    _ticketController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _searchTicket() {
    final ticketNo = _ticketController.text.trim();
    final phoneSuffix = _phoneController.text.trim();

    if (ticketNo.isEmpty) {
      setState(() {
        _errorMessage = 'Silakan masukkan nomor tiket servis.';
        _foundTicket = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _foundTicket = null;
    });

    final state = context.read<AppState>();
    final ticket = state.findTicketByNoAndPhone(ticketNo, phoneSuffix);

    setState(() {
      _isLoading = false;
      if (ticket == null) {
        _errorMessage =
            'Tiket tidak ditemukan atau 4 digit nomor WhatsApp tidak cocok.\n(Coba contoh tiket: SRV-20261012-001 dengan WA: 1234)';
      } else {
        _foundTicket = ticket;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portal Tracking Servis (Pelanggan)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner Tracking Pelanggan
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              height: 120,
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
                      'assets/images/tracking.jpg',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.black.withValues(alpha: 0.85),
                            Colors.black.withValues(alpha: 0.25),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      alignment: Alignment.centerLeft,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Portal Tracking Transparan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Pantau progres perbaikan unit laptop Anda secara langsung & akurat.',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Kotak Pencarian Tiket
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lacak Status Servis Laptop Anda',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Masukkan nomor tiket servis dan 4 digit terakhir nomor WhatsApp yang didaftarkan.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _ticketController,
                      decoration: const InputDecoration(
                        labelText: 'Nomor Tiket (Contoh: SRV-20261012-001)',
                        prefixIcon: Icon(Icons.confirmation_number_outlined),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: '4 Digit Terakhir Nomor WhatsApp',
                        prefixIcon: Icon(Icons.phone_android_outlined),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _searchTicket,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.search),
                        label: const Text('Lacak Progres Unit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Pesan Error
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),

            // Hasil Pelacakan Tiket
            if (_foundTicket != null) _buildResultCard(_foundTicket!),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(ServiceTicket ticket) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${ticket.deviceBrand} ${ticket.deviceModel}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    ticket.statusLabel,
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('No. Tiket: ${ticket.ticketNo} • Pemilik: ${ticket.customerName}'),
            const Divider(height: 24),

            // Rincian Penanganan
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text('Teknisi Penanggung Jawab'),
              subtitle: Text(
                ticket.technicianName ?? 'Dalam antrean penugasan teknisi',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.monetization_on_outlined, color: Colors.green),
              title: const Text('Estimasi Total Biaya'),
              subtitle: Text(
                currencyFormatter.format(ticket.grandTotal > 0 ? ticket.grandTotal : ticket.estimatedCost),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green),
              ),
            ),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                ticket.isApproved ? Icons.verified : Icons.help_outline,
                color: ticket.isApproved ? Colors.teal : Colors.orange,
              ),
              title: const Text('Persetujuan Biaya Pelanggan'),
              subtitle: Text(
                ticket.isApproved ? 'Sudah Disetujui' : 'Menunggu Konfirmasi Anda',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ticket.isApproved ? Colors.teal : Colors.orange,
                ),
              ),
            ),
            const Divider(height: 24),

            // Riwayat Timeline Log Kerja
            const Text(
              'Riwayat Progres Pengerjaan:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            if (ticket.workLogs.isEmpty)
              const Text('Belum ada catatan progres.')
            else
              ...ticket.workLogs.reversed.map((log) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(log, style: const TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

