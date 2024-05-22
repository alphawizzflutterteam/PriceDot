import 'package:pricedot/Services/api_services/apiStrings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/HomeModel/get_faq_model.dart';
import '../../Services/api_services/apiConstants.dart';
import '../../Utils/Colors.dart';
import '../../Widgets/auth_custom_design.dart';
import '../../Widgets/designConfig.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    getFaq();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleSpace,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
        title: Text("FAQs".tr,
            style: TextStyle(color: Colors.white, fontSize: 20)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Color(0xfff6f6f6),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            // Top-left corner radius
            topRight: Radius.circular(30),
            // Top-right corner radius
          ),
        ),
        child: faqModel == null
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary))
            : faqModel?.faqs?.length == 0
                ? const Text("No Faqs list")
                : Container(
                    height: MediaQuery.of(context).size.height / 1,
                    child: ListView.builder(
                      key: Key('builder ${selected.toString()}'),
                      itemCount: faqModel?.faqs?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 15, right: 15),
                          child: Theme(
                            data: ThemeData()
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              collapsedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              backgroundColor: AppColors.whit,
                              textColor: AppColors.fntClr,
                              iconColor: AppColors.fntClr,
                              collapsedTextColor: AppColors.bgColor,
                              collapsedBackgroundColor: AppColors.whit,
                              key: Key(index.toString()),
                              // initiallyExpanded: index == selected,
                              title: Text(
                                '${faqModel?.faqs?[index].question}',
                                style: TextStyle(color: AppColors.primary),
                              ),
                              onExpansionChanged: (isExpanded) {
                                if (isExpanded) {
                                  setState(() {
                                    const Duration(milliseconds: 2000);
                                    selected = index;
                                  });
                                } else {
                                  setState(() {
                                    selected = -1;
                                  });
                                }
                              },
                              expandedAlignment: Alignment.topLeft,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${faqModel?.faqs?[index].answer}",
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 10,
                                    style: const TextStyle(
                                        color: AppColors.fntClr),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }

  int? selected = 0;
  FaqModel? faqModel;
  Future<void> getFaq() async {
    apiBaseHelper.postAPICall2(getFagsAPI).then((getData) {
      setState(() {
        faqModel = FaqModel.fromJson(getData);
      });

      //isLoading.value = false;
    });
  }
}
