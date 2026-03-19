class DialogueLine {
  final String speaker;
  final String portrait;
  final String text;

  DialogueLine({
    required this.speaker,
    required this.portrait,
    required this.text,
  });

  factory DialogueLine.fromJson(Map<String, dynamic> json) {
    return DialogueLine(
      speaker: json['speaker'],
      portrait: json['portrait'],
      text: json['text'],
    );
  }
}