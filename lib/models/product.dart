///Product representation class
///
///params: [name], [description], [price], [imagePath]
class Product {
  final String name;
  final String description;
  final double price;
  ///Find them in lib/images
  final String imagePath;

  const Product({
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
  });
}
