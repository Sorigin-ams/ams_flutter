import 'package:flutter/material.dart';
import 'package:sk_ams/custom_widget/space.dart';
import 'package:sk_ams/models/customer_review_model.dart'; // Ensure this import is correct

class CustomerReviewComponent extends StatelessWidget {
  final CustomerReviewModel? customerReviewModel;

  const CustomerReviewComponent({super.key, this.customerReviewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    maxRadius: 20,
                    backgroundImage:
                        AssetImage(customerReviewModel!.customerImage),
                  ),
                  const Space(8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(customerReviewModel!.customerName,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const Space(4),
                        // Remove rating related widgets
                      ],
                    ),
                  ),
                ],
              ),
              const Space(8),
              Flexible(
                child: Text(
                  customerReviewModel!.detailReview,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const Space(8),
              Flexible(
                child: Text(
                  customerReviewModel!.taskDetails,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
