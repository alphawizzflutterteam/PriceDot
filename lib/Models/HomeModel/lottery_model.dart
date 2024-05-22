class LotteryModel {
  String? msg;
  Data? data;
  String? currentDateTime;
  LotteryModel({this.msg, this.data,this.currentDateTime});

  LotteryModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    currentDateTime = json['current_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? name;
  List<Lotteries>? lotteries;

  Data({this.name, this.lotteries});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['lotteries'] != null) {
      lotteries = <Lotteries>[];
      json['lotteries'].forEach((v) {
        lotteries!.add(new Lotteries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.lotteries != null) {
      data['lotteries'] = this.lotteries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lotteries {
  String? gameId;
  String? gameName;
  String? gameNameHindi;
  String? openTime;
  String? openTimeSort;
  String? closeTime;
  String? status;
  String? resultStatus;
  String? marketStatus;
  String? marketOffDay;
  String? date;
  String? endDate;
  String? resultDate;
  String? resultTime;
  String? ticketPrice;
  String? image;
  String? lotteryNumber;
  String? categoryId;
  String? ticketCount;
  String? ticketMaxCount;
  String? prizeName;
  String? startNumber;
  String? gameCategory;
  String? userCount;
  String? lotteryCount;
  String? openingTime;
  String? closingTime;
  String? active;
  String? type;
  String? lotteryNumbers;
  List<WinningPositionHistory>? winningPositionHistory;

  Lotteries(
      {this.gameId,
      this.gameName,
      this.gameNameHindi,
      this.openTime,
      this.openTimeSort,
      this.closeTime,
      this.status,
      this.resultStatus,
      this.marketStatus,
      this.marketOffDay,
      this.date,
      this.endDate,
      this.resultDate,
      this.resultTime,
      this.ticketPrice,
      this.image,
      this.lotteryNumber,
      this.categoryId,
      this.ticketCount,
      this.ticketMaxCount,
      this.prizeName,
      this.startNumber,
      this.gameCategory,
      this.userCount,
      this.lotteryCount,
      this.openingTime,
      this.closingTime,
      this.active,
      this.type,
      this.lotteryNumbers,
      this.winningPositionHistory});

  Lotteries.fromJson(Map<String, dynamic> json) {
    gameId = json['game_id'];
    gameName = json['game_name'];
    gameNameHindi = json['game_name_hindi'];
    openTime = json['open_time'];
    openTimeSort = json['open_time_sort'].toString();
    closeTime = json['close_time'];
    status = json['status'];
    resultStatus = json['result_status'];
    marketStatus = json['market_status'];
    marketOffDay = json['market_off_day'];
    date = json['date'];
    endDate = json['end_date'];
    resultDate = json['result_date'];
    resultTime = json['result_time'];
    ticketPrice = json['ticket_price'];
    image = json['image'];
    lotteryNumber = json['lottery_number'];
    categoryId = json['category_id'];
    ticketCount = json['ticket_count'];
    ticketMaxCount = json['ticket_max_count'];
    prizeName = json['prize_name'];
    startNumber = json['start_number'];
    gameCategory = json['game_category'];
    userCount = json['user_count'];
    lotteryCount = json['lottery_count'];
    openingTime = json['openingTime'];
    closingTime = json['closingTime'];
    active = json['active'];
    type = json['type'];
    lotteryNumbers = json['lottery_numbers'];
    if (json['winning_position_history'] != null) {
      winningPositionHistory = <WinningPositionHistory>[];
      json['winning_position_history'].forEach((v) {
        winningPositionHistory!.add(new WinningPositionHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['game_id'] = this.gameId;
    data['game_name'] = this.gameName;
    data['game_name_hindi'] = this.gameNameHindi;
    data['open_time'] = this.openTime;
    data['open_time_sort'] = this.openTimeSort;
    data['close_time'] = this.closeTime;
    data['status'] = this.status;
    data['result_status'] = this.resultStatus;
    data['market_status'] = this.marketStatus;
    data['market_off_day'] = this.marketOffDay;
    data['date'] = this.date;
    data['end_date'] = this.endDate;
    data['result_date'] = this.resultDate;
    data['result_time'] = this.resultTime;
    data['ticket_price'] = this.ticketPrice;
    data['image'] = this.image;
    data['lottery_number'] = this.lotteryNumber;
    data['category_id'] = this.categoryId;
    data['ticket_count'] = this.ticketCount;
    data['ticket_max_count'] = this.ticketMaxCount;
    data['prize_name'] = this.prizeName;
    data['start_number'] = this.startNumber;
    data['game_category'] = this.gameCategory;
    data['user_count'] = this.userCount;
    data['lottery_count'] = this.lotteryCount;
    data['openingTime'] = this.openingTime;
    data['closingTime'] = this.closingTime;
    data['active'] = this.active;
    data['type'] = this.type;
    data['lottery_numbers'] = this.lotteryNumbers;
    if (this.winningPositionHistory != null) {
      data['winning_position_history'] =
          this.winningPositionHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WinningPositionHistory {
  String? id;
  String? gameId;
  String? winnerPrice;
  String? winningPosition;
  String? startPosition;
  String? endPosition;
  String? lotteryNo;

  WinningPositionHistory(
      {this.id,
      this.gameId,
      this.winnerPrice,
      this.winningPosition,
      this.startPosition,
      this.endPosition,
      this.lotteryNo});

  WinningPositionHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gameId = json['game_id'];
    winnerPrice = json['winner_price'];
    winningPosition = json['winning_position'];
    startPosition = json['start_position'];
    endPosition = json['end_position'];
    lotteryNo = json['lottery_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['game_id'] = this.gameId;
    data['winner_price'] = this.winnerPrice;
    data['winning_position'] = this.winningPosition;
    data['start_position'] = this.startPosition;
    data['end_position'] = this.endPosition;
    data['lottery_no'] = this.lotteryNo;
    return data;
  }
}
