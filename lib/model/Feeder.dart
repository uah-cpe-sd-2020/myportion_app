class Feeder {
  String id;
  String modelNum;
  String name = '';

  Feeder({this.id, this.modelNum, this.name});

  /* CLASS FUNCTIONS CAN GO HERE */

  factory Feeder.fromJson(Map<String, dynamic> parsedJson) {
    return new Feeder(
        id: parsedJson['id'] ?? '',
        modelNum: parsedJson['modelNumber'] ?? '',
        name: parsedJson['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': this.id, 'modelNumber': this.modelNum, 'name': this.name};
  }
}
