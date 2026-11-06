class TicketSparepartItem {
  final String sparepartId;
  final String name;
  final int qty;
  final double unitPrice;

  TicketSparepartItem({
    required this.sparepartId,
    required this.name,
    required this.qty,
    required this.unitPrice,
  });

  double get totalPrice => qty * unitPrice;
}

class ServiceTicket {
  final String id;
  final String ticketNo;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String deviceBrand;
  final String deviceModel;
  final String serialNumber;
  final String devicePassword;
  final Map<String, bool> physicalChecklist;
  String status; // queue, diagnosing, waiting_approval, in_progress, qc, ready, closed, cancelled
  String? technicianName;
  double serviceFee;
  double estimatedCost;
  double dpAmount;
  bool isApproved;
  int warrantyDays;
  final DateTime createdAt;
  final List<TicketSparepartItem> usedSpareparts;
  final List<String> workLogs;

  ServiceTicket({
    required this.id,
    required this.ticketNo,
    required this.customerName,
    required this.customerPhone,
    this.customerAddress = '',
    required this.deviceBrand,
    required this.deviceModel,
    this.serialNumber = '',
    this.devicePassword = '',
    required this.physicalChecklist,
    this.status = 'queue',
    this.technicianName,
    this.serviceFee = 0.0,
    this.estimatedCost = 0.0,
    this.dpAmount = 0.0,
    this.isApproved = false,
    this.warrantyDays = 30,
    required this.createdAt,
    List<TicketSparepartItem>? usedSpareparts,
    List<String>? workLogs,
  })  : usedSpareparts = usedSpareparts ?? [],
        workLogs = workLogs ?? [];

  double get sparepartTotal =>
      usedSpareparts.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get grandTotal => serviceFee + sparepartTotal;
  double get remainingBill => grandTotal - dpAmount;

  String get statusLabel {
    switch (status) {
      case 'queue':
        return 'Antrean Masuk';
      case 'diagnosing':
        return 'Tahap Diagnosa';
      case 'waiting_approval':
        return 'Menunggu Persetujuan';
      case 'in_progress':
        return 'Sedang Dikerjakan';
      case 'qc':
        return 'Quality Control (QC)';
      case 'ready':
        return 'Siap Diambil';
      case 'closed':
        return 'Selesai & Diambil';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status.toUpperCase();
    }
  }
}

