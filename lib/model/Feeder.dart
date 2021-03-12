class Feeder {
  String id;
  String modelType;
  String serialNum;
  String name = '';

  Feeder({this.id, this.modelType, this.serialNum, this.name});

  /* CLASS FUNCTIONS CAN GO HERE */

  factory Feeder.fromJson(Map<String, dynamic> parsedJson) {
    return new Feeder(
        id: parsedJson['id'] ?? '',
        modelType: parsedJson['modelType'] ?? '',
        serialNum: parsedJson['serialNumber'] ?? '',
        name: parsedJson['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'modelType': this.modelType,
      'serialNumber': this.serialNum,
      'name': this.name
    };
  }
}
