// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again
// with `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'data/person_db.dart';
import 'data/project_db.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(6, 723013462078219792),
      name: 'ProjectDB',
      lastPropertyId: const obx_int.IdUid(11, 6822221684237319630),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 5030690011504272877),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 6076133774642361559),
            name: 'title',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 632070789997816637),
            name: 'date',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 2476039305784950818),
            name: 'mobile',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 4951837787484617394),
            name: 'note',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 9084645274850795999),
            name: 'aid_manage_id',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(8, 4674221537219063749),
            name: 'aids_name',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(9, 6655366095482945655),
            name: 'donation_name',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(10, 5354422651691853890),
            name: 'storesName',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(11, 6822221684237319630),
            name: 'printNote',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(7, 6738862773154263558),
      name: 'PersonDB',
      lastPropertyId: const obx_int.IdUid(16, 986629897929784874),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 7959645016539561791),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 3498835287315360555),
            name: 'person_pid',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 8166553950131884083),
            name: 'person_fname',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 8341299905804202444),
            name: 'person_sname',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 4844023172941151545),
            name: 'person_tname',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 7629332696097928660),
            name: 'person_lname',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(8, 1253248612676245441),
            name: 'date',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(9, 2349555345749501290),
            name: 'note',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(10, 295566637404313675),
            name: 'mobile',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(11, 7854513679453983192),
            name: 'isReceived',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(13, 7122670347678872203),
            name: 'aid_person_id',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(14, 1271631955665736632),
            name: 'project_id',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(15, 2033265498118803335),
            name: 'receivedTime',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(16, 986629897929784874),
            name: 'isDeleted',
            type: 1,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [obx.Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [obx.Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
Future<obx.Store> openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) async {
  await loadObjectBoxLibraryAndroidCompat();
  return obx.Store(getObjectBoxModel(),
      directory: directory ?? (await defaultStoreDirectory()).path,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [obx.Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(7, 6738862773154263558),
      lastIndexId: const obx_int.IdUid(2, 2012944541817033430),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [
        8550247194645523042,
        4886333390815913449,
        697006472314670242,
        1170176459278962332,
        2185283274263319088
      ],
      retiredIndexUids: const [2012944541817033430],
      retiredPropertyUids: const [
        952035794831456337,
        4040319850938570250,
        6581831576230033912,
        3271440559555170105,
        5670070714577716926,
        7332832364928125018,
        6443900920592089719,
        4478673955355375209,
        3731580290134610215,
        5611831599444894746,
        5574597372506557955,
        8377502574200941415,
        596280556586623128,
        2798867508630089414,
        1282720377434446370,
        4304372177210199514,
        6551683193096994022,
        9075516979013260338,
        1813077447616990501,
        96699687020868217,
        978274278142573628,
        1028751490922516015,
        4156600497812612413,
        3057351281675566780,
        7205411962771488805,
        3906384783912596579,
        3950542395989832441,
        9024615012183442745,
        1830818561318731463,
        3388295867343397393,
        7194524610019704633,
        6290384723964416840
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    ProjectDB: obx_int.EntityDefinition<ProjectDB>(
        model: _entities[0],
        toOneRelations: (ProjectDB object) => [],
        toManyRelations: (ProjectDB object) => {},
        getId: (ProjectDB object) => object.id,
        setId: (ProjectDB object, int id) {
          object.id = id;
        },
        objectToFB: (ProjectDB object, fb.Builder fbb) {
          final titleOffset =
              object.title == null ? null : fbb.writeString(object.title!);
          final dateOffset =
              object.date == null ? null : fbb.writeString(object.date!);
          final mobileOffset =
              object.mobile == null ? null : fbb.writeString(object.mobile!);
          final noteOffset =
              object.note == null ? null : fbb.writeString(object.note!);
          final aids_nameOffset = object.aids_name == null
              ? null
              : fbb.writeString(object.aids_name!);
          final donation_nameOffset = object.donation_name == null
              ? null
              : fbb.writeString(object.donation_name!);
          final storesNameOffset = object.storesName == null
              ? null
              : fbb.writeString(object.storesName!);
          final printNoteOffset = object.printNote == null
              ? null
              : fbb.writeString(object.printNote!);
          fbb.startTable(12);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, titleOffset);
          fbb.addOffset(2, dateOffset);
          fbb.addOffset(3, mobileOffset);
          fbb.addOffset(4, noteOffset);
          fbb.addInt64(6, object.aid_manage_id);
          fbb.addOffset(7, aids_nameOffset);
          fbb.addOffset(8, donation_nameOffset);
          fbb.addOffset(9, storesNameOffset);
          fbb.addOffset(10, printNoteOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = ProjectDB()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..title = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 6)
            ..date = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 8)
            ..mobile = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 10)
            ..note = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 12)
            ..aid_manage_id =
                const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 16)
            ..aids_name = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 18)
            ..donation_name = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 20)
            ..storesName = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 22)
            ..printNote = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 24);

          return object;
        }),
    PersonDB: obx_int.EntityDefinition<PersonDB>(
        model: _entities[1],
        toOneRelations: (PersonDB object) => [],
        toManyRelations: (PersonDB object) => {},
        getId: (PersonDB object) => object.id,
        setId: (PersonDB object, int id) {
          object.id = id;
        },
        objectToFB: (PersonDB object, fb.Builder fbb) {
          final person_pidOffset = object.person_pid == null
              ? null
              : fbb.writeString(object.person_pid!);
          final person_fnameOffset = object.person_fname == null
              ? null
              : fbb.writeString(object.person_fname!);
          final person_snameOffset = object.person_sname == null
              ? null
              : fbb.writeString(object.person_sname!);
          final person_tnameOffset = object.person_tname == null
              ? null
              : fbb.writeString(object.person_tname!);
          final person_lnameOffset = object.person_lname == null
              ? null
              : fbb.writeString(object.person_lname!);
          final dateOffset =
              object.date == null ? null : fbb.writeString(object.date!);
          final noteOffset =
              object.note == null ? null : fbb.writeString(object.note!);
          final mobileOffset =
              object.mobile == null ? null : fbb.writeString(object.mobile!);
          final receivedTimeOffset = object.receivedTime == null
              ? null
              : fbb.writeString(object.receivedTime!);
          fbb.startTable(17);
          fbb.addInt64(0, object.id);
          fbb.addOffset(2, person_pidOffset);
          fbb.addOffset(3, person_fnameOffset);
          fbb.addOffset(4, person_snameOffset);
          fbb.addOffset(5, person_tnameOffset);
          fbb.addOffset(6, person_lnameOffset);
          fbb.addOffset(7, dateOffset);
          fbb.addOffset(8, noteOffset);
          fbb.addOffset(9, mobileOffset);
          fbb.addBool(10, object.isReceived);
          fbb.addInt64(12, object.aid_person_id);
          fbb.addInt64(13, object.project_id);
          fbb.addOffset(14, receivedTimeOffset);
          fbb.addBool(15, object.isDeleted);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final aid_person_idParam =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 28);
          final object = PersonDB(aid_person_id: aid_person_idParam)
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..person_pid = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 8)
            ..person_fname = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 10)
            ..person_sname = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 12)
            ..person_tname = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 14)
            ..person_lname = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 16)
            ..date = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 18)
            ..note = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 20)
            ..mobile = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 22)
            ..isReceived =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 24, false)
            ..project_id =
                const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 30)
            ..receivedTime = const fb.StringReader(asciiOptimization: true)
                .vTableGetNullable(buffer, rootOffset, 32)
            ..isDeleted =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 34, false);

          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [ProjectDB] entity fields to define ObjectBox queries.
