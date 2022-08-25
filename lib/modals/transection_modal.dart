class TransactionModal {
  final int amount;
  final DateTime date;
  final String type;
  final String note;

  TransactionModal({
    required this.amount,
    required this.date,
    required this.note,
    required this.type,
  });
}
