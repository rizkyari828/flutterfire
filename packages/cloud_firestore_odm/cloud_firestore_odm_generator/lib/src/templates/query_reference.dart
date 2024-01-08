// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/type_provider.dart';

import '../collection_data.dart';

class _WhereType {
  _WhereType(this.type, [this.defaultValue]);

  final String type;
  final String? defaultValue;
}

class QueryTemplate {
  QueryTemplate(this.data);

  final CollectionData data;

  @override
  String toString() {
    return '''
abstract class ${data.queryReferenceInterfaceName} implements QueryReference<${data.type}, ${data.querySnapshotName}> {
  @override
  ${data.queryReferenceInterfaceName} limit(int limit);

  @override
  ${data.queryReferenceInterfaceName} limitToLast(int limit);

  /// Perform an order query based on a [FieldPath].
  /// 
  /// This method is considered unsafe as it does check that the field path
  /// maps to a valid property or that parameters such as [isEqualTo] receive
  /// a value of the correct type.
  /// 
  /// If possible, instead use the more explicit variant of order queries:
  /// 
  /// **AVOID**:
  /// ```dart
  /// collection.orderByFieldPath(
  ///   FieldPath.fromString('title'),
  ///   startAt: 'title',
  /// );
  /// ```
  /// 
  /// **PREFER**:
  /// ```dart
  /// collection.orderByTitle(startAt: 'title');
  /// ```
  ${data.queryReferenceInterfaceName} orderByFieldPath(
    FieldPath fieldPath, {
    bool descending = false,
    Object? startAt,
    Object? startAfter,
    Object? endAt,
    Object? endBefore,
    ${data.documentSnapshotName}? startAtDocument,
    ${data.documentSnapshotName}? endAtDocument,
    ${data.documentSnapshotName}? endBeforeDocument,
    ${data.documentSnapshotName}? startAfterDocument,
  });

  /// Perform a where query based on a [FieldPath].
  /// 
  /// This method is considered unsafe as it does check that the field path
  /// maps to a valid property or that parameters such as [isEqualTo] receive
  /// a value of the correct type.
  /// 
  /// If possible, instead use the more explicit variant of where queries:
  /// 
  /// **AVOID**:
  /// ```dart
  /// collection.whereFieldPath(FieldPath.fromString('title'), isEqualTo: 'title');
  /// ```
  /// 
  /// **PREFER**:
  /// ```dart
  /// collection.whereTitle(isEqualTo: 'title');
  /// ```
  ${data.queryReferenceInterfaceName} whereFieldPath(
    FieldPath fieldPath, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<Object?>? arrayContainsAny,
    List<Object?>? whereIn,
    List<Object?>? whereNotIn,
    bool? isNull,
  });

  ${_where(data, isAbstract: true)}
  ${_orderByProto(data)}
}

class ${data.queryReferenceImplName}
    extends QueryReference<${data.type}, ${data.querySnapshotName}>
    implements ${data.queryReferenceInterfaceName} {
  ${data.queryReferenceImplName}(
    this._collection, {
    required Query<${data.type}> \$referenceWithoutCursor,
    \$QueryCursor \$queryCursor = const \$QueryCursor(),
  })  : super(
          \$referenceWithoutCursor: \$referenceWithoutCursor,
          \$queryCursor: \$queryCursor,
        );

  final CollectionReference<Object?> _collection;

  @override
  Stream<${data.querySnapshotName}> snapshots([SnapshotOptions? options]) {
    return reference.snapshots().map(${data.querySnapshotName}._fromQuerySnapshot);
  }
  

  @override
  Future<${data.querySnapshotName}> get([GetOptions? options]) {
    return reference.get(options).then(${data.querySnapshotName}._fromQuerySnapshot);
  }

  @override
  ${data.queryReferenceInterfaceName} limit(int limit) {
    return ${data.queryReferenceImplName}(
      _collection,
      \$referenceWithoutCursor: \$referenceWithoutCursor.limit(limit),
      \$queryCursor: \$queryCursor,
    );
  }

  @override
  ${data.queryReferenceInterfaceName} limitToLast(int limit) {
    return ${data.queryReferenceImplName}(
      _collection,
      \$referenceWithoutCursor: \$referenceWithoutCursor.limitToLast(limit),
      \$queryCursor: \$queryCursor,
    );
  }

  ${data.queryReferenceInterfaceName} orderByFieldPath(
    FieldPath fieldPath, {
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ${data.documentSnapshotName}? startAtDocument,
    ${data.documentSnapshotName}? endAtDocument,
    ${data.documentSnapshotName}? endBeforeDocument,
    ${data.documentSnapshotName}? startAfterDocument,
  }) {
    final query = \$referenceWithoutCursor.orderBy(fieldPath, descending: descending);
    var queryCursor = \$queryCursor;

    if (startAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAt: const [],
        startAtDocumentSnapshot: startAtDocument.snapshot,
      );
    }
    if (startAfterDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAfter: const [],
        startAfterDocumentSnapshot: startAfterDocument.snapshot,
      );
    }
    if (endAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        endAt: const [],
        endAtDocumentSnapshot: endAtDocument.snapshot,
      );
    }
    if (endBeforeDocument != null) {
      queryCursor = queryCursor.copyWith(
        endBefore: const [],
        endBeforeDocumentSnapshot: endBeforeDocument.snapshot,
      );
    }

    if (startAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAt: [...queryCursor.startAt, startAt],
        startAtDocumentSnapshot: null,
      );
    }
    if (startAfter != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAfter: [...queryCursor.startAfter, startAfter],
        startAfterDocumentSnapshot: null,
      );
    }
    if (endAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endAt: [...queryCursor.endAt, endAt],
        endAtDocumentSnapshot: null,
      );
    }
    if (endBefore != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endBefore: [...queryCursor.endBefore, endBefore],
        endBeforeDocumentSnapshot: null,
      );
    }
    return ${data.queryReferenceImplName}(
      _collection,
      \$referenceWithoutCursor: query,
      \$queryCursor: queryCursor,
    );
  }

  ${data.queryReferenceInterfaceName} whereFieldPath(
    FieldPath fieldPath, {
    Object? isEqualTo = notSetQueryParam,
    Object? isNotEqualTo = notSetQueryParam,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<Object?>? arrayContainsAny,
    List<Object?>? whereIn,
    List<Object?>? whereNotIn,
    bool? isNull,
  }) {
    return ${data.queryReferenceImplName}(
      _collection,
      \$referenceWithoutCursor: \$referenceWithoutCursor.where(
        fieldPath,
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        arrayContains: arrayContains,
        arrayContainsAny: arrayContainsAny,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
        isNull: isNull,
      ),
      \$queryCursor: \$queryCursor,
    );
  }

  ${_where(data)}
  ${_orderBy(data)}

  ${_equalAndHashCode(data)}
}
''';
  }

