class PosTransaction {
  final String id;
  final String invoiceNo;
  final String ticketNo;
  final String customerName;
  final double totalAmount;
  final String paymentMethod; // cash, qris, transfer, edc
  final String paymentStatus;
  final DateTime createdAt;

  PosTransaction({
    required this.id,
    required this.invoiceNo,
    required this.ticketNo,
    required this.customerName,
    required this.totalAmount,
    required this.paymentMethod,
    this.paymentStatus = 'paid',
    required this.createdAt,
  });

  String get paymentMethodLabel {
    switch (paymentMethod.toLowerCase()) {
      case 'cash':
        return 'Tunai (Cash)';
      case 'qris':
        return 'QRIS (Gopay/OVO/BCA)';
      case 'transfer':
        return 'Transfer Bank';
      case 'edc':
        return 'Kartu Debit/Kredit (EDC)';
      default:
        return paymentMethod.toUpperCase();
    }
  }
}

