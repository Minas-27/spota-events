class Event {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final String imageUrl;
  final double price;
  final int availableTickets;
  final String category;
  final String organizer;
  final int totalTickets;
  final String organizerId;
  final DateTime createdAt;
  final String status; // active, cancelled

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.imageUrl,
    required this.price,
    required this.availableTickets,
    required this.totalTickets,
    required this.category,
    required this.organizer,
    required this.organizerId,
    required this.createdAt,
    this.status = 'active',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
      'price': price,
      'availableTickets': availableTickets,
      'totalTickets': totalTickets,
      'category': category,
      'organizer': organizer,
      'organizerId': organizerId,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      availableTickets: map['availableTickets'] ?? 0,
      totalTickets: map['totalTickets'] ?? 0,
      category: map['category'] ?? '',
      organizer: map['organizer'] ?? '',
      organizerId: map['organizerId'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      status: map['status'] ?? 'active',
    );
  }

  Event copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    DateTime? date,
    String? imageUrl,
    double? price,
    int? availableTickets,
    int? totalTickets,
    String? category,
    String? organizer,
    String? organizerId,
    DateTime? createdAt,
    String? status,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      availableTickets: availableTickets ?? this.availableTickets,
      totalTickets: totalTickets ?? this.totalTickets,
      category: category ?? this.category,
      organizer: organizer ?? this.organizer,
      organizerId: organizerId ?? this.organizerId,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}
