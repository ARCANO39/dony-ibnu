import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/service_ticket.dart';
import '../models/sparepart.dart';
import '../services/app_state.dart';

class TechnicianView extends StatefulWidget {
  const TechnicianView({super.key});

  @override
  State<TechnicianView> createState() => _TechnicianViewState();
}

class _TechnicianViewState extends State<TechnicianView> {
  String _selectedFilter = 'all';
  ServiceTicket? _selectedTicket;

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final allTickets = state.tickets;

    // Filter tickets
    final filteredTickets = allTickets.where((t) {
      if (_selectedFilter == 'all') return true;
      if (_selectedFilter == 'active') {
        return t.status != 'closed' && t.status != 'cancelled';
      }
      return t.status == _selectedFilter;
    }).toList();

    // Pastikan _selectedTicket selalu merujuk ke objek terbaru di state
    if (_selectedTicket != null) {
      final updated = allTickets.where((t) => t.id == _selectedTicket!.id).firstOrNull;
      if (updated != null) {
        _selectedTicket = updated;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meja Kerja Teknisi (Workbench)'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                _buildFilterChip('Semua', 'all'),
                _buildFilterChip('Aktif', 'active'),
                _buildFilterChip('Antrean', 'queue'),
                _buildFilterChip('Diagnosa', 'diagnosing'),
                _buildFilterChip('Persetujuan', 'waiting_approval'),
                _buildFilterChip('Dikerjakan', 'in_progress'),
                _buildFilterChip('QC', 'qc'),
                _buildFilterChip('Siap Ambil', 'ready'),
                _buildFilterChip('Selesai', 'closed'),
              ],
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;

          if (isWide) {
            // Tampilan split view untuk layar desktop / lebar
            return Row(
              children: [
                SizedBox(
                  width: 320,
                  child: _buildTicketList(filteredTickets),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: _selectedTicket == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  'assets/images/technician.jpg',
                                  width: 280,
                                  height: 180,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Meja Kerja Teknisi Pandhawa Notbook',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Pilih tiket servis di sebelah kiri untuk melihat rincian & diagnosa unit.',
                                style: TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ],
                          ),
                        )
                      : _buildTicketDetail(_selectedTicket!, state),
                ),
              ],
            );
          } else {
            // Tampilan mobile
            return _selectedTicket == null
                ? _buildTicketList(filteredTickets)
                : PopScope(
                    canPop: false,
                    onPopInvokedWithResult: (didPop, _) {
                      if (!didPop) {
                        setState(() => _selectedTicket = null);
                      }
                    },
                    child: Scaffold(
                      appBar: AppBar(
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => setState(() => _selectedTicket = null),
                        ),
                        title: Text(_selectedTicket!.ticketNo),
                      ),
                      body: _buildTicketDetail(_selectedTicket!, state),
                    ),
                  );
          }
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            _selectedFilter = value;
          });
        },
      ),
    );
  }

  Widget _buildTicketList(List<ServiceTicket> tickets) {
    if (tickets.isEmpty) {
      return const Center(
        child: Text('Tidak ada tiket pada status ini.'),
      );
    }

    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final t = tickets[index];
        final isSelected = _selectedTicket?.id == t.id;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: isSelected ? Colors.blue.shade50 : null,
          child: ListTile(
            title: Text(
              '${t.deviceBrand} ${t.deviceModel}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${t.ticketNo} • ${t.customerName}', style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 2),
                Text(
                  'Status: ${t.statusLabel}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(t.status),
                  ),
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right, size: 18),
            onTap: () {
              setState(() {
                _selectedTicket = t;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildTicketDetail(ServiceTicket ticket, AppState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kartu Detail
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ticket.ticketNo,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Container(
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
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Text('Unit: ${ticket.deviceBrand} ${ticket.deviceModel}'),
                  Text('Serial Number: ${ticket.serialNumber.isEmpty ? '-' : ticket.serialNumber}'),
                  Text('Password Windows: ${ticket.devicePassword.isEmpty ? '-' : ticket.devicePassword}'),
                  const SizedBox(height: 6),
                  Text('Pelanggan: ${ticket.customerName} (${ticket.customerPhone})'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Pengaturan Status & Teknisi
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Perbarui Status & Teknisi',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: ticket.status,
                          decoration: const InputDecoration(
                            labelText: 'Ubah Status Unit',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: const [
                            DropdownMenuItem(value: 'queue', child: Text('Antrean Masuk')),
                            DropdownMenuItem(value: 'diagnosing', child: Text('Tahap Diagnosa')),
                            DropdownMenuItem(value: 'waiting_approval', child: Text('Menunggu Persetujuan')),
                            DropdownMenuItem(value: 'in_progress', child: Text('Sedang Dikerjakan')),
                            DropdownMenuItem(value: 'qc', child: Text('Quality Control (QC)')),
                            DropdownMenuItem(value: 'ready', child: Text('Siap Diambil')),
                            DropdownMenuItem(value: 'closed', child: Text('Selesai & Diambil')),
                            DropdownMenuItem(value: 'cancelled', child: Text('Dibatalkan')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              state.updateTicketStatus(ticket.id, val);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: ticket.technicianName,
                          decoration: const InputDecoration(
                            labelText: 'Tugaskan Teknisi',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: const [
                            DropdownMenuItem(value: null, child: Text('Belum Ditugaskan')),
                            DropdownMenuItem(value: 'Budi Santoso', child: Text('Budi Santoso')),
                            DropdownMenuItem(value: 'Doni Pratama', child: Text('Doni Pratama')),
                            DropdownMenuItem(value: 'Agus Wijaya', child: Text('Agus Wijaya')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              state.assignTechnician(ticket.id, val);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Sparepart yang Terpasang di Unit Ini
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Suku Cadang / Sparepart Terpasang',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Pasang Part'),
                        onPressed: () => _showAddPartDialog(context, ticket, state),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (ticket.usedSpareparts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Belum ada suku cadang yang digunakan untuk tiket ini.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    )
                  else
                    ...ticket.usedSpareparts.map((p) {
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.memory, color: Colors.blueAccent),
                        title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('${p.qty} unit @ ${currencyFormatter.format(p.unitPrice)}'),
                        trailing: Text(
                          currencyFormatter.format(p.totalPrice),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Biaya Jasa Servis:'),
                      Text(currencyFormatter.format(ticket.serviceFee)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Sparepart:'),
                      Text(currencyFormatter.format(ticket.sparepartTotal)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Estimasi Biaya:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        currencyFormatter.format(ticket.grandTotal),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Log Kerja Pengerjaan (Work Logs)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Catatan Pengerjaan (Work Logs)',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_comment_outlined),
                        tooltip: 'Tambah Catatan Log',
                        onPressed: () => _showAddLogDialog(context, ticket, state),
                      ),
                    ],
                  ),
                  const Divider(),
                  if (ticket.workLogs.isEmpty)
                    const Text('Belum ada catatan log.')
                  else
                    ...ticket.workLogs.reversed.map((log) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(child: Text(log, style: const TextStyle(fontSize: 13))),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPartDialog(BuildContext context, ServiceTicket ticket, AppState state) {
    Sparepart? selectedPart;
    int qty = 1;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: const Text('Pasang Suku Cadang ke Unit'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<Sparepart>(
                  isExpanded: true,
                  hint: const Text('Pilih sparepart dari gudang'),
                  initialValue: selectedPart,
                  items: state.spareparts.map((p) {
                    return DropdownMenuItem(
                      value: p,
                      child: Text(
                        '${p.name} (Stok: ${p.stock})',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: p.stock == 0 ? Colors.red : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setDialogState(() {
                      selectedPart = val;
                    });
                  },
                ),
                const SizedBox(height: 12),
                if (selectedPart != null) ...[
                  Text('Harga: ${currencyFormatter.format(selectedPart!.sellPrice)}'),
                  Text('Lokasi: ${selectedPart!.rackLocation}'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Jumlah (Qty): '),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: qty > 1
                            ? () => setDialogState(() => qty--)
                            : null,
                      ),
                      Text('$qty', style: const TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: (selectedPart != null && qty < selectedPart!.stock)
                            ? () => setDialogState(() => qty++)
                            : null,
                      ),
                    ],
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: selectedPart == null || selectedPart!.stock < qty
                    ? null
                    : () {
                        final success = state.addSparepartToTicket(
                          ticket.id,
                          selectedPart!,
                          qty,
                        );
                        Navigator.pop(ctx);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Sparepart berhasil dipasang! Stok ${selectedPart!.name} otomatis berkurang di gudang.',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                child: const Text('Pasang & Potong Stok'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddLogDialog(BuildContext context, ServiceTicket ticket, AppState state) {
    final logCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Catatan Pengerjaan'),
        content: TextField(
          controller: logCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Tuliskan perkembangan perbaikan unit...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (logCtrl.text.trim().isNotEmpty) {
                state.addWorkLog(ticket.id, logCtrl.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
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
}

