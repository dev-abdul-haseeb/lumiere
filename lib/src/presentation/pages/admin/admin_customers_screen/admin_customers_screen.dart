import 'package:flutter/material.dart';

class AdminCustomersScreen extends StatefulWidget {
  const AdminCustomersScreen({super.key});

  @override
  State<AdminCustomersScreen> createState() => _AdminCustomersScreenState();
}

class _AdminCustomersScreenState extends State<AdminCustomersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Customers'),
    );
  }
}
