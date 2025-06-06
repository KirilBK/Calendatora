class CalendarEvent {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String createdBy;
  final String? color;
  final DateTime createdAt;

  CalendarEvent({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.createdBy,
    this.color,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now() {
    // Validate that endTime is after startTime
    if (endTime.isBefore(startTime)) {
      throw ArgumentError('End time must be after start time');
    }
  }

  // Copy with method for immutable updates
  CalendarEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? createdBy,
    String? color,
    DateTime? createdAt,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createdBy: createdBy ?? this.createdBy,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory CalendarEvent.fromMap(Map<String, dynamic> data, String docId) {
    try {
      return CalendarEvent(
        id: docId,
        title: data['title'] as String,
        description: data['description'] as String?,
        startTime: DateTime.parse(data['startTime'] as String),
        endTime: DateTime.parse(data['endTime'] as String),
        createdBy: data['createdBy'] as String,
        color: data['color'] as String?,
        createdAt: DateTime.parse(data['createdAt'] as String),
      );
    } catch (e) {
      throw FormatException('Failed to parse CalendarEvent: $e');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'createdBy': createdBy,
      'color': color,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarEvent &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          createdBy == other.createdBy &&
          color == other.color &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(
        id,
        title,
        description,
        startTime,
        endTime,
        createdBy,
        color,
        createdAt,
      );
}