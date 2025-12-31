import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import '../models/index.dart';
import '../services/cloudinary_service.dart';
import '../services/afro_message_service.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final AfroMessageService _afroMessageService = AfroMessageService();
  final String _collection = 'events';

  // Create or Update Event
  Future<void> saveEvent(Event event) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(event.id.isEmpty ? null : event.id)
          .set(
            event.toMap(),
            SetOptions(merge: true),
          );
    } catch (e) {
      print('Error saving event: $e');
      rethrow;
    }
  }

  // Get all active events
  Future<List<Event>> getEvents() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'active')
          .orderBy('date')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Ensure ID is from document
        return Event.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error getting events: $e');
      return [];
    }
  }

  // Get events for a specific organizer
  Future<List<Event>> getOrganizerEvents(String organizerId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('organizerId', isEqualTo: organizerId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Event.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error getting organizer events: $e');
      return [];
    }
  }

  // Delete/Cancel event
  Future<void> deleteEvent(String eventId) async {
    try {
      // We perform a soft delete by changing status
      await _firestore.collection(_collection).doc(eventId).update({
        'status': 'cancelled',
      });
    } catch (e) {
      print('Error deleting event: $e');
      rethrow;
    }
  }

  // Stream of events for real-time updates
  Stream<List<Event>> getEventsStream() {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'active')
        .orderBy('date')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Event.fromMap(data);
      }).toList();
    });
  }

  // Book Tickets (Transactionally decrement available tickets and create booking)
  Future<void> bookTickets({
    required String eventId,
    required String userId,
    required int quantity,
    required double totalPrice,
    String? phoneNumber, // Optional, can be fetched if not provided
  }) async {
    final docRef = _firestore.collection(_collection).doc(eventId);
    final bookingId = const Uuid().v4();
    final ticketCode =
        'SPOTA-${eventId.substring(0, 2).toUpperCase()}-${bookingId.substring(0, 6).toUpperCase()}';

    // 1. Fetch user phone if not provided
    String? targetPhone = phoneNumber;
    if (targetPhone == null) {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        targetPhone = userDoc.data()?['phone'];
      }
    }

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw Exception('Event does not exist');
      }

      final eventData = snapshot.data()!;
      final currentAvailable =
          (eventData['availableTickets'] as num?)?.toInt() ?? 0;

      if (currentAvailable < quantity) {
        throw Exception('Not enough tickets available');
      }

      final DateTime eventDate = eventData['date'] != null
          ? DateTime.parse(eventData['date'])
          : DateTime.now();

      final booking = Booking(
        id: bookingId,
        eventId: eventId,
        userId: userId,
        eventTitle: eventData['title'] ?? 'Event',
        eventLocation: eventData['location'] ?? 'Location',
        imageUrl: eventData['imageUrl'] ?? '',
        ticketCount: quantity,
        totalPrice: totalPrice,
        ticketCode: ticketCode,
        bookingDate: DateTime.now(),
        eventDate: eventDate,
      );

      // Update event capacity
      transaction.update(docRef, {
        'availableTickets': currentAvailable - quantity,
      });

      // Create booking record
      transaction.set(
        _firestore.collection('bookings').doc(bookingId),
        booking.toMap(),
      );

      // 4. Create Notifications within the same transaction
      final attendeeNotificationId = const Uuid().v4();
      final organizerNotificationId = const Uuid().v4();

      // Notification for Attendee
      final attendeeNotification = NotificationModel(
        id: attendeeNotificationId,
        userId: userId,
        title: 'Booking Confirmed!',
        message:
            'Your tickets for "${eventData['title']}" have been confirmed. Code: $ticketCode',
        createdAt: DateTime.now(),
        type: NotificationType.bookingSuccess,
      );

      // Notification for Organizer
      final organizerNotification = NotificationModel(
        id: organizerNotificationId,
        userId: eventData['organizerId'] ?? '',
        title: 'New Booking!',
        message:
            'Someone just booked $quantity tickets for "${eventData['title']}".',
        createdAt: DateTime.now(),
        type: NotificationType.newBooking,
      );

      transaction.set(
        _firestore.collection('notifications').doc(attendeeNotificationId),
        attendeeNotification.toMap(),
      );

      if (eventData['organizerId'] != null) {
        transaction.set(
          _firestore.collection('notifications').doc(organizerNotificationId),
          organizerNotification.toMap(),
        );
      }
    });

    // 5. Send Real SMS Notification (Outside transaction to avoid blocking)
    if (targetPhone != null && targetPhone.isNotEmpty) {
      final eventSnapshot = await docRef.get();
      final eventTitle = eventSnapshot.data()?['title'] ?? 'Event';

      _afroMessageService
          .sendTicketSMS(
        phoneNumber: targetPhone,
        eventTitle: eventTitle,
        ticketCode: ticketCode,
        ticketCount: quantity,
      )
          .then((success) {
        print('DEBUG: AfroMessage SMS sent: $success');
      }).catchError((e) {
        print('DEBUG ERROR: AfroMessage SMS failed: $e');
      });
    }
  }

  // Stream of bookings for a specific user
  Stream<List<Booking>> getUserBookingsStream(String userId) {
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('bookingDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Booking.fromMap(doc.data())).toList();
    });
  }

  // Stream of all events for a specific organizer
  Stream<List<Event>> getOrganizerEventsStream(String organizerId) {
    return _firestore
        .collection(_collection)
        .where('organizerId', isEqualTo: organizerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Event.fromMap(data);
      }).toList();
    });
  }

  // Stream of all bookings (for Admin Dashboard)
  Stream<List<Booking>> getAllBookingsStream() {
    return _firestore
        .collection('bookings')
        .orderBy('bookingDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Booking.fromMap(doc.data())).toList();
    });
  }

  // Upload Event Image to Cloudinary
  Future<String> uploadEventImage(File imageFile) async {
    print('DEBUG: Starting image upload to Cloudinary');
    try {
      final imageUrl = await _cloudinaryService.uploadImage(imageFile);

      if (imageUrl == null) {
        throw Exception('Cloudinary upload returned null URL');
      }

      print('DEBUG: Image uploaded to Cloudinary: $imageUrl');
      return imageUrl;
    } catch (e) {
      print('DEBUG ERROR: Error uploading event image to Cloudinary: $e');
      throw Exception(
          'Failed to upload image. Please check your connection and try again.');
    }
  }
}
