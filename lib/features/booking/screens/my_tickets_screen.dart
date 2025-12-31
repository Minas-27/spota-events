import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spota_events/app/providers/auth_provider.dart';
import 'package:spota_events/shared/models/booking_model.dart';
import 'package:spota_events/shared/services/event_service.dart';

class MyTicketsScreen extends StatelessWidget {
  const MyTicketsScreen({super.key});

  static final EventService _eventService = EventService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Upcoming Tickets
            _buildTicketsList(context, 'upcoming'),

            // Completed Tickets
            _buildTicketsList(context, 'completed'),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketsList(BuildContext context, String status) {
    final user = context.watch<AuthProvider>().currentUser;

    return StreamBuilder<List<Booking>>(
      stream: _eventService.getUserBookingsStream(user.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'Error loading tickets',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  if (snapshot.error.toString().contains('FAILED_PRECONDITION'))
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'This usually means a Firestore Index is missing. Please check the debug console for the link to create it.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final allBookings = snapshot.data ?? [];
        final now = DateTime.now();
        final filteredTickets = allBookings.where((b) {
          if (b.status == 'cancelled') return false;

          if (status == 'upcoming') {
            return b.eventDate.isAfter(now) ||
                (b.eventDate.year == now.year &&
                    b.eventDate.month == now.month &&
                    b.eventDate.day == now.day);
          } else if (status == 'completed') {
            return b.eventDate.isBefore(now) &&
                !(b.eventDate.year == now.year &&
                    b.eventDate.month == now.month &&
                    b.eventDate.day == now.day);
          }
          return false;
        }).toList();

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
      },
    );
  }

  Widget _buildTicketCard(Booking ticket, BuildContext context) {
    return GestureDetector(
      onTap: () => _showTicketDetails(ticket, context),
      child: Container(
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
                    child: ticket.imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              ticket.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image,
                                    color: Colors.grey);
                              },
                            ),
                          )
                        : const Icon(Icons.event, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket.eventTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ticket.eventLocation,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Date: ${ticket.eventDate.day}/${ticket.eventDate.month}/${ticket.eventDate.year}',
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
                      Text('${ticket.ticketCount}',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Paid:', style: TextStyle(fontSize: 14)),
                      Text('${ticket.totalPrice} ETB',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ticket Code:',
                          style: TextStyle(fontSize: 14)),
                      Text(
                        ticket.ticketCode,
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

  void _showTicketDetails(Booking ticket, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ticket Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Event: ${ticket.eventTitle}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Location: ${ticket.eventLocation}'),
            Text(
                'Event Date: ${ticket.eventDate.day}/${ticket.eventDate.month}/${ticket.eventDate.year}'),
            Text(
                'Booked On: ${ticket.bookingDate.day}/${ticket.bookingDate.month}/${ticket.bookingDate.year}'),
            const SizedBox(height: 12),
            Text('Tickets: ${ticket.ticketCount}'),
            Text('Total: ${ticket.totalPrice} ETB'),
            const SizedBox(height: 12),
            Text('Code: ${ticket.ticketCode}',
                style: const TextStyle(
                    color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
            Text('Status: ${ticket.status.toUpperCase()}'),
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
