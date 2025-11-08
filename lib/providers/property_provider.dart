import 'package:flutter/foundation.dart';
import '../models/property.dart';

class PropertyProvider with ChangeNotifier {
  List<Property> _properties = [];
  List<Property> _filteredProperties = [];
  String _searchQuery = '';
  String _selectedPropertyType = 'All';
  String _selectedTransactionType = 'All';
  String _selectedArea = 'All';
  double _minPrice = 0;
  double _maxPrice = double.infinity;
  int _minBedrooms = 0;
  int _maxBedrooms = 10;
  int _minBathrooms = 0;
  int _maxBathrooms = 10;
  double _minSize = 0;
  double _maxSize = double.infinity;
  bool? _isFurnished;

  List<Property> get properties => _filteredProperties.isEmpty && _searchQuery.isEmpty 
      ? _properties 
      : _filteredProperties;
  
  List<Property> get featuredProperties => 
      _properties.where((p) => p.isFeatured).toList();

  PropertyProvider() {
    _loadSampleProperties();
  }

  void _loadSampleProperties() {
    // Sample properties for Lucknow
    _properties = [
      Property(
        id: '1',
        title: '3 BHK Luxury Apartment in Gomti Nagar',
        description: 'Spacious 3 BHK apartment with modern amenities in the heart of Gomti Nagar. Premium location with easy access to malls, schools, and hospitals.',
        price: 8500000,
        propertyType: 'Apartment',
        transactionType: 'Buy',
        location: 'Gomti Nagar, Lucknow',
        area: 'Gomti Nagar',
        size: 1850,
        bedrooms: 3,
        bathrooms: 3,
        images: [
          'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800',
          'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
        ],
        ownerId: '1',
        ownerName: 'Rajesh Kumar',
        ownerPhone: '+91 9876543210',
        amenities: ['Swimming Pool', 'Gym', 'Parking', 'Security', 'Power Backup', 'Lift'],
        isFurnished: true,
        yearBuilt: 2020,
        listedDate: DateTime.now().subtract(const Duration(days: 5)),
        isFeatured: true,
        latitude: 26.8467,
        longitude: 80.9462,
      ),
      Property(
        id: '2',
        title: '2 BHK Flat for Rent in Hazratganj',
        description: 'Well-maintained 2 BHK flat in prime Hazratganj area. Perfect for families and professionals.',
        price: 25000,
        propertyType: 'Apartment',
        transactionType: 'Rent',
        location: 'Hazratganj, Lucknow',
        area: 'Hazratganj',
        size: 1200,
        bedrooms: 2,
        bathrooms: 2,
        images: [
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
        ],
        ownerId: '2',
        ownerName: 'Priya Sharma',
        ownerPhone: '+91 9876543211',
        amenities: ['Parking', 'Security', 'Power Backup'],
        isFurnished: false,
        yearBuilt: 2018,
        listedDate: DateTime.now().subtract(const Duration(days: 2)),
        isFeatured: true,
        latitude: 26.8467,
        longitude: 80.9462,
      ),
      Property(
        id: '3',
        title: 'Independent House in Aliganj',
        description: 'Beautiful 4 BHK independent house with garden and parking. Ideal for large families.',
        price: 12000000,
        propertyType: 'House',
        transactionType: 'Buy',
        location: 'Aliganj, Lucknow',
        area: 'Aliganj',
        size: 2500,
        bedrooms: 4,
        bathrooms: 4,
        images: [
          'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=800',
          'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800',
        ],
        ownerId: '3',
        ownerName: 'Amit Singh',
        ownerPhone: '+91 9876543212',
        amenities: ['Garden', 'Parking', 'Security', 'Power Backup'],
        isFurnished: true,
        yearBuilt: 2019,
        listedDate: DateTime.now().subtract(const Duration(days: 10)),
        isFeatured: false,
        latitude: 26.8467,
        longitude: 80.9462,
      ),
      Property(
        id: '4',
        title: 'Commercial Space in Aminabad',
        description: 'Prime commercial property in busy Aminabad market. Great for retail business.',
        price: 150000,
        propertyType: 'Commercial',
        transactionType: 'Rent',
        location: 'Aminabad, Lucknow',
        area: 'Aminabad',
        size: 800,
        bedrooms: 0,
        bathrooms: 2,
        images: [
          'https://images.unsplash.com/photo-1497366216548-37526070297c?w=800',
          'https://images.unsplash.com/photo-1497366811353-6870744d04b2?w=800',
        ],
        ownerId: '4',
        ownerName: 'Mohit Verma',
        ownerPhone: '+91 9876543213',
        amenities: ['Parking', 'Security', 'Power Backup', 'Lift'],
        isFurnished: false,
        yearBuilt: 2015,
        listedDate: DateTime.now().subtract(const Duration(days: 7)),
        isFeatured: true,
        latitude: 26.8467,
        longitude: 80.9462,
      ),
      Property(
        id: '5',
        title: 'Plot for Sale in Indira Nagar',
        description: 'Residential plot in well-developed Indira Nagar colony. Ready for construction.',
        price: 5500000,
        propertyType: 'Plot',
        transactionType: 'Buy',
        location: 'Indira Nagar, Lucknow',
        area: 'Indira Nagar',
        size: 1500,
        bedrooms: 0,
        bathrooms: 0,
        images: [
          'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800',
        ],
        ownerId: '5',
        ownerName: 'Sunita Mishra',
        ownerPhone: '+91 9876543214',
        amenities: ['Road Access', 'Electricity', 'Water Supply'],
        isFurnished: false,
        yearBuilt: 2024,
        listedDate: DateTime.now().subtract(const Duration(days: 1)),
        isFeatured: false,
        latitude: 26.8467,
        longitude: 80.9462,
      ),
      Property(
        id: '6',
        title: 'Luxury Villa in Jankipuram',
        description: 'Premium 5 BHK villa with all modern amenities. Private pool and garden.',
        price: 25000000,
        propertyType: 'House',
        transactionType: 'Buy',
        location: 'Jankipuram, Lucknow',
        area: 'Jankipuram',
        size: 4000,
        bedrooms: 5,
        bathrooms: 5,
        images: [
          'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
          'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800',
        ],
        ownerId: '6',
        ownerName: 'Vikram Kapoor',
        ownerPhone: '+91 9876543215',
        amenities: ['Swimming Pool', 'Garden', 'Gym', 'Parking', 'Security', 'Power Backup'],
        isFurnished: true,
        yearBuilt: 2022,
        listedDate: DateTime.now().subtract(const Duration(days: 15)),
        isFeatured: true,
        latitude: 26.8467,
        longitude: 80.9462,
      ),
    ];
    _filteredProperties = List.from(_properties);
    notifyListeners();
  }

