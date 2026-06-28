import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add payment method feature coming soon!')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Text('📱', style: TextStyle(fontSize: 32)),
              title: const Text('UPI'),
              subtitle: const Text('GPay, PhonePe, Paytm'),
              trailing: const Icon(Icons.check_circle, color: Colors.green),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Text('💳', style: TextStyle(fontSize: 32)),
              title: const Text('Credit Card'),
              subtitle: const Text('**** **** **** 1234'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit card feature coming soon!')),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Text('💳', style: TextStyle(fontSize: 32)),
              title: const Text('Debit Card'),
              subtitle: const Text('**** **** **** 5678'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit card feature coming soon!')),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add new payment method feature coming soon!')),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add New Payment Method'),
            ),
          ),
        ],
      ),
    );
  }
}

