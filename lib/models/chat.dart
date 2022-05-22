class Chats {
  late final String _chatId;
  late final String _primaryUserId;
  late final String _secondaryUserId;

  Chats(this._chatId, this._primaryUserId, this._secondaryUserId);

  Chats.map(dynamic obj) {
    _chatId = obj['chatId'];
    _primaryUserId = obj['primaryUserId'];
    _secondaryUserId = obj['secondaryUserId'];
  }

  String get chatId => _chatId;
  String get primaryUserId => _primaryUserId;
  String get secondaryUserId => _secondaryUserId;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["chatId"] = _chatId;
    map["primaryUserId"] = _primaryUserId;
    map["secondaryUserId"] = _secondaryUserId;
    return map;
  }
}

class ChatMessage {
  late final String _chatMessage;
  late final int _chatTime;
  late final String _sendBy;

  ChatMessage(this._chatMessage, this._chatTime, this._sendBy);

  ChatMessage.map(dynamic obj) {
    _chatMessage = obj['chatMessage'];
    _chatTime = obj['chatTime'];
    _sendBy = obj['sendBy'];
  }

  String get chatMessage => _chatMessage;
  int get chatTime => _chatTime;
  String get sendBy => _sendBy;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["chatMessage"] = _chatMessage;
    map["chatTime"] = _chatTime;
    map["sendBy"] = _sendBy;
    return map;
  }
}