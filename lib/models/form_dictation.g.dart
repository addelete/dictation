// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_dictation.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFormDictationCollection on Isar {
  IsarCollection<FormDictation> get formDictations => this.collection();
}

const FormDictationSchema = CollectionSchema(
  name: r'FormDictation',
  id: 8482205797898189663,
  properties: {
    r'autoInterval': PropertySchema(
      id: 0,
      name: r'autoInterval',
      type: IsarType.long,
    ),
    r'autoRepeatCount': PropertySchema(
      id: 1,
      name: r'autoRepeatCount',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 3,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'words': PropertySchema(
      id: 4,
      name: r'words',
      type: IsarType.objectList,
      target: r'WordItem',
    )
  },
  estimateSize: _formDictationEstimateSize,
  serialize: _formDictationSerialize,
  deserialize: _formDictationDeserialize,
  deserializeProp: _formDictationDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'WordItem': WordItemSchema},
  getId: _formDictationGetId,
  getLinks: _formDictationGetLinks,
  attach: _formDictationAttach,
  version: '3.1.0+1',
);

int _formDictationEstimateSize(
  FormDictation object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.words;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[WordItem]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += WordItemSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  return bytesCount;
}

void _formDictationSerialize(
  FormDictation object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.autoInterval);
  writer.writeLong(offsets[1], object.autoRepeatCount);
  writer.writeString(offsets[2], object.name);
  writer.writeDateTime(offsets[3], object.updatedAt);
  writer.writeObjectList<WordItem>(
    offsets[4],
    allOffsets,
    WordItemSchema.serialize,
    object.words,
  );
}

FormDictation _formDictationDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FormDictation();
  object.autoInterval = reader.readLongOrNull(offsets[0]);
  object.autoRepeatCount = reader.readLongOrNull(offsets[1]);
  object.id = id;
  object.name = reader.readStringOrNull(offsets[2]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[3]);
  object.words = reader.readObjectList<WordItem>(
    offsets[4],
    WordItemSchema.deserialize,
    allOffsets,
    WordItem(),
  );
  return object;
}

P _formDictationDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readObjectList<WordItem>(
        offset,
        WordItemSchema.deserialize,
        allOffsets,
        WordItem(),
      )) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _formDictationGetId(FormDictation object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _formDictationGetLinks(FormDictation object) {
  return [];
}

void _formDictationAttach(
    IsarCollection<dynamic> col, Id id, FormDictation object) {
  object.id = id;
}

extension FormDictationQueryWhereSort
    on QueryBuilder<FormDictation, FormDictation, QWhere> {
  QueryBuilder<FormDictation, FormDictation, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FormDictationQueryWhere
    on QueryBuilder<FormDictation, FormDictation, QWhereClause> {
  QueryBuilder<FormDictation, FormDictation, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FormDictationQueryFilter
    on QueryBuilder<FormDictation, FormDictation, QFilterCondition> {
  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      autoIntervalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'autoInterval',
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      autoIntervalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'autoInterval',
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      autoIntervalEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoInterval',
        value: value,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      autoIntervalGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'autoInterval',
        value: value,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      autoIntervalLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'autoInterval',
        value: value,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      autoIntervalBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'autoInterval',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      autoRepeatCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'autoRepeatCount',
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      autoRepeatCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'autoRepeatCount',
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      autoRepeatCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoRepeatCount',
        value: value,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      autoRepeatCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'autoRepeatCount',
        value: value,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      autoRepeatCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'autoRepeatCount',
        value: value,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      autoRepeatCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'autoRepeatCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      wordsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'words',
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      wordsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'words',
      ));
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      wordsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'words',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      wordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'words',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      wordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'words',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      wordsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'words',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      wordsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'words',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      wordsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'words',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension FormDictationQueryObject
    on QueryBuilder<FormDictation, FormDictation, QFilterCondition> {
  QueryBuilder<FormDictation, FormDictation, QAfterFilterCondition>
      wordsElement(FilterQuery<WordItem> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'words');
    });
  }
}

extension FormDictationQueryLinks
    on QueryBuilder<FormDictation, FormDictation, QFilterCondition> {}

extension FormDictationQuerySortBy
    on QueryBuilder<FormDictation, FormDictation, QSortBy> {
  QueryBuilder<FormDictation, FormDictation, QAfterSortBy>
      sortByAutoInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoInterval', Sort.asc);
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterSortBy>
      sortByAutoIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoInterval', Sort.desc);
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterSortBy>
      sortByAutoRepeatCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoRepeatCount', Sort.asc);
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterSortBy>
      sortByAutoRepeatCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoRepeatCount', Sort.desc);
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension FormDictationQuerySortThenBy
    on QueryBuilder<FormDictation, FormDictation, QSortThenBy> {
  QueryBuilder<FormDictation, FormDictation, QAfterSortBy>
      thenByAutoInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoInterval', Sort.asc);
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterSortBy>
      thenByAutoIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoInterval', Sort.desc);
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterSortBy>
      thenByAutoRepeatCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoRepeatCount', Sort.asc);
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterSortBy>
      thenByAutoRepeatCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoRepeatCount', Sort.desc);
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<FormDictation, FormDictation, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension FormDictationQueryWhereDistinct
    on QueryBuilder<FormDictation, FormDictation, QDistinct> {
  QueryBuilder<FormDictation, FormDictation, QDistinct>
      distinctByAutoInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoInterval');
    });
  }

  QueryBuilder<FormDictation, FormDictation, QDistinct>
      distinctByAutoRepeatCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoRepeatCount');
    });
  }

  QueryBuilder<FormDictation, FormDictation, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FormDictation, FormDictation, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension FormDictationQueryProperty
    on QueryBuilder<FormDictation, FormDictation, QQueryProperty> {
  QueryBuilder<FormDictation, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FormDictation, int?, QQueryOperations> autoIntervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoInterval');
    });
  }

  QueryBuilder<FormDictation, int?, QQueryOperations>
      autoRepeatCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoRepeatCount');
    });
  }

  QueryBuilder<FormDictation, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<FormDictation, DateTime?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<FormDictation, List<WordItem>?, QQueryOperations>
      wordsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'words');
    });
  }
}
