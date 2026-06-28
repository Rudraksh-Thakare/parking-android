import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parking_app/providers/parking_provider.dart';
import 'package:parking_app/screens/parking_detail_screen.dart';
import 'package:parking_app/screens/bookings_screen.dart';
import 'package:parking_app/screens/profile_screen.dart';
import 'package:parking_app/screens/notifications_screen.dart';
import 'package:parking_app/providers/auth_provider.dart';
import 'package:parking_app/providers/notification_provider.dart';
import 'package:parking_app/widgets/parking_spot_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);

    // Load notifications when user is logged in (only once per build)
    if (authProvider.userId != null &&
        !notificationProvider.isLoading &&
        notificationProvider.notifications.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notificationProvider.loadNotifications(authProvider.userId!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Parking'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
              ),
              if (notificationProvider.unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      notificationProvider.unreadCount > 9
                          ? '9+'
                          : '${notificationProvider.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _currentIndex == 0 ? _buildHomeTab() : _buildOtherTabs(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    final parkingProvider = Provider.of<ParkingProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search parking spots...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {},
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              parkingProvider.searchParkingSpots(value);
            },
          ),
        ),
        Expanded(
          child: parkingProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : parkingProvider.parkingSpots.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_parking,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No parking spots available',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              parkingProvider.loadParkingSpots();
                            },
                            child: const Text('Refresh'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: parkingProvider.parkingSpots.length,
                      itemBuilder: (context, index) {
                        final spot = parkingProvider.parkingSpots[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ParkingSpotCard(
                            parkingSpot: spot,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ParkingDetailScreen(
                                    parkingSpot: spot,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildOtherTabs() {
    if (_currentIndex == 1) {
      return const BookingsScreen();
    } else if (_currentIndex == 2) {
      return const ProfileScreen();
    }
    return const SizedBox();
  }
}
