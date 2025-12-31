import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String eventId;
  final String userId;
  final String eventTitle;
  final String eventLocation;
  final String imageUrl;
  final int ticketCount;
  final double totalPrice;
  final String ticketCode;
  final DateTime bookingDate;
  final DateTime eventDate;
  final String status;

  Booking({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.eventTitle,
    required this.eventLocation,
    required this.imageUrl,
    required this.ticketCount,
    required this.totalPrice,
    required this.ticketCode,
    required this.bookingDate,
    required this.eventDate,
    this.status = 'upcoming',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventId': eventId,
      'userId': userId,
      'eventTitle': eventTitle,
      'eventLocation': eventLocation,
      'imageUrl': imageUrl,
      'ticketCount': ticketCount,
      'totalPrice': totalPrice,
      'ticketCode': ticketCode,
      'bookingDate': Timestamp.fromDate(bookingDate),
      'eventDate': Timestamp.fromDate(eventDate),
      'status': status,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] ?? '',
      eventId: map['eventId'] ?? '',
      userId: map['userId'] ?? '',
      eventTitle: map['eventTitle'] ?? 'Event',
      eventLocation: map['eventLocation'] ?? 'Location',
      imageUrl: map['imageUrl'] ?? '',
      ticketCount: (map['ticketCount'] as num?)?.toInt() ?? 0,
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
      ticketCode: map['ticketCode'] ?? '',
      bookingDate:
          (map['bookingDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      eventDate: (map['eventDate'] != null)
          ? (map['eventDate'] is Timestamp
              ? (map['eventDate'] as Timestamp).toDate()
              : DateTime.parse(map['eventDate']))
          : DateTime.now(),
      status: map['status'] ?? 'upcoming',
    );
  }
}