class ProjectDB_ {
  /// See [ProjectDB.id].
  static final id =
      obx.QueryIntegerProperty<ProjectDB>(_entities[0].properties[0]);

  /// See [ProjectDB.title].
  static final title =
      obx.QueryStringProperty<ProjectDB>(_entities[0].properties[1]);

  /// See [ProjectDB.date].
  static final date =
      obx.QueryStringProperty<ProjectDB>(_entities[0].properties[2]);

  /// See [ProjectDB.mobile].
  static final mobile =
      obx.QueryStringProperty<ProjectDB>(_entities[0].properties[3]);

  /// See [ProjectDB.note].
  static final note =
      obx.QueryStringProperty<ProjectDB>(_entities[0].properties[4]);

  /// See [ProjectDB.aid_manage_id].
  static final aid_manage_id =
      obx.QueryIntegerProperty<ProjectDB>(_entities[0].properties[5]);

  /// See [ProjectDB.aids_name].
  static final aids_name =
      obx.QueryStringProperty<ProjectDB>(_entities[0].properties[6]);

  /// See [ProjectDB.donation_name].
  static final donation_name =
      obx.QueryStringProperty<ProjectDB>(_entities[0].properties[7]);

  /// See [ProjectDB.storesName].
  static final storesName =
      obx.QueryStringProperty<ProjectDB>(_entities[0].properties[8]);

  /// See [ProjectDB.printNote].
  static final printNote =
      obx.QueryStringProperty<ProjectDB>(_entities[0].properties[9]);
}

/// [PersonDB] entity fields to define ObjectBox queries.
class PersonDB_ {
  /// See [PersonDB.id].
  static final id =
      obx.QueryIntegerProperty<PersonDB>(_entities[1].properties[0]);

  /// See [PersonDB.person_pid].
  static final person_pid =
      obx.QueryStringProperty<PersonDB>(_entities[1].properties[1]);

  /// See [PersonDB.person_fname].
  static final person_fname =
      obx.QueryStringProperty<PersonDB>(_entities[1].properties[2]);

  /// See [PersonDB.person_sname].
  static final person_sname =
      obx.QueryStringProperty<PersonDB>(_entities[1].properties[3]);

  /// See [PersonDB.person_tname].
  static final person_tname =
      obx.QueryStringProperty<PersonDB>(_entities[1].properties[4]);

  /// See [PersonDB.person_lname].
  static final person_lname =
      obx.QueryStringProperty<PersonDB>(_entities[1].properties[5]);

  /// See [PersonDB.date].
  static final date =
      obx.QueryStringProperty<PersonDB>(_entities[1].properties[6]);

  /// See [PersonDB.note].
  static final note =
      obx.QueryStringProperty<PersonDB>(_entities[1].properties[7]);

  /// See [PersonDB.mobile].
  static final mobile =
      obx.QueryStringProperty<PersonDB>(_entities[1].properties[8]);

  /// See [PersonDB.isReceived].
  static final isReceived =
      obx.QueryBooleanProperty<PersonDB>(_entities[1].properties[9]);

  /// See [PersonDB.aid_person_id].
  static final aid_person_id =
      obx.QueryIntegerProperty<PersonDB>(_entities[1].properties[10]);

  /// See [PersonDB.project_id].
  static final project_id =
      obx.QueryIntegerProperty<PersonDB>(_entities[1].properties[11]);

  /// See [PersonDB.receivedTime].
  static final receivedTime =
      obx.QueryStringProperty<PersonDB>(_entities[1].properties[12]);

  /// See [PersonDB.isDeleted].
  static final isDeleted =
      obx.QueryBooleanProperty<PersonDB>(_entities[1].properties[13]);
}
