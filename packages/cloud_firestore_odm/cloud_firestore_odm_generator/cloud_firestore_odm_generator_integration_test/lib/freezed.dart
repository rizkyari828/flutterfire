// ignore_for_file: invalid_annotation_target

import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'freezed.freezed.dart';
part 'freezed.g.dart';

@Collection<Person>('freezed-test')
@freezed
class Person with _$Person {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory Person({
    required String firstName,
    @JsonKey(name: 'LAST_NAME') required String lastName,
    @JsonKey(ignore: true) int? ignored,
  }) = _Person;

  factory Person.fromJson(Map<String, Object?> json) => _$PersonFromJson(json);
}

final personRef = PersonCollectionReference();

@Collection<PublicRedirected>('freezed-test')
@freezed
class PublicRedirected with _$PublicRedirected {
  factory PublicRedirected({required String value}) = PublicRedirected2;

  factory PublicRedirected.fromJson(Map<String, Object?> json) =>
      _$PublicRedirectedFromJson(json);
}