  String _orderByProto(CollectionData data) {
    final buffer = StringBuffer();

    for (final field in data.queryableFields) {
      final titledNamed = field.name.replaceFirstMapped(
        RegExp('[a-zA-Z]'),
        (match) => match.group(0)!.toUpperCase(),
      );

      buffer.writeln(
        '''
  ${data.queryReferenceInterfaceName} orderBy$titledNamed({
    bool descending = false,
    ${field.type.getDisplayString(withNullability: true)} startAt,
    ${field.type.getDisplayString(withNullability: true)} startAfter,
    ${field.type.getDisplayString(withNullability: true)} endAt,
    ${field.type.getDisplayString(withNullability: true)} endBefore,
    ${data.documentSnapshotName}? startAtDocument,
    ${data.documentSnapshotName}? endAtDocument,
    ${data.documentSnapshotName}? endBeforeDocument,
    ${data.documentSnapshotName}? startAfterDocument,
  });
''',
      );
    }

    return buffer.toString();
  }

  String _orderBy(CollectionData data) {
    final buffer = StringBuffer();

    for (final field in data.queryableFields) {
      final titledNamed = field.name.replaceFirstMapped(
        RegExp('[a-zA-Z]'),
        (match) => match.group(0)!.toUpperCase(),
      );

      buffer.writeln(
        '''
  ${data.queryReferenceInterfaceName} orderBy$titledNamed({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ${data.documentSnapshotName}? startAtDocument,
    ${data.documentSnapshotName}? endAtDocument,
    ${data.documentSnapshotName}? endBeforeDocument,
    ${data.documentSnapshotName}? startAfterDocument,
  }) {
    final query = \$referenceWithoutCursor.orderBy(${field.field}, descending: descending);
    var queryCursor = \$queryCursor;

    if (startAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAt: const [],
        startAtDocumentSnapshot: startAtDocument.snapshot,
      );
    }
    if (startAfterDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAfter: const [],
        startAfterDocumentSnapshot: startAfterDocument.snapshot,
      );
    }
    if (endAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        endAt: const [],
        endAtDocumentSnapshot: endAtDocument.snapshot,
      );
    }
    if (endBeforeDocument != null) {
      queryCursor = queryCursor.copyWith(
        endBefore: const [],
        endBeforeDocumentSnapshot: endBeforeDocument.snapshot,
      );
    }

    if (startAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAt: [...queryCursor.startAt, startAt],
        startAtDocumentSnapshot: null,
      );
    }
    if (startAfter != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAfter: [...queryCursor.startAfter, startAfter],
        startAfterDocumentSnapshot: null,
      );
    }
    if (endAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endAt: [...queryCursor.endAt, endAt],
        endAtDocumentSnapshot: null,
      );
    }
    if (endBefore != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endBefore: [...queryCursor.endBefore, endBefore],
        endBeforeDocumentSnapshot: null,
      );
    }

    return ${data.queryReferenceImplName}(
      _collection,
      \$referenceWithoutCursor: query,
      \$queryCursor: queryCursor,
    );
  }
''',
      );
    }

    return buffer.toString();
  }

