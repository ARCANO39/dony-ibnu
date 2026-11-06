import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/service_ticket.dart';
import '../services/app_state.dart';

class TicketRegistrationView extends StatefulWidget {
  final Function(int) onNavigateTab;

  const TicketRegistrationView({super.key, required this.onNavigateTab});

  @override
  State<TicketRegistrationView> createState() => _TicketRegistrationViewState();
}

class _TicketRegistrationViewState extends State<TicketRegistrationView> {
  final _formKey = GlobalKey<FormState>();

  final _customerNameCtrl = TextEditingController();
  final _customerPhoneCtrl = TextEditingController();
  final _customerAddressCtrl = TextEditingController();

  final _deviceBrandCtrl = TextEditingController(text: 'Asus');
  final _deviceModelCtrl = TextEditingController();
  final _serialNumberCtrl = TextEditingController();
  final _devicePasswordCtrl = TextEditingController();
  final _complaintCtrl = TextEditingController();
  final _dpCtrl = TextEditingController(text: '0');

  final Map<String, bool> _checklist = {
    'Baret Halus Casing': false,
    'Retak / Pecah Fisik': false,
    'Baut Bawah Kurang': false,
    'Bawa Charger Original': true,
    'Bawa Tas Laptop': false,
  };

  @override
  void dispose() {
    _customerNameCtrl.dispose();
    _customerPhoneCtrl.dispose();
    _customerAddressCtrl.dispose();
    _deviceBrandCtrl.dispose();
    _deviceModelCtrl.dispose();
    _serialNumberCtrl.dispose();
    _devicePasswordCtrl.dispose();
    _complaintCtrl.dispose();
    _dpCtrl.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final state = context.read<AppState>();
    final count = state.tickets.length + 1;
    final now = DateTime.now();
    final ticketNo =
        'SRV-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${count.toString().padLeft(3, '0')}';

    final dp = double.tryParse(_dpCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0;

    final newTicket = ServiceTicket(
      id: 't-${now.millisecondsSinceEpoch}',
      ticketNo: ticketNo,
      customerName: _customerNameCtrl.text.trim(),
      customerPhone: _customerPhoneCtrl.text.trim(),
      customerAddress: _customerAddressCtrl.text.trim(),
      deviceBrand: _deviceBrandCtrl.text.trim(),
      deviceModel: _deviceModelCtrl.text.trim(),
      serialNumber: _serialNumberCtrl.text.trim(),
      devicePassword: _devicePasswordCtrl.text.trim(),
      physicalChecklist: Map.from(_checklist),
      status: 'queue',
      dpAmount: dp,
      createdAt: now,
      workLogs: [
        '[Penerimaan Unit] Keluhan awal: ${_complaintCtrl.text.trim().isEmpty ? 'Pemeriksaan umum' : _complaintCtrl.text.trim()}',
      ],
    );

    state.addTicket(newTicket);

    // Tampilkan Dialog Bukti Penerimaan + QR Code
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Registrasi Berhasil!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              ticketNo,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            QrImageView(
              data: ticketNo,
              version: QrVersions.auto,
              size: 160.0,
            ),
            const SizedBox(height: 12),
            Text(
              'Pelanggan: ${_customerNameCtrl.text} (${_deviceBrandCtrl.text} ${_deviceModelCtrl.text})',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 6),
            const Text(
              'QR Code dapat dicetak untuk stiker label fisik unit laptop atau diberikan ke pelanggan untuk tracking.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onNavigateTab(2); // Pindah ke Meja Teknisi
            },
            child: const Text('Buka di Meja Teknisi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi Servis Unit Masuk'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner Fitur Registrasi
              Card(
                elevation: 2,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/registration.jpg',
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.8),
                            Colors.black.withValues(alpha: 0.2),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.bottomLeft,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Penerimaan Unit Servis Baru',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Catat data pelanggan, spesifikasi laptop, keluhan kerusakan & cetak label QR.',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Bagian Data Pelanggan
              const Text(
                '1. Informasi Pelanggan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _customerNameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap Pelanggan *',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Wajib diisi' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _customerPhoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Nomor WhatsApp *',
                        prefixIcon: Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Wajib diisi' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _customerAddressCtrl,
                decoration: const InputDecoration(
                  labelText: 'Alamat Domisili (Opsional)',
                  prefixIcon: Icon(Icons.home_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Bagian Data Laptop
              const Text(
                '2. Data Unit Laptop',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _deviceBrandCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Merek (Asus, Lenovo, Acer, dll) *',
                        prefixIcon: Icon(Icons.branding_watermark_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Wajib diisi' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _deviceModelCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Model / Tipe Laptop *',
                        prefixIcon: Icon(Icons.laptop_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Wajib diisi' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _serialNumberCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nomor Seri / SN',
                        prefixIcon: Icon(Icons.qr_code),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _devicePasswordCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Password / PIN Windows (Jika ada)',
                        prefixIcon: Icon(Icons.password),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _complaintCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Keluhan Kerusakan / Masalah *',
                  hintText: 'Contoh: Mati total setelah kena tumpahan air, kipas bunyi keras',
                  prefixIcon: Icon(Icons.report_problem_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Tuliskan keluhan laptop' : null,
              ),
              const SizedBox(height: 24),

              // Checklist Kondisi Fisik
              const Text(
                '3. Checklist Kondisi Fisik & Kelengkapan Awal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: _checklist.keys.map((key) {
                    return CheckboxListTile(
                      dense: true,
                      title: Text(key),
                      value: _checklist[key],
                      onChanged: (val) {
                        setState(() {
                          _checklist[key] = val ?? false;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Uang Muka (DP)
              TextFormField(
                controller: _dpCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Uang Muka / DP (Rp)',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.print_outlined),
                  label: const Text(
                    'Simpan & Buat Tiket Servis',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

