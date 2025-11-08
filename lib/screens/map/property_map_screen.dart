import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/property_provider.dart';
import '../../models/property.dart';
import '../../utils/app_colors.dart';
import '../property/property_detail_screen.dart';

class PropertyMapScreen extends StatefulWidget {
  const PropertyMapScreen({super.key});

  @override
  State<PropertyMapScreen> createState() => _PropertyMapScreenState();
}

class _PropertyMapScreenState extends State<PropertyMapScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  Property? _selectedProperty;

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() {
    final propertyProvider = Provider.of<PropertyProvider>(context, listen: false);
    final properties = propertyProvider.properties
        .where((p) => p.latitude != null && p.longitude != null)
        .toList();

    setState(() {
      _markers.clear();
      for (var property in properties) {
        _markers.add(
          Marker(
            markerId: MarkerId(property.id),
            position: LatLng(property.latitude!, property.longitude!),
            infoWindow: InfoWindow(
              title: property.title,
              snippet: '${_formatPrice(property.price)} - ${property.propertyType}',
              onTap: () {
                _selectedProperty = property;
              },
            ),
            onTap: () {
              setState(() {
                _selectedProperty = property;
              });
              _showPropertyBottomSheet(property);
            },
          ),
        );
      }
    });
  }

  String _formatPrice(double price) {
    if (price >= 10000000) {
      return '₹${(price / 10000000).toStringAsFixed(2)} Cr';
    } else if (price >= 100000) {
      return '₹${(price / 100000).toStringAsFixed(2)} Lac';
    } else {
      return '₹${price.toStringAsFixed(0)}';
    }
  }

  void _showPropertyBottomSheet(Property property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              property.title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_formatPrice(property.price)} • ${property.propertyType}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PropertyDetailScreen(property: property),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('View Details'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    final properties = propertyProvider.properties
        .where((p) => p.latitude != null && p.longitude != null)
        .toList();

    if (properties.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Property Map',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
        ),
        body: Center(
          child: Text(
            'No properties with location data available',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    // Calculate center of all properties
    double avgLat = properties.map((p) => p.latitude!).reduce((a, b) => a + b) / properties.length;
    double avgLng = properties.map((p) => p.longitude!).reduce((a, b) => a + b) / properties.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Property Map',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(avgLat, avgLng),
              zoom: 12,
            ),
            markers: _markers,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
          ),
          if (_selectedProperty != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedProperty!.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatPrice(_selectedProperty!.price)} • ${_selectedProperty!.propertyType}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PropertyDetailScreen(property: _selectedProperty!),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('View Details'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

