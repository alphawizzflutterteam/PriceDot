class MyLotteryModel {
  MyLotteryModel({
    required this.msg,
    required this.data,
    required this.status,
  });

  final String? msg;
  final Data? data;
  final bool? status;

  factory MyLotteryModel.fromJson(Map<String, dynamic> json) {
    return MyLotteryModel(
      msg: json["msg"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
      status: json["status"],
    );
  }
}

class Data {
  Data({
    required this.name,
    required this.lotteries,
  });

  final String? name;
  final List<Lottery> lotteries;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      name: json["name"],
      lotteries: json["lotteries"] == null
          ? []
          : List<Lottery>.from(
              json["lotteries"]!.map((x) => Lottery.fromJson(x))),
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
    required this.userCount,
    required this.lotteryCount,
    required this.openingTime,
    required this.closingTime,
    required this.active,
    required this.type,
    required this.lotteryNumbers,
    required this.winningPositionHistory,
    required this.winners,
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
  final String? userCount;
  final String? lotteryCount;
  final DateTime? openingTime;
  final DateTime? closingTime;
  final String? active;
  final int? type;
  final String? lotteryNumbers;
  final List<WinningPositionHistory> winningPositionHistory;
  final List<Winner> winners;

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
      userCount: json["user_count"],
      lotteryCount: json["lottery_count"],
      openingTime: DateTime.tryParse(json["openingTime"] ?? ""),
      closingTime: DateTime.tryParse(json["closingTime"] ?? ""),
      active: json["active"],
      type: json["type"],
      lotteryNumbers: json["lottery_numbers"],
      winningPositionHistory: json["winning_position_history"] == null
          ? []
          : List<WinningPositionHistory>.from(json["winning_position_history"]!
              .map((x) => WinningPositionHistory.fromJson(x))),
      winners: json["winners"] == null
          ? []
          : List<Winner>.from(json["winners"]!.map((x) => Winner.fromJson(x))),
    );
  }
}

class Winner {
  Winner({
    required this.userId,
    required this.userName,
    required this.mobile,
    required this.lotteryNumber,
    required this.winnerPrice,
    required this.winPosition,
  });

  final String? userId;
  final String? userName;
  final String? mobile;
  final String? lotteryNumber;
  final String? winnerPrice;
  final String? winPosition;

  factory Winner.fromJson(Map<String, dynamic> json) {
    return Winner(
      userId: json["user_id"],
      userName: json["user_name"],
      mobile: json["mobile"],
      lotteryNumber: json["lottery_number"],
      winnerPrice: json['winner_price'],
      winPosition: json['win_position'],
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
