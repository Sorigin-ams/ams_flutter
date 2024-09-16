import 'package:flutter/material.dart';
import 'package:sk_ams/main.dart';
import 'package:sk_ams/models/upi_payment.dart';

import 'package:sk_ams/custom_widget/space.dart';
import '../utils/colors.dart';

class PaymentContainer extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isUpi;

  const PaymentContainer(
      {super.key, required this.title, required this.icon, this.isUpi = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:
              appStore.isDarkModeOn ? paymentCardBorderDark : paymentCardBorder,
          width: 2,
        ),
        color: appStore.isDarkModeOn ? paymentCardDark : paymentCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22),
              const Space(16),
              Text(
                title,
                style: TextStyle(
                  color: appStore.isDarkModeOn ? paymentTextDark : paymentText,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          Visibility(
            visible: isUpi,
            child: const Space(16),
          ),
          Visibility(
            visible: isUpi,
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 8,
              runSpacing: 8,
              runAlignment: WrapAlignment.start,
              alignment: WrapAlignment.start,
              children: List.generate(
                upiPaymentData.length,
                (index) => SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25 - 32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              upiPaymentData[index].paymentUrl.toString(),
                              height: 35,
                              width: 25,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const Space(8),
                      Text(
                        upiPaymentData[index].PaymentName.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
