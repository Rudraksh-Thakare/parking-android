import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parking_app/providers/parking_provider.dart';
import 'package:parking_app/providers/auth_provider.dart';
import 'package:parking_app/models/booking.dart';
import 'package:parking_app/models/vehicle_type.dart';
import 'package:parking_app/models/payment_method.dart';
import 'package:parking_app/screens/booking_receipt_screen.dart';
import 'package:intl/intl.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  late Future<List<Booking>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    final parkingProvider = Provider.of<ParkingProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    debugPrint("📡 Fetching bookings for user: ${authProvider.userId}");
    _bookingsFuture = parkingProvider.getUserBookings(authProvider.userId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final parkingProvider = Provider.of<ParkingProvider>(context);

    return FutureBuilder<List<Booking>>(
      future: _bookingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('My Bookings')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final bookings = snapshot.data ?? [];

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Bookings'),
          ),
          body: bookings.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bookmark_border,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No bookings yet',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Book a parking spot to see it here',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[500],
                            ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return _BookingCard(booking: booking);
                  },
                ),
        );
      },
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;

  const _BookingCard({required this.booking});

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.active:
        return Colors.blue;
      case BookingStatus.completed:
        return Colors.grey;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.pending:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final parkingProvider = Provider.of<ParkingProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.parkingSpot.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          booking.bookingNumber,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    booking.statusText,
                    style: TextStyle(
                      color: _getStatusColor(booking.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              booking.parkingSpot.address,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        booking.vehicleType.icon,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        booking.vehicleType.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                if (booking.vehicleNumber != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    booking.vehicleNumber!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ],
            ),
            if (booking.eventName != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.event, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    booking.eventName!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ),
            ],
            if (booking.paymentMethod != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    booking.paymentMethod!.icon,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    booking.paymentMethod!.displayName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${DateFormat('MMM dd, HH:mm').format(booking.startTime)} - ${DateFormat('HH:mm').format(booking.endTime)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${booking.totalPrice.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.receipt),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingReceiptScreen(
                              booking: booking,
                            ),
                          ),
                        );
                      },
                      tooltip: 'View Receipt',
                    ),
                    if (booking.status == BookingStatus.confirmed ||
                        booking.status == BookingStatus.pending)
                      TextButton(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Cancel Booking'),
                              content: const Text('Are you sure you want to cancel this booking?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await parkingProvider.cancelBooking(booking.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Booking cancelled')),
                              );
                            }
                          }
                        },
                        child: const Text('Cancel'),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
