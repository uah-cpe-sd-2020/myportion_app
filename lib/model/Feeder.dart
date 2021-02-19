class Feeder {
  String feederID = '';
  String modelNum;
  String name = '';

  Feeder({this.feederID, this.modelNum, this.name});

  /* CLASS FUNCTIONS CAN GO HERE */

  factory Feeder.fromJson(Map<String, dynamic> parsedJson) {
    return new Feeder(
        feederID: parsedJson['id'] ?? parsedJson['feederID'] ?? '',
        modelNum: parsedJson['modelNumber'] ?? '',
        name: parsedJson['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.feederID,
      'modelNumber': this.modelNum,
      'name': this.name
    };
  }
}
