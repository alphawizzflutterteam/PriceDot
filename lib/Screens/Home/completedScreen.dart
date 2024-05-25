import 'package:pricedot/Utils/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pricedot/Widgets/designConfig.dart';

import '../../Models/HomeModel/lottery_model.dart';

class CompletedScreen extends StatelessWidget {
  final Lotteries lot;

  const CompletedScreen({super.key, required this.lot});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          //toolbarHeight: 60,
          flexibleSpace: FlexibleSpace,
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/CupIcon.png",
                scale: 2,
              ),
              const SizedBox(
                width: 7,
              ),
              const Text(
                "Winners",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 7,
              ),
              Image.asset(
                "assets/images/CupIcon.png",
                scale: 2,
              ),
            ],
          ),
          // const Text(
          //   "Winner",
          //   style: TextStyle(
          //       color: AppColors.whit, fontSize: 22,),
          // ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 30,
              )),
          actions: [],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * .12,
              decoration: BoxDecoration(
                  color: AppColors.secondary1.withOpacity(.8),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .3,
                    child: Text(
                      lot.gameName.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Entry Fees",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "₹${lot.ticketPrice.toString()}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: AppColors.bgColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .3,
                    child: Text(
                      "Rank",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .3,
                    child: Text(
                      "Coupon No.",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .3,
                    child: Text(
                      "Winnings",
                      textAlign: TextAlign.end,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: lot.winningPositionHistory!.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    color: i % 2 != 0 ? AppColors.bgColor : Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Text(
                            "${lot.winningPositionHistory![i].lotteryNo}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Text(
                            "${lot.winningPositionHistory![i].winningPosition}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Spacer(),
                        if (int.parse(lot.winningPositionHistory![i].lotteryNo
                                .toString()) <=
                            3)
                          Image.asset(
                            "assets/images/winner1.png",
                            scale: 1.2,
                          ),
                        SizedBox(width: 5),
                        Text(
                          '₹ ${lot.winningPositionHistory![i].winnerPrice}',
                          style: const TextStyle(
                            color: AppColors.fntClr,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
