import 'dart:convert';
import 'package:aid_registry_flutter_app/core/utils/dialog_service.dart';
import 'package:aid_registry_flutter_app/core/utils/helpers.dart';
import 'package:aid_registry_flutter_app/core/web_services/BaseResponseList.dart';
import 'package:aid_registry_flutter_app/data/person.dart';
import 'package:aid_registry_flutter_app/data/project.dart';
import 'package:aid_registry_flutter_app/data/project_db.dart';
import 'package:aid_registry_flutter_app/databse/objectbox_database.dart';
import 'package:aid_registry_flutter_app/databse/sync_service.dart';
import 'package:aid_registry_flutter_app/objectbox.g.dart';
import 'package:aid_registry_flutter_app/presentation/shared/widgets/lists/list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/web_services/apis.dart';

class ListAidNotifier extends ListNotifier<Project>
    with DialogService, Helpers {
  Ref ref;

  ListAidNotifier(this.ref) : super();

}

final listAidProvider =
    StateNotifierProvider<ListAidNotifier, List<Project>>(
      (ref) => ListAidNotifier(ref),
    );
