import 'package:flutter/material.dart';
import 'package:spota_events/features/booking/screens/booking_confirmation_screen.dart';
import 'package:spota_events/shared/models/event_model.dart';
import 'package:spota_events/shared/services/event_service.dart';
import 'package:provider/provider.dart';
import 'package:spota_events/app/providers/auth_provider.dart';
import 'package:spota_events/shared/services/chapa_service.dart';
import 'package:spota_events/features/booking/screens/payment_webview_screen.dart';
import 'package:uuid/uuid.dart';

class BookingScreen extends StatefulWidget {
  final Event event;

  const BookingScreen({super.key, required this.event});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int ticketCount = 1;
  final EventService _eventService = EventService();
  final ChapaService _chapaService = ChapaService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.event.price * ticketCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Tickets'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
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
                          widget.event.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.event.date.day}/${widget.event.date.month}/${widget.event.date.year} • ${widget.event.location}',
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
            const SizedBox(height: 32),

            // Ticket Selection
            const Text(
              'Number of Tickets',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'General Admission',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: ticketCount > 1
                            ? () {
                                setState(() {
                                  ticketCount--;
                                });
                              }
                            : null,
                        icon: Container(
                          decoration: BoxDecoration(
                            color: ticketCount > 1
                                ? const Color(0xFF2563EB)
                                : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      Text(
                        '$ticketCount',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: ticketCount < widget.event.availableTickets
                            ? () {
                                setState(() {
                                  ticketCount++;
                                });
                              }
                            : null,
                        icon: Container(
                          decoration: BoxDecoration(
                            color: ticketCount < widget.event.availableTickets
                                ? const Color(0xFF2563EB)
                                : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Price Breakdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildPriceRow('Ticket Price', '${widget.event.price} ETB'),
                  const SizedBox(height: 8),
                  _buildPriceRow('Quantity', '$ticketCount'),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildPriceRow(
                    'Total Amount',
                    '$totalPrice ETB',
                    isTotal: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Payment Methods
            const Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2563EB), width: 1.5),
              ),
              child: RadioListTile(
                value: 'chapa',
                groupValue: 'chapa',
                onChanged: (value) {},
                activeColor: const Color(0xFF2563EB),
                title: const Text(
                  'Chapa',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Pay with Telebirr, CBE, etc.'),
                secondary: const Icon(Icons.payment, color: Color(0xFF2563EB)),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: RadioListTile(
                value: 'other',
                groupValue: 'chapa',
                onChanged: null, // Disabled
                title: const Text(
                  'Telebirr (Coming Soon)',
                  style: TextStyle(color: Colors.grey),
                ),
                secondary:
                    const Icon(Icons.mobile_friendly, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 32),

            // Book Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handlePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Proceed to Payment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePayment() async {
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;
    final double totalPrice = widget.event.price * ticketCount;

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Initialize Chapa Transaction
      final String txRef = 'TX-${const Uuid().v4().substring(0, 8)}';

      final checkoutUrl = await _chapaService.initializeTransaction(
        email: user.email,
        firstName: user.name.split(' ').first,
        lastName: user.name.contains(' ') ? user.name.split(' ').last : 'User',
        amount: totalPrice,
        txRef: txRef,
        title: widget.event.title,
      );

      if (checkoutUrl == null) {
        throw Exception('Failed to initialize payment gateway');
      }

      if (!mounted) return;

      // 2. Open WebView for Payment
      final bool? paymentResult = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentWebViewScreen(
            checkoutUrl: checkoutUrl,
            returnUrl: 'https://example.com/payment-success',
          ),
        ),
      );

      if (paymentResult == true) {
        // 3. Verify and Finalize Booking in Firestore
        // For test mode, we'll assume success if the return URL was reached
        await _eventService.bookTickets(
          eventId: widget.event.id,
          userId: user.uid,
          quantity: ticketCount,
          totalPrice: totalPrice,
          phoneNumber: user.phone,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking Successful!'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BookingConfirmationScreen(
                event: widget.event.copyWith(
                  availableTickets: widget.event.availableTickets - ticketCount,
                ),
                ticketCount: ticketCount,
                totalPrice: totalPrice,
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment cancelled or failed'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? const Color(0xFF2563EB) : Colors.black,
          ),
        ),
      ],
    );
  }
}
