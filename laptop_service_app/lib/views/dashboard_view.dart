import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';

class DashboardView extends StatelessWidget {
  final Function(int) onNavigateTab;

  const DashboardView({super.key, required this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pandhawa Notbook Salatiga'),
        actions: [
          IconButton(
            tooltip: 'Tambah Servis Baru',
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => onNavigateTab(1),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Sambutan & Brand
            Card(
              elevation: 3,
              color: const Color(0xFF0F1E36),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.5), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyanAccent.withValues(alpha: 0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pandhawa Notbook Salatiga',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Pusat Servis Laptop & Suku Cadang Terpercaya Salatiga',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Kartu Statistik / Metric Cards
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildStatCard(
                  title: 'Unit Aktif',
                  value: '${state.activeTicketsCount}',
                  subtitle: '${state.queueCount} antre • ${state.inProgressCount} proses',
                  icon: Icons.assignment_outlined,
                  color: Colors.blue,
                  onTap: () => onNavigateTab(2),
                ),
                _buildStatCard(
                  title: 'Siap Diambil',
                  value: '${state.readyCount}',
                  subtitle: 'Menunggu pembayaran kasir',
                  icon: Icons.check_circle_outline,
                  color: Colors.teal,
                  onTap: () => onNavigateTab(4),
                ),
                _buildStatCard(
                  title: 'Stok Kritis',
                  value: '${state.lowStockCount}',
                  subtitle: 'Item sparepart hampir habis',
                  icon: Icons.warning_amber_rounded,
                  color: state.lowStockCount > 0 ? Colors.red : Colors.green,
                  onTap: () => onNavigateTab(3),
                ),
                _buildStatCard(
                  title: 'Total Pendapatan',
                  value: currencyFormatter.format(state.totalRevenue),
                  subtitle: '${state.transactions.length} transaksi selesai',
                  icon: Icons.account_balance_wallet_outlined,
                  color: Colors.deepPurple,
                  onTap: () => onNavigateTab(4),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Fitur & Layanan Utama
            const Row(
              children: [
                Icon(Icons.apps_rounded, size: 20, color: Colors.blueAccent),
                SizedBox(width: 8),
                Text(
                  'Fitur & Layanan Utama',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 800;
                return GridView.count(
                  crossAxisCount: isWide ? 5 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: isWide ? 1.05 : 0.95,
                  children: [
                    _buildFeatureCard(
                      title: 'Registrasi Unit',
                      subtitle: 'Penerimaan Servis',
                      imagePath: 'assets/images/registration.jpg',
                      color: Colors.blue,
                      onTap: () => onNavigateTab(1),
                    ),
                    _buildFeatureCard(
                      title: 'Meja Teknisi',
                      subtitle: 'Diagnosa & Servis',
                      imagePath: 'assets/images/technician.jpg',
                      color: Colors.orange,
                      onTap: () => onNavigateTab(2),
                    ),
                    _buildFeatureCard(
                      title: 'Gudang Sparepart',
                      subtitle: 'Stok Komponen',
                      imagePath: 'assets/images/inventory.jpg',
                      color: Colors.purple,
                      onTap: () => onNavigateTab(3),
                    ),
                    _buildFeatureCard(
                      title: 'Kasir POS',
                      subtitle: 'Nota & Kasir',
                      imagePath: 'assets/images/pos.jpg',
                      color: Colors.green,
                      onTap: () => onNavigateTab(4),
                    ),
                    _buildFeatureCard(
                      title: 'Portal Tracking',
                      subtitle: 'Lacak Progres',
                      imagePath: 'assets/images/tracking.jpg',
                      color: Colors.teal,
                      onTap: () => onNavigateTab(5),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Daftar Unit Dalam Pengerjaan Terbaru
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Servis Terkini',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => onNavigateTab(2),
                  child: const Text('Lihat Semua'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...state.tickets.take(4).map((ticket) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(ticket.status).withValues(alpha: 0.2),
                    child: Icon(Icons.laptop, color: _getStatusColor(ticket.status)),
                  ),
                  title: Text(
                    '${ticket.deviceBrand} ${ticket.deviceModel} • ${ticket.customerName}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Tiket: ${ticket.ticketNo} • Teknisi: ${ticket.technicianName ?? 'Belum ada'}',
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(ticket.status).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      ticket.statusLabel,
                      style: TextStyle(
                        color: _getStatusColor(ticket.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  onTap: () => onNavigateTab(2),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'queue':
        return Colors.orange;
      case 'diagnosing':
        return Colors.amber.shade800;
      case 'waiting_approval':
        return Colors.purple;
      case 'in_progress':
        return Colors.blue;
      case 'qc':
        return Colors.indigo;
      case 'ready':
        return Colors.teal;
      case 'closed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 170,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Icon(Icons.arrow_forward_ios, size: 12, color: color),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Colors.black54),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required String imagePath,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

