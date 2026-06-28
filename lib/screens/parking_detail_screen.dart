import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parking_app/models/parking_spot.dart';
import 'package:parking_app/providers/auth_provider.dart';
import 'package:parking_app/screens/booking_screen.dart';

class ParkingDetailScreen extends StatelessWidget {
  final ParkingSpot parkingSpot;

  const ParkingDetailScreen({
    super.key,
    required this.parkingSpot,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                image: parkingSpot.imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(parkingSpot.imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: parkingSpot.imageUrl.isEmpty
                  ? const Icon(
                      Icons.local_parking,
                      size: 80,
                      color: Colors.grey,
                    )
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          parkingSpot.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            parkingSpot.rating.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          parkingSpot.address,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Pricing',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    context,
                    Icons.directions_car,
                    'Car',
                    '₹${parkingSpot.pricePerHourCar.toStringAsFixed(0)}/hour',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    context,
                    Icons.two_wheeler,
                    'Bike',
                    '₹${parkingSpot.pricePerHourBike.toStringAsFixed(0)}/hour',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Availability',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    context,
                    Icons.directions_car,
                    'Car Spots',
                    '${parkingSpot.availableCarSpots}/${parkingSpot.totalCarSpots} available',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    context,
                    Icons.two_wheeler,
                    'Bike Spots',
                    '${parkingSpot.availableBikeSpots}/${parkingSpot.totalBikeSpots} available',
                  ),
                  const SizedBox(height: 24),
                  if (parkingSpot.amenities.isNotEmpty) ...[
                    Text(
                      'Amenities',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: parkingSpot.amenities.map((amenity) {
                        return Chip(
                          label: Text(amenity),
                          avatar: const Icon(Icons.check_circle, size: 18),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        if (!authProvider.isAuthenticated) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please login first')),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingScreen(
                              parkingSpot: parkingSpot,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Book Now'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
