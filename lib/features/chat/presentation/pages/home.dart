import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/config/app_routes.dart';
import '../../../specialist/data/models/specialist.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColors['white'],
      appBar: AppBar(
        backgroundColor: AppColors.mainColors['blue'],
        title: const Text(
          'HablaQui',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.welcome);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search specialists...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          // Chats List
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                final specialists = [
                  Specialist(
                    id: '1',
                    name: 'Dr. Smith',
                    fullName: 'Dr. John Smith',
                    avatar: 'https://example.com/avatar1.jpg',
                  ),
                  Specialist(
                    id: '2',
                    name: 'Dr. Johnson',
                    fullName: 'Dr. Sarah Johnson',
                    avatar: 'https://example.com/avatar2.jpg',
                  ),
                  Specialist(
                    id: '3',
                    name: 'Dr. Williams',
                    fullName: 'Dr. Michael Williams',
                    avatar: 'https://example.com/avatar3.jpg',
                  ),
                ];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.mainColors['blue'],
                      child: Text(
                        specialists[index].name?[0] ?? '?',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      specialists[index].name ?? 'Unknown',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      specialists[index].fullName ?? 'No description',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.chat,
                        arguments: specialists[index],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.mainColors['blue'],
        onPressed: () {
          // TODO: Implement new chat
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
} 