  String _where(CollectionData data, {bool isAbstract = false}) {
    // TODO handle JsonSerializable case change and JsonKey(name: ...)
    final buffer = StringBuffer();

    for (final field in data.queryableFields) {
      final titledNamed = field.name.replaceFirstMapped(
        RegExp('[a-zA-Z]'),
        (match) => match.group(0)!.toUpperCase(),
      );

      final nullableType =
          field.type.nullabilitySuffix == NullabilitySuffix.question
              ? '${field.type}'
              : '${field.type}?';

      final operators = <String, _WhereType>{
        'isEqualTo': isAbstract
            ? _WhereType(nullableType)
            : _WhereType('Object?', 'notSetQueryParam'),
        'isNotEqualTo': isAbstract
            ? _WhereType(nullableType)
            : _WhereType('Object?', 'notSetQueryParam'),
        'isLessThan': isAbstract
            ? _WhereType(nullableType)
            : _WhereType('Object?', 'null'),
        'isLessThanOrEqualTo': isAbstract
            ? _WhereType(nullableType)
            : _WhereType('Object?', 'null'),
        'isGreaterThan': isAbstract
            ? _WhereType(nullableType)
            : _WhereType('Object?', 'null'),
        'isGreaterThanOrEqualTo': isAbstract
            ? _WhereType(nullableType)
            : _WhereType('Object?', 'null'),
        'isNull': _WhereType('bool?'),
        if (field.type.isSupportedIterable) ...{
          'arrayContains': isAbstract
              ? _WhereType(
                  data.libraryElement.typeProvider
                      .asNullable(
                        (field.type as InterfaceType).typeArguments.first,
                      )
                      .toString(),
                )
              : _WhereType('Object?', 'notSetQueryParam'),
          'arrayContainsAny': _WhereType(nullableType),
        } else ...{
          'whereIn': _WhereType('List<${field.type}>?'),
          'whereNotIn': _WhereType('List<${field.type}>?'),
        },
      };

      final prototype = operators.entries.map((e) {
        if (e.value.defaultValue != null) {
          return '${e.value.type} ${e.key} = ${e.value.defaultValue},';
        }
        return '${e.value.type} ${e.key},';
      }).join();

      final perFieldToJson = data.perFieldToJson(field.name);

      final parameters = operators.entries.map((entry) {
        final key = entry.key;
        final value = entry.value;
        if (field.name == 'documentId' || key == 'isNull') {
          return '$key: $key,';
        } else if ({'whereIn', 'whereNotIn'}.contains(key)) {
          return '$key: $key?.map((e) => $perFieldToJson(e)),';
        } else if (key == 'arrayContainsAny') {
          return '$key: $key != null ? $perFieldToJson($key) as Iterable<Object>? : null,';
        } else if (key == 'arrayContains') {
          final itemType =
              (field.type as InterfaceType).typeArguments.first.toString();
          final cast = itemType != 'Object?' ? ' as $itemType' : '';

          var transform = '$key: $key != null ? ($perFieldToJson(';
          if (field.type.isSet) {
            transform += '{$key$cast}';
          } else {
            transform += '[$key$cast]';
          }
          return '$transform) as List?)!.single : null,';
        } else {
          return '$key: $key != ${value.defaultValue} ? $perFieldToJson($key as ${field.type}) : ${value.defaultValue},';
        }
      }).join();

      // TODO handle JsonSerializable case change and JsonKey(name: ...)

      if (isAbstract) {
        buffer.writeln(
          '${data.queryReferenceInterfaceName} where$titledNamed({$prototype});',
        );
      } else {
        buffer.writeln(
          '''
  ${data.queryReferenceInterfaceName} where$titledNamed({$prototype}) {
    return ${data.queryReferenceImplName}(
      _collection,
      \$referenceWithoutCursor: \$referenceWithoutCursor.where(${field.field}, $parameters),
      \$queryCursor: \$queryCursor,
    );
  }
''',
        );
      }
    }

    return buffer.toString();
  }

  String _equalAndHashCode(CollectionData data) {
    final propertyNames = [
      'runtimeType',
      'reference',
    ];

    return '''
  @override
  bool operator ==(Object other) {
    return other is ${data.queryReferenceImplName}
      && ${propertyNames.map((p) => 'other.$p == $p').join(' && ')};
  }

  @override
  int get hashCode => Object.hash(${propertyNames.join(', ')});
''';
  }
}

extension on TypeProvider {
  DartType asNullable(DartType type) {
    final typeSystem = nullType.element.library.typeSystem;
    if (typeSystem.isNullable(type)) return type;

    return typeSystem.leastUpperBound(type, nullType);
  }
}
