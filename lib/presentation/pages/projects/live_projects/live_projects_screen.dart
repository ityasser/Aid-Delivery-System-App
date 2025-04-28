
import 'package:aid_registry_flutter_app/data/project.dart';
import 'package:aid_registry_flutter_app/databse/objectbox_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../received_aid/screens/aid_notifier.dart';
import '../../../../data/aid.dart';
import '../../../shared/widgets/lists/list_general.dart';
import '../../received_aid/widgets/aid_card.dart';
import '../widgets/live_project_card.dart';
import 'live_projects_notifier.dart';




class LiveProjectsScreen extends ConsumerStatefulWidget {
  @override
  _LiveProjectsScreenState createState() => _LiveProjectsScreenState();
}

class _LiveProjectsScreenState extends ConsumerState<LiveProjectsScreen> {
  late LiveProjectsNotifier liveProjectsNotifier;

  @override
  void initState() {
    super.initState();
    liveProjectsNotifier = ref.read(liveProjectsProvider.notifier);

  }

  @override
  Widget build(BuildContext context) {

    final movies = ref.watch(liveProjectsProvider);

    print("projectBox size: ${ObjectBox.instance.projectBox.getAll().length}");
    print(ObjectBox.instance.projectBox.getAll());
    return Scaffold(
      body: Column(
          children: [ Expanded(
            child: ListGeneral<Project>(
                listNotifier: liveProjectsNotifier,
                isRefresh: true,
                isPagination: false,
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 0),
                onGetRequest: (page) => liveProjectsNotifier.fetchData(page),

                removedItemSelected: ObjectBox.instance.getAllProjects(),
                itemBuilder: (context, index, item, isSelection) {

                  return LiveProjectCard(item: item,onTapDown:
                  // liveProjectsNotifier.isExistProject(item)?null:
                  (){
                    liveProjectsNotifier.downloadProjectAndPerson(item);
                  },onTapExportExcel: (){

                    print("getAllPersonByProject ${liveProjectsNotifier.getAllPersonByProject(item.object_id)}");

                  },onTapUpload: (){
                    ObjectBox.instance.projectBox.removeAll();
                  },);

                }),
          ),]
      ),


    );
  }
}
