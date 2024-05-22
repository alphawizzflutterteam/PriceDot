class MyTransactionModel {
  MyTransactionModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool? status;
  final String? message;
  final List<TransactionData> data;

  factory MyTransactionModel.fromJson(Map<String, dynamic> json) {
    return MyTransactionModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<TransactionData>.from(json["data"]!.map((x) => TransactionData.fromJson(x))),
    );
  }
}

class TransactionData {
  TransactionData({
    required this.transactionId,
    required this.userId,
    required this.gameId,
    required this.amount,
    required this.transactionType,
    required this.transactionNote,
    required this.transferNote,
    required this.paymentStatus,
    required this.lotteryNos,
    required this.insertDate,
    required this.txRequestNumber,
    required this.orderNumber,
    required this.txnId,
    required this.txnRef,
  });

  final String? transactionId;
  final String? userId;
  final String? gameId;
  final String? amount;
  final String? transactionType;
  final String? transactionNote;
  final String? transferNote;
  final String? paymentStatus;
  final String? lotteryNos;
  final DateTime? insertDate;
  final String? txRequestNumber;
  final String? orderNumber;
  final String? txnId;
  final String? txnRef;

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      transactionId: json["transaction_id"],
      userId: json["user_id"],
      gameId: json["game_id"],
      amount: json["amount"],
      transactionType: json["transaction_type"],
      transactionNote: json["transaction_note"],
      transferNote: json["transfer_note"],
      paymentStatus: json["payment_status"],
      lotteryNos: json["lottery_nos"],
      insertDate: DateTime.tryParse(json["insert_date"] ?? ""),
      txRequestNumber: json["tx_request_number"],
      orderNumber: json["order_number"],
      txnId: json["txn_id"],
      txnRef: json["txn_ref"],
    );
  }
}
