import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:night_shift_store/dialogues/dialogue_template.dart';

Future<List<DialogueLine>> loadDialogue(String key) async {
  final jsonString = await rootBundle.loadString(
    'assets/dialogues/game_dialogues.json',
  );

  final Map<String, dynamic> data = json.decode(jsonString);

  final List lines = data[key];

  return lines.map((e) => DialogueLine.fromJson(e)).toList();
}
