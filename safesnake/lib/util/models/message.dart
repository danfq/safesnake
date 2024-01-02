///Chat Message
class Message {
  //Fields
  final String id;
  final String chatID;
  final String content;
  final int sentAt;
  final String sender;
  final String? replyTo;

  //Chat Message
  const Message({
    required this.id,
    required this.chatID,
    required this.content,
    required this.sentAt,
    required this.sender,
    this.replyTo,
  });

  ///`Message` to JSON Object
  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "chat": chatID,
      "content": content,
      "sent_at": sentAt,
      "sender": sender,
      "reply_to": replyTo,
    };
  }

  ///JSON Object to `Message`
  factory Message.fromJSON(Map<String, dynamic> json) {
    return Message(
      id: json["id"],
      chatID: json["chat"],
      content: json["decrypted_content"],
      sentAt: json["sent_at"],
      sender: json["sender"],
      replyTo: json["reply_to"],
    );
  }
}
