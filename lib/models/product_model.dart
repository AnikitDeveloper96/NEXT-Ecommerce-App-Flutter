import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));
String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  ProductModel({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      products: json["products"] != null
          ? List<Product>.from(json["products"].map((x) => Product.fromJson(x)))
          : [],
      total: json["total"] ?? 0,
      skip: json["skip"] ?? 0,
      limit: json["limit"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "products": products.map((x) => x.toJson()).toList(),
      "total": total,
      "skip": skip,
      "limit": limit,
    };
  }
}

class Product {
  final int? id;
  final String? title;
  final String? description;
  final String? category;
  final double? price;
  final double? discountPercentage;
  final double? rating;
  final int? stock;
  final List<String>? tags;
  final String? brand;
  final String? sku;
  final int? weight;
  final Dimensions? dimensions;
  final String? warrantyInformation;
  final String? shippingInformation;
  final String? availabilityStatus;
  final List<Review>? reviews;
  final String? returnPolicy;
  final int? minimumOrderQuantity;
  final Meta? meta;
  final List<String>? images;
  final String? thumbnail;
  int quantity = 0;

  Product(
      {this.id,
      this.title,
      this.description,
      this.category,
      this.price,
      this.discountPercentage,
      this.rating,
      this.stock,
      this.tags,
      this.brand,
      this.sku,
      this.weight,
      this.dimensions,
      this.warrantyInformation,
      this.shippingInformation,
      this.availabilityStatus,
      this.reviews,
      this.returnPolicy,
      this.minimumOrderQuantity,
      this.meta,
      this.images,
      this.thumbnail,
      this.quantity = 0});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      category: json["category"],
      price: json["price"]?.toDouble(),
      discountPercentage: json["discountPercentage"]?.toDouble(),
      rating: json["rating"]?.toDouble(),
      stock: json["stock"],
      tags: json["tags"] != null
          ? List<String>.from(json["tags"].map((x) => x))
          : [],
      brand: json["brand"],
      sku: json["sku"],
      weight: json["weight"],
      dimensions: json["dimensions"] != null
          ? Dimensions.fromJson(json["dimensions"])
          : null,
      warrantyInformation: json["warrantyInformation"],
      shippingInformation: json["shippingInformation"],
      availabilityStatus: json["availabilityStatus"],
      reviews: json["reviews"] != null
          ? List<Review>.from(json["reviews"].map((x) => Review.fromJson(x)))
          : [],
      returnPolicy: json["returnPolicy"],
      minimumOrderQuantity: json["minimumOrderQuantity"],
      meta: json["meta"] != null ? Meta.fromJson(json["meta"]) : null,
      images: json["images"] != null
          ? List<String>.from(json["images"].map((x) => x))
          : [],
      thumbnail: json["thumbnail"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "category": category,
      "price": price,
      "discountPercentage": discountPercentage,
      "rating": rating,
      "stock": stock,
      "tags": tags?.map((x) => x).toList(),
      "brand": brand,
      "sku": sku,
      "weight": weight,
      "dimensions": dimensions?.toJson(),
      "warrantyInformation": warrantyInformation,
      "shippingInformation": shippingInformation,
      "availabilityStatus": availabilityStatus,
      "reviews": reviews?.map((x) => x.toJson()).toList(),
      "returnPolicy": returnPolicy,
      "minimumOrderQuantity": minimumOrderQuantity,
      "meta": meta?.toJson(),
      "images": images?.map((x) => x).toList(),
      "thumbnail": thumbnail,
    };
  }
}

class Dimensions {
  final double? width;
  final double? height;
  final double? depth;

  Dimensions({this.width, this.height, this.depth});

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      width: json["width"]?.toDouble(),
      height: json["height"]?.toDouble(),
      depth: json["depth"]?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "width": width,
      "height": height,
      "depth": depth,
    };
  }
}

class Meta {
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? barcode;
  final String? qrCode;

  Meta({this.createdAt, this.updatedAt, this.barcode, this.qrCode});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      createdAt:
          json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
      updatedAt:
          json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
      barcode: json["barcode"],
      qrCode: json["qrCode"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "barcode": barcode,
      "qrCode": qrCode,
    };
  }
}

class Review {
  final int? rating;
  final String? comment;
  final DateTime? date;
  final String? reviewerName;
  final String? reviewerEmail;

  Review({
    this.rating,
    this.comment,
    this.date,
    this.reviewerName,
    this.reviewerEmail,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json["rating"],
      comment: json["comment"],
      date: json["date"] != null ? DateTime.parse(json["date"]) : null,
      reviewerName: json["reviewerName"],
      reviewerEmail: json["reviewerEmail"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "rating": rating,
      "comment": comment,
      "date": date?.toIso8601String(),
      "reviewerName": reviewerName,
      "reviewerEmail": reviewerEmail,
    };
  }
}
