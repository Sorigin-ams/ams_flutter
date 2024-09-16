// Ensure this path is correct for your project

// Sample list of customer reviews with placeholder image paths
List<CustomerReviewModel> customerReviews = getCustomerReviews();

class CustomerReviewModel {
  int id;
  String customerName;
  String detailReview;
  String customerImage;
  String taskDetails; // Add this property

  CustomerReviewModel(
    this.id,
    this.customerName,
    this.detailReview,
    this.customerImage,
    this.taskDetails, // Include in constructor
  );
}

List<CustomerReviewModel> getCustomerReviews() {
  List<CustomerReviewModel> list = <CustomerReviewModel>[];

  list.add(
    CustomerReviewModel(
      1,
      "John Doe",
      "Great service! Highly recommended.",
      'assets/images/customer1.png', // Replace with actual image path
      "Task: Fixing the leaky faucet", // Sample task detail
    ),
  );
  list.add(
    CustomerReviewModel(
      2,
      "Jane Smith",
      "Very satisfied with the work.",
      'assets/images/customer2.png', // Replace with actual image path
      "Task: Cleaning the air conditioner", // Sample task detail
    ),
  );
  list.add(
    CustomerReviewModel(
      3,
      "Emily Johnson",
      "The service was top-notch.",
      'assets/images/customer3.png', // Replace with actual image path
      "Task: Installing new lighting fixtures", // Sample task detail
    ),
  );

  return list;
}
