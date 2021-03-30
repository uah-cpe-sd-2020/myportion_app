class Schedule {
  String id;
  String name = '';
  String petName = '';
  num portion = 0;
  String time = '';

  Schedule({this.id, this.name, this.petName, this.portion, this.time});

  /* CLASS FUNCTIONS CAN GO HERE */

  factory Schedule.fromJson(Map<String, dynamic> parsedJson) {
    return new Schedule(
        id: parsedJson['id'] ?? '',
        name: parsedJson['name'] ?? '',
        petName: parsedJson['petName'] ?? '',
        portion: parsedJson['portion'] ?? 0,
        time: parsedJson['time'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'petName': this.petName,
      'portion': this.portion,
      'time': this.time,
    };
  }
}
