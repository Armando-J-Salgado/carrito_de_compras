///Product representation class
///
///params: [name], [description], [price], [image]
class Product {

  final String name;
  final String description;
  final double price;
  ///Find them in lib/images
  final String image;

  Product(this.name, this.description, this.price, this.image);
}