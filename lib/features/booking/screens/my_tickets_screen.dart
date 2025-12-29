import 'package:flutter/material.dart';

class MyTicketsScreen extends StatelessWidget {
  const MyTicketsScreen({super.key});

  final List<Map<String, dynamic>> bookedEvents = const [
    {
      'event': {
        'id': '1',
        'title': 'Bahir Dar Music Festival',
        'location': 'City Stadium, Bahir Dar',
        'date': '2024-12-15',
        'imageUrl': 'assets/images/music_festival.jpg',
      },
      'ticketCount': 2,
      'totalPrice': 300.0,
      'ticketCode': 'SPOTA-MF-5A8B2C',
      'bookingDate': '2024-11-20',
      'status': 'upcoming', // upcoming, completed, cancelled
    },
    {
      'event': {
        'id': '2',
        'title': 'BDU Tech Conference 2024',
        'location': 'EiTEX Campus, Bahir Dar University',
        'date': '2024-11-25',
        'imageUrl': 'assets/images/tech_conference.jpg',
      },
      'ticketCount': 1,
      'totalPrice': 50.0,
      'ticketCode': 'SPOTA-TC-3D4E5F',
      'bookingDate': '2024-11-18',
      'status': 'upcoming',
    },
    {
      'event': {
        'id': '3',
        'title': 'Lake Tana Boat Race',
        'location': 'Lake Tana, Bahir Dar',
        'date': '2024-10-10',
        'imageUrl': 'assets/images/boat_race.jpg',
      },
      'ticketCount': 4,
      'totalPrice': 100.0,
      'ticketCode': 'SPOTA-BR-1A2B3C',
      'bookingDate': '2024-09-28',
      'status': 'completed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('My Tickets'),
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Upcoming Tickets
            _buildTicketsList('upcoming'),

            // Completed Tickets
            _buildTicketsList('completed'),

            // Cancelled Tickets
            _buildTicketsList('cancelled'),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketsList(String status) {
    final filteredTickets =
        bookedEvents.where((ticket) => ticket['status'] == status).toList();

    if (filteredTickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getEmptyStateIcon(status),
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _getEmptyStateText(status),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredTickets.length,
      itemBuilder: (context, index) {
        final ticket = filteredTickets[index];
        return _buildTicketCard(ticket, context);
      },
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket, BuildContext context) {
    final event = ticket['event'] as Map<String, dynamic>;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Event Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.event, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event['location'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Date: ${event['date']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Ticket Details
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tickets:', style: TextStyle(fontSize: 14)),
                    Text('${ticket['ticketCount']}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Paid:', style: TextStyle(fontSize: 14)),
                    Text('${ticket['totalPrice']} ETB',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Ticket Code:', style: TextStyle(fontSize: 14)),
                    Text(
                      ticket['ticketCode'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getEmptyStateIcon(String status) {
    switch (status) {
      case 'upcoming':
        return Icons.event_available;
      case 'completed':
        return Icons.history;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.event;
    }
  }

  String _getEmptyStateText(String status) {
    switch (status) {
      case 'upcoming':
        return 'No upcoming events';
      case 'completed':
        return 'No completed events';
      case 'cancelled':
        return 'No cancelled events';
      default:
        return 'No events';
    }
  }

  void _showTicketDetails(Map<String, dynamic> ticket, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ticket Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Event: ${ticket['event']['title']}'),
            Text('Location: ${ticket['event']['location']}'),
            Text('Date: ${ticket['event']['date']}'),
            Text('Tickets: ${ticket['ticketCount']}'),
            Text('Total: ${ticket['totalPrice']} ETB'),
            Text('Code: ${ticket['ticketCode']}'),
            Text('Booked: ${ticket['bookingDate']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
