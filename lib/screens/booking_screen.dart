import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parking_app/models/parking_spot.dart';
import 'package:parking_app/models/vehicle_type.dart';
import 'package:parking_app/models/payment_method.dart';
import 'package:parking_app/providers/parking_provider.dart';
import 'package:parking_app/providers/auth_provider.dart';
import 'package:parking_app/screens/payment_method_screen.dart';
import 'package:parking_app/screens/booking_receipt_screen.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final ParkingSpot parkingSpot;

  const BookingScreen({
    super.key,
    required this.parkingSpot,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _startTime;
  DateTime? _endTime;
  int _hours = 1;
  bool _isLoading = false;
  VehicleType _vehicleType = VehicleType.car;
  PaymentMethod? _paymentMethod;
  final _vehicleNumberController = TextEditingController();
  final _eventNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now().add(const Duration(minutes: 30));
    _endTime = _startTime!.add(const Duration(hours: 1));
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _eventNameController.dispose();
    super.dispose();
  }

  Future<void> _selectStartTime() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_startTime ?? DateTime.now()),
      );
      if (time != null) {
        setState(() {
          _startTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
          if (_endTime != null && _endTime!.isBefore(_startTime!)) {
            _endTime = _startTime!.add(Duration(hours: _hours));
          }
        });
      }
    }
  }

  Future<void> _selectEndTime() async {
    if (_startTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start time first')),
      );
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: _endTime ?? _startTime!,
      firstDate: _startTime!,
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_endTime ?? _startTime!),
      );
      if (time != null) {
        final selected = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        );
        if (selected.isBefore(_startTime!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('End time must be after start time')),
          );
          return;
        }
        setState(() {
          _endTime = selected;
          _hours = selected.difference(_startTime!).inHours;
          if (_hours < 1) _hours = 1;
        });
      }
    }
  }

  void _updateHours(int hours) {
    if (_startTime != null) {
      setState(() {
        _hours = hours;
        _endTime = _startTime!.add(Duration(hours: hours));
      });
    }
  }

  Future<void> _confirmBooking() async {
    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start and end times')),
      );
      return;
    }

    // Check payment method
    if (_paymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Check availability
    if (_vehicleType == VehicleType.car && widget.parkingSpot.availableCarSpots == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No car parking spots available')),
      );
      return;
    }
    if (_vehicleType == VehicleType.bike && widget.parkingSpot.availableBikeSpots == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No bike parking spots available')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final parkingProvider = Provider.of<ParkingProvider>(context, listen: false);

    try {
      await parkingProvider.createBooking(
        userId: authProvider.userId!,
        spot: widget.parkingSpot,
        vehicleType: _vehicleType,
        vehicleNumber: _vehicleNumberController.text.trim().isEmpty 
            ? null 
            : _vehicleNumberController.text.trim(),
        startTime: _startTime!,
        endTime: _endTime!,
        eventName: _eventNameController.text.trim().isEmpty 
            ? null 
            : _eventNameController.text.trim(),
        paymentMethod: _paymentMethod,
      );

      if (mounted) {
        // Get the created booking to show receipt
        final userBookings = parkingProvider.bookings
            .where((b) => b.userId == authProvider.userId)
            .toList();
        userBookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        
        if (userBookings.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking created but receipt unavailable')),
          );
          Navigator.pop(context);
          Navigator.pop(context);
          return;
        }
        
        final latestBooking = userBookings.first;
        
        // Pop booking screen and detail screen
        Navigator.pop(context);
        Navigator.pop(context);
        
        // Show receipt screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingReceiptScreen(
              booking: latestBooking,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  double get _totalPrice {
    final pricePerHour = _vehicleType == VehicleType.car 
        ? widget.parkingSpot.pricePerHourCar 
        : widget.parkingSpot.pricePerHourBike;
    return pricePerHour * _hours;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Parking'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.parkingSpot.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.parkingSpot.address,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Vehicle Type',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
  children: [
    Flexible(
      flex: 1,
      child: ChoiceChip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        labelPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            children: [
              const Text('🚗'),
              const SizedBox(width: 4),
              const Text('Car'),
              const SizedBox(width: 4),
              Text(
                '(${widget.parkingSpot.availableCarSpots} available)',
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
        selected: _vehicleType == VehicleType.car,
        onSelected: (selected) {
          if (selected) setState(() => _vehicleType = VehicleType.car);
        },
      ),
    ),
    const SizedBox(width: 8),
    Flexible(
      flex: 1,
      child: ChoiceChip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        labelPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            children: [
              const Text('🏍️'),
              const SizedBox(width: 4),
              const Text('Bike'),
              const SizedBox(width: 4),
              Text(
                '(${widget.parkingSpot.availableBikeSpots} available)',
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
        selected: _vehicleType == VehicleType.bike,
        onSelected: (selected) {
          if (selected) setState(() => _vehicleType = VehicleType.bike);
        },
      ),
    ),
  ],
),

            const SizedBox(height: 16),
            TextField(
              controller: _vehicleNumberController,
              decoration: InputDecoration(
                labelText: 'Vehicle Number (Optional)',
                hintText: 'e.g., ABC-1234',
                prefixIcon: const Icon(Icons.directions_car),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _eventNameController,
              decoration: InputDecoration(
                labelText: 'Event/Purpose (Optional)',
                hintText: 'e.g., Movie: Avengers, Shopping',
                prefixIcon: const Icon(Icons.event),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Start Time',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectStartTime,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _startTime != null
                          ? DateFormat('MMM dd, yyyy • HH:mm').format(_startTime!)
                          : 'Select start time',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Duration',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: _hours > 1 ? () => _updateHours(_hours - 1) : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '$_hours ${_hours == 1 ? 'hour' : 'hours'}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _updateHours(_hours + 1),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'End Time',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectEndTime,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _endTime != null
                          ? DateFormat('MMM dd, yyyy • HH:mm').format(_endTime!)
                          : 'Select end time',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text(
                  'Payment Method',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(Required)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final method = await Navigator.push<PaymentMethod>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentMethodScreen(
                      selectedMethod: _paymentMethod,
                      onMethodSelected: (method) {
                        setState(() => _paymentMethod = method);
                      },
                    ),
                  ),
                );
                if (method != null) {
                  setState(() => _paymentMethod = method);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _paymentMethod == null 
                        ? Colors.orange 
                        : Colors.grey[300]!,
                    width: _paymentMethod == null ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: _paymentMethod == null 
                      ? Colors.orange.withOpacity(0.05)
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (_paymentMethod != null) ...[
                          Text(
                            _paymentMethod!.icon,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _paymentMethod!.displayName,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ] else ...[
                          Icon(
                            Icons.payment,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Select Payment Method',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ],
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Price per hour (${_vehicleType.displayName})',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          '₹${(_vehicleType == VehicleType.car ? widget.parkingSpot.pricePerHourCar : widget.parkingSpot.pricePerHourBike).toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          '₹${_totalPrice.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _confirmBooking,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Confirm Booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

