class Services {
  late final String _serviceId;
  late final String _serviceName;
  late final String _serviceDescription;
  late final String _serviceLocation;

  Services(this._serviceId, this._serviceName, this._serviceDescription, this._serviceLocation);

  Services.map(dynamic obj) {
    _serviceId = obj['serviceId'];
    _serviceName = obj['serviceName'];
    _serviceDescription = obj['serviceDescription'];
    _serviceLocation = obj['serviceLocation'];
  }

  String get serviceId => _serviceId;
  String get serviceName => _serviceName;
  String get serviceDescription => _serviceDescription;
  String get serviceLocation => _serviceLocation;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["serviceId"] = _serviceId;
    map["serviceName"] = _serviceName;
    map["serviceDescription"] = _serviceDescription;
    map["serviceLocation"] = _serviceLocation;
    return map;
  }
}