// To parse this JSON data, do
//
//     final topics = topicsFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'topics.freezed.dart';
part 'topics.g.dart';

Topics topicsFromJson(String str) =>
    Topics.fromJson(json.decode(str) as Map<String, dynamic>);

String topicsToJson(Topics data) => json.encode(data.toJson());

@freezed
abstract class Topics with _$Topics {
  const factory Topics({
    @JsonKey(name: 't1') required T1 t1,
    @JsonKey(name: 't10') required T1 t10,
    @JsonKey(name: 't11') required T1 t11,
    @JsonKey(name: 't12') required T1 t12,
    @JsonKey(name: 't2') required T1 t2,
    @JsonKey(name: 't3') required T1 t3,
    @JsonKey(name: 't4') required T1 t4,
    @JsonKey(name: 't5') required T1 t5,
    @JsonKey(name: 't6') required T1 t6,
    @JsonKey(name: 't7') required T1 t7,
    @JsonKey(name: 't8') required T1 t8,
    @JsonKey(name: 't9') required T1 t9,
  }) = _Topics;

  factory Topics.fromJson(Map<String, dynamic> json) => _$TopicsFromJson(json);
}

@freezed
abstract class T1 with _$T1 {
  const factory T1({
    @JsonKey(name: 'child') required List<Child> child,
    @JsonKey(name: 'title') required String title,
  }) = _T1;

  factory T1.fromJson(Map<String, dynamic> json) => _$T1FromJson(json);
}

@freezed
abstract class Child with _$Child {
  const factory Child({
    @JsonKey(name: 'title') required String title,
  }) = _Child;

  factory Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);
}
