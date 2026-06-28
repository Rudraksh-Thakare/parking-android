import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@parkingapp.com',
      query: 'subject=Support Request',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+91-1800-123-4567');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.help_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'How can we help you?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _HelpTile(
            icon: Icons.phone,
            title: 'Call Support',
            subtitle: '+91-1800-123-4567',
            onTap: _launchPhone,
          ),
          _HelpTile(
            icon: Icons.email,
            title: 'Email Support',
            subtitle: 'support@parkingapp.com',
            onTap: _launchEmail,
          ),
          _HelpTile(
            icon: Icons.chat_bubble_outline,
            title: 'Live Chat',
            subtitle: 'Available 24/7',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Live chat feature coming soon!')),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ExpansionTile(
            title: const Text('How do I book a parking spot?'),
            children: const [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Search for a parking location, select your vehicle type, choose date and time, select payment method, and confirm your booking. You will receive a booking number that you can show to mall staff.',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Can I cancel my booking?'),
            children: const [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Yes, you can cancel your booking from the Bookings section. Cancellations are free if done before the start time.',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('What payment methods are accepted?'),
            children: const [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'We accept UPI, Credit Cards, Debit Cards, Net Banking, Wallets, and Cash payments.',
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('How do I find my booking receipt?'),
            children: const [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'After booking, you will see your receipt automatically. You can also view it anytime from the Bookings section by tapping the receipt icon.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HelpTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HelpTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

