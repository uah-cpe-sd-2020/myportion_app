class Schedule {
  String id;
  List<int> portion = [];
  List<dynamic> time = [];

  Schedule({this.id, this.portion, this.time});

  /* CLASS FUNCTIONS CAN GO HERE */

  factory Schedule.fromJson(Map<String, dynamic> parsedJson) {
    return new Schedule(
        id: parsedJson['id'] ?? '',
        portion: parsedJson['portion'] ?? '',
        time: parsedJson['time'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'portion': this.portion,
      'time': this.time,
    };
  }
}
