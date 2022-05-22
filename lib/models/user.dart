class User {

  late final String _userId;
  late final String _userEmail;
  late final String _userName;
  late final String _userPassword;
  late final String _isDoctor;

  User(this._userId, this._userEmail, this._userName, this._userPassword, this._isDoctor);

  User.map(dynamic obj) {
    _userId = obj['userId'];
    _userEmail = obj['userEmail'];
    _userName = obj['userName'];
    _userPassword = obj['userPassword'];
    _isDoctor = obj['isDoctor'];
  }

  String get userId => _userId;
  String get userEmail => _userEmail;
  String get userName => _userName;
  String get userPassword => _userPassword;
  String get isDoctor => _isDoctor;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["userId"] = _userId;
    map["userEmail"] = _userEmail;
    map["userName"] = _userName;
    map["userPassword"] = _userPassword;
    map["isDoctor"] = _isDoctor;
    return map;
  }
}