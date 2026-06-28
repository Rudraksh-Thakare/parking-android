import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parking_app/models/booking.dart';
import 'package:parking_app/models/vehicle_type.dart';
import 'package:parking_app/models/payment_method.dart';
import 'package:intl/intl.dart';

class BookingReceiptScreen extends StatelessWidget {
  final Booking booking;

  const BookingReceiptScreen({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Receipt'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareReceipt(context),
            tooltip: 'Share Receipt',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Receipt Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Success Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Booking Confirmed!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      booking.bookingNumber,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Booking ID: ${booking.id.substring(0, 8).toUpperCase()}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Details Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(context, 'Parking Details'),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      context,
                      Icons.local_parking,
                      'Location',
                      booking.parkingSpot.name,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      context,
                      Icons.location_on,
                      'Address',
                      booking.parkingSpot.address,
                      isAddress: true,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      context,
                      booking.vehicleType == VehicleType.car
                          ? Icons.directions_car
                          : Icons.two_wheeler,
                      'Vehicle Type',
                      booking.vehicleType.displayName,
                    ),
                    if (booking.vehicleNumber != null) ...[
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        context,
                        Icons.confirmation_number,
                        'Vehicle Number',
                        booking.vehicleNumber!,
                      ),
                    ],
                    const Divider(height: 32),
                    _buildSectionTitle(context, 'Time Details'),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      context,
                      Icons.access_time,
                      'Start Time',
                      DateFormat('MMM dd, yyyy • HH:mm').format(booking.startTime),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      context,
                      Icons.schedule,
                      'End Time',
                      DateFormat('MMM dd, yyyy • HH:mm').format(booking.endTime),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      context,
                      Icons.timer,
                      'Duration',
                      '${booking.endTime.difference(booking.startTime).inHours} hours',
                    ),
                    if (booking.eventName != null) ...[
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        context,
                        Icons.event,
                        'Event/Purpose',
                        booking.eventName!,
                      ),
                    ],
                    const Divider(height: 32),
                    _buildSectionTitle(context, 'Payment Details'),
                    const SizedBox(height: 16),
                    if (booking.paymentMethod != null)
                      _buildDetailRow(
                        context,
                        Icons.payment,
                        'Payment Method',
                        '${booking.paymentMethod!.icon} ${booking.paymentMethod!.displayName}',
                      ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      context,
                      Icons.attach_money,
                      'Total Amount',
                      '₹${booking.totalPrice.toStringAsFixed(0)}',
                      isAmount: true,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      context,
                      Icons.calendar_today,
                      'Booking Date',
                      DateFormat('MMM dd, yyyy • HH:mm').format(booking.createdAt),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Booking Number Card - Highlighted for Staff
            Card(
              elevation: 3,
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code,
                          size: 32,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Show this to Mall Staff',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Booking Number',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          const SizedBox(height: 8),
                          SelectableText(
                            booking.bookingNumber,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                  letterSpacing: 2,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _copyBookingNumber(context),
                        icon: const Icon(Icons.copy),
                        label: const Text('Copy Booking Number'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Action Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: const Icon(Icons.home),
                label: const Text('Go to Home'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    bool isAddress = false,
    bool isAmount = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: isAmount ? FontWeight.bold : FontWeight.normal,
                      fontSize: isAmount ? 18 : null,
                      color: isAmount
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                maxLines: isAddress ? 3 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _copyBookingNumber(BuildContext context) {
    Clipboard.setData(ClipboardData(text: booking.bookingNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('Booking number copied: ${booking.bookingNumber}'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareReceipt(BuildContext context) {
    final receiptText = '''
📋 PARKING BOOKING RECEIPT

Booking Number: ${booking.bookingNumber}
Booking ID: ${booking.id.substring(0, 8).toUpperCase()}

📍 PARKING DETAILS
Location: ${booking.parkingSpot.name}
Address: ${booking.parkingSpot.address}
Vehicle Type: ${booking.vehicleType.displayName}
${booking.vehicleNumber != null ? 'Vehicle Number: ${booking.vehicleNumber}\n' : ''}

⏰ TIME DETAILS
Start: ${DateFormat('MMM dd, yyyy • HH:mm').format(booking.startTime)}
End: ${DateFormat('MMM dd, yyyy • HH:mm').format(booking.endTime)}
Duration: ${booking.endTime.difference(booking.startTime).inHours} hours
${booking.eventName != null ? 'Event: ${booking.eventName}\n' : ''}

💳 PAYMENT DETAILS
${booking.paymentMethod != null ? 'Payment Method: ${booking.paymentMethod!.displayName}\n' : ''}Total Amount: ₹${booking.totalPrice.toStringAsFixed(0)}
Booking Date: ${DateFormat('MMM dd, yyyy • HH:mm').format(booking.createdAt)}

Show this booking number to mall staff for easy identification.
''';
    
    Clipboard.setData(ClipboardData(text: receiptText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Receipt copied to clipboard'),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}

