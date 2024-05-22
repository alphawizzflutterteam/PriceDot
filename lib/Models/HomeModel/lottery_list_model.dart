class LotteryListModel {
  LotteryListModel({
    required this.msg,
    required this.data,
  });

  final String? msg;
  final Data? data;

  factory LotteryListModel.fromJson(Map<String, dynamic> json) {
    return LotteryListModel(
      msg: json["msg"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }
}

class Data {
  Data({
    required this.name,
    required this.lottery,
  });

  final String? name;
  final Lottery? lottery;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      name: json["name"],
      lottery:
          json["lottery"] == null ? null : Lottery.fromJson(json["lottery"]),
    );
  }
}

class Lottery {
  Lottery({
    required this.gameId,
    required this.gameName,
    required this.gameNameHindi,
    required this.openTime,
    required this.openTimeSort,
    required this.closeTime,
    required this.status,
    required this.resultStatus,
    required this.marketStatus,
    required this.marketOffDay,
    required this.date,
    required this.endDate,
    required this.resultDate,
    required this.resultTime,
    required this.ticketPrice,
    required this.image,
    required this.lotteryNumber,
    required this.categoryId,
    required this.ticketCount,
    required this.ticketMaxCount,
    required this.prizeName,
    required this.startNumber,
    required this.gameCategory,
    required this.active,
    required this.timer,
    required this.walletBalance,
    required this.lotteryNumbers,
    required this.purchaseNumbers,
    required this.winningPositionHistory,
    required this.isActive,
  });

  final String? gameId;
  final String? gameName;
  final String? gameNameHindi;
  final String? openTime;
  final String? openTimeSort;
  final String? closeTime;
  final String? status;
  final String? resultStatus;
  final String? marketStatus;
  final String? marketOffDay;
  final String? date;
  final String? endDate;
  final String? resultDate;
  final String? resultTime;
  final String? ticketPrice;
  final String? image;
  final String? lotteryNumber;
  final String? categoryId;
  final String? ticketCount;
  final String? ticketMaxCount;
  final String? prizeName;
  final String? startNumber;
  final String? gameCategory;
  final String? active;
  final String? timer;
  final String? walletBalance;
  final List<String> lotteryNumbers;
  final List<String> purchaseNumbers;
  final List<WinningPositionHistory> winningPositionHistory;
  final bool? isActive;

  factory Lottery.fromJson(Map<String, dynamic> json) {
    return Lottery(
      gameId: json["game_id"],
      gameName: json["game_name"],
      gameNameHindi: json["game_name_hindi"],
      openTime: json["open_time"],
      openTimeSort: json["open_time_sort"],
      closeTime: json["close_time"],
      status: json["status"],
      resultStatus: json["result_status"],
      marketStatus: json["market_status"],
      marketOffDay: json["market_off_day"],
      date: json["date"],
      endDate: json["end_date"],
      resultDate: json["result_date"],
      resultTime: json["result_time"],
      ticketPrice: json["ticket_price"],
      image: json["image"],
      lotteryNumber: json["lottery_number"],
      categoryId: json["category_id"],
      ticketCount: json["ticket_count"],
      ticketMaxCount: json["ticket_max_count"],
      prizeName: json["prize_name"],
      startNumber: json["start_number"],
      gameCategory: json["game_category"],
      active: json["active"],
      timer: json["timer"],
      walletBalance: json["wallet_balance"],
      lotteryNumbers: json["lottery_numbers"] == null
          ? []
          : List<String>.from(json["lottery_numbers"]!.map((x) => x)),
      winningPositionHistory: json["winning_position_history"] == null
          ? []
          : List<WinningPositionHistory>.from(json["winning_position_history"]!
              .map((x) => WinningPositionHistory.fromJson(x))),
      purchaseNumbers: json["purchased_lottery"] == null
          ? []
          : List<String>.from(json["purchased_lottery"]!.map((x) => x)),
      isActive: json["is_active"],
    );
  }
}

class WinningPositionHistory {
  WinningPositionHistory({
    required this.id,
    required this.gameId,
    required this.winnerPrice,
    required this.winningPosition,
    required this.startPosition,
    required this.endPosition,
    required this.lotteryNo,
  });

  final String? id;
  final String? gameId;
  final String? winnerPrice;
  final String? winningPosition;
  final String? startPosition;
  final String? endPosition;
  final String? lotteryNo;

  factory WinningPositionHistory.fromJson(Map<String, dynamic> json) {
    return WinningPositionHistory(
      id: json["id"],
      gameId: json["game_id"],
      winnerPrice: json["winner_price"],
      winningPosition: json["winning_position"],
      startPosition: json["start_position"],
      endPosition: json["end_position"],
      lotteryNo: json["lottery_no"],
    );
  }
}
