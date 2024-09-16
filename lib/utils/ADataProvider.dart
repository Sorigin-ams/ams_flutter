// lib/utils/ADataProvider.dart

class WalkthroughData {
  final String image;
  final String? heading;
  final String title;
  final String subtitle;

  WalkthroughData({
    required this.image,
    this.heading,
    required this.title,
    required this.subtitle,
  });
}

List<WalkthroughData> modal = [
  WalkthroughData(
    image: 'assets/image1.png',
    heading: 'Step 1',
    title: 'Welcome to App',
    subtitle: 'This is a walkthrough description.',
  ),
  WalkthroughData(
    image: 'assets/image2.png',
    heading: 'Step 2',
    title: 'Features',
    subtitle: 'Explore the features of the app.',
  ),
  WalkthroughData(
    image: 'assets/image3.png',
    heading: 'Step 3',
    title: 'Get Started',
    subtitle: 'Start using the app now.',
  ),
];
