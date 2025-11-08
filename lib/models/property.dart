class Property {
  final String id;
  final String title;
  final String description;
  final double price;
  final String propertyType; // Apartment, House, Villa, Room, PG, Commercial, Shop, Warehouse, Plot, Farmhouse, Studio, Penthouse, Office Space
  final String transactionType; // Buy, Rent, Lease, Room Rent, PG, Co-living, Short-term Rent, Lease-to-Own
  final String location;
  final String area; // Lucknow specific areas
  final double size; // in sq ft
  final int bedrooms;
  final int bathrooms;
  final List<String> images;
  final String ownerId;
  final String ownerName;
  final String ownerPhone;
  final List<String> amenities;
  final bool isFurnished;
  final int yearBuilt;
  final DateTime listedDate;
  final bool isFeatured;
  final double? latitude;
  final double? longitude;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.propertyType,
    required this.transactionType,
    required this.location,
    required this.area,
    required this.size,
    required this.bedrooms,
    required this.bathrooms,
    required this.images,
    required this.ownerId,
    required this.ownerName,
    required this.ownerPhone,
    required this.amenities,
    required this.isFurnished,
    required this.yearBuilt,
    required this.listedDate,
    this.isFeatured = false,
    this.latitude,
    this.longitude,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      propertyType: json['propertyType'] ?? '',
      transactionType: json['transactionType'] ?? '',
      location: json['location'] ?? '',
      area: json['area'] ?? '',
      size: (json['size'] ?? 0).toDouble(),
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
      ownerId: json['ownerId'] ?? '',
      ownerName: json['ownerName'] ?? '',
      ownerPhone: json['ownerPhone'] ?? '',
      amenities: List<String>.from(json['amenities'] ?? []),
      isFurnished: json['isFurnished'] ?? false,
      yearBuilt: json['yearBuilt'] ?? 0,
      listedDate: DateTime.parse(json['listedDate'] ?? DateTime.now().toIso8601String()),
      isFeatured: json['isFeatured'] ?? false,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'propertyType': propertyType,
      'transactionType': transactionType,
      'location': location,
      'area': area,
      'size': size,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'images': images,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'amenities': amenities,
      'isFurnished': isFurnished,
      'yearBuilt': yearBuilt,
      'listedDate': listedDate.toIso8601String(),
      'isFeatured': isFeatured,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