  void searchProperties(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterByPropertyType(String type) {
    _selectedPropertyType = type;
    _applyFilters();
  }

  void filterByTransactionType(String type) {
    _selectedTransactionType = type;
    _applyFilters();
  }

  void filterByArea(String area) {
    _selectedArea = area;
    _applyFilters();
  }

  void filterByPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
  }

  void filterByBedrooms(int min, int max) {
    _minBedrooms = min;
    _maxBedrooms = max;
    _applyFilters();
  }

  void filterByBathrooms(int min, int max) {
    _minBathrooms = min;
    _maxBathrooms = max;
    _applyFilters();
  }

  void filterBySize(double min, double max) {
    _minSize = min;
    _maxSize = max;
    _applyFilters();
  }

  void filterByFurnished(bool? isFurnished) {
    _isFurnished = isFurnished;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProperties = _properties.where((property) {
      bool matchesSearch = _searchQuery.isEmpty ||
          property.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          property.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          property.location.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesPropertyType = _selectedPropertyType == 'All' ||
          property.propertyType == _selectedPropertyType;

      bool matchesTransactionType = _selectedTransactionType == 'All' ||
          property.transactionType == _selectedTransactionType;

      bool matchesArea = _selectedArea == 'All' ||
          property.area == _selectedArea;

      bool matchesPrice = property.price >= _minPrice && 
          property.price <= _maxPrice;

      bool matchesBedrooms = property.bedrooms >= _minBedrooms &&
          property.bedrooms <= _maxBedrooms;

      bool matchesBathrooms = property.bathrooms >= _minBathrooms &&
          property.bathrooms <= _maxBathrooms;

      bool matchesSize = property.size >= _minSize &&
          property.size <= _maxSize;

      bool matchesFurnished = _isFurnished == null ||
          property.isFurnished == _isFurnished;

      return matchesSearch && 
             matchesPropertyType && 
             matchesTransactionType && 
             matchesArea && 
             matchesPrice &&
             matchesBedrooms &&
             matchesBathrooms &&
             matchesSize &&
             matchesFurnished;
    }).toList();

    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedPropertyType = 'All';
    _selectedTransactionType = 'All';
    _selectedArea = 'All';
    _minPrice = 0;
    _maxPrice = double.infinity;
    _minBedrooms = 0;
    _maxBedrooms = 10;
    _minBathrooms = 0;
    _maxBathrooms = 10;
    _minSize = 0;
    _maxSize = double.infinity;
    _isFurnished = null;
    _filteredProperties = List.from(_properties);
    notifyListeners();
  }

  // Getters for current filter values
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  int get minBedrooms => _minBedrooms;
  int get maxBedrooms => _maxBedrooms;
  int get minBathrooms => _minBathrooms;
  int get maxBathrooms => _maxBathrooms;
  double get minSize => _minSize;
  double get maxSize => _maxSize;
  bool? get isFurnished => _isFurnished;

  Property? getPropertyById(String id) {
    try {
      return _properties.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void addProperty(Property property) {
    _properties.insert(0, property);
    _applyFilters();
  }
}

