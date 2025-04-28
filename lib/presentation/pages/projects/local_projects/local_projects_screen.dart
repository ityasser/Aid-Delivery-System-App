
import 'package:aid_registry_flutter_app/core/utils/dialog_service.dart';
import 'package:aid_registry_flutter_app/data/project.dart';
import 'package:aid_registry_flutter_app/databse/objectbox_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../received_aid/screens/aid_notifier.dart';
import '../../../../core/app.dart';
import '../../../../data/aid.dart';
import '../../../shared/widgets/lists/list_general.dart';
import '../../received_aid/screens/received_aid_page.dart';
import '../../received_aid/widgets/aid_card.dart';
import '../widgets/local_project_card.dart';
import '../widgets/live_project_card.dart';
import 'local_projects_notifier.dart';




class LocalProjectsScreen extends ConsumerStatefulWidget {
  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends ConsumerState<LocalProjectsScreen> {
  late LocalProjectsNotifier localProjectsNotifier;

  @override
  void initState() {
    super.initState();
    localProjectsNotifier = ref.read(localProjectsProvider.notifier);

  }

  @override
  Widget build(BuildContext context) {

    final movies = ref.watch(localProjectsProvider);

    return Scaffold(
      body: Column(
          children: [ Expanded(
            child: ListGeneral<Project>(
                listNotifier: localProjectsNotifier,
                isRefresh: true,
                isPagination: true,
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 0),
                onGetRequest: (page) => localProjectsNotifier.fetchData(page),

                itemBuilder: (context, index, item, isSelection) {
                  return LocalProjectCard(item: item,
                    countReceived: localProjectsNotifier.getCountReceived(item),countNonReceived: localProjectsNotifier.getCountNonReceived(item),
                    onTapRemove: () async{
                    // ObjectBox.instance.personBox.removeAll();
                    // ObjectBox.instance.projectBox.removeAll();
                   await DialogService.showMessageDialog(title: "حذف المشروع",description: "حذف هذا المشروع يؤدي الى حذف بيانات المستفدين \n هل تريد بالتأكيد الاستمرار في الحذف؟",
                   btnOkOnPress: (n){
                     localProjectsNotifier.deleteProjectWithPersons(item);
                   });

                  },onTapExportExcelNotReceived: (){
                    localProjectsNotifier.exportPersonsToExcelNotReceived(item);
                  },onTapUpdate: (){
                    localProjectsNotifier.onTapUpdate(item);
                  },onTapExportReceivedPdf: (){
                    localProjectsNotifier.exportReceivedPdf(item);
                  },onTapExportNonReceivedPdf: (){
                    localProjectsNotifier.exportNonReceivedPdf(item);
                  },
                 onTapExportExcel: (){
                    localProjectsNotifier.exportPersonsToExcel(item);
                  //  localProjectsNotifier.printPersons(item.object_id);
                  //   print("getAllPersonByProject ${item.persons}");
                   // print("getAllPersonByProject ${ ObjectBox.instance.personBox.getAll()}");
                   // print("getAllPersonByProject ${ObjectBox.instance.getPersonsByProjectAndReceived(item.object_id!)}");

                  },
                    // onTapUpload: (){
                   /* DialogService.showMessageDialog(title: "رفع المشروع",description: "رفع هذا المشروع يؤدي الى حذف المشروع وبيانات المستفدين \n هل تريد بالتأكيد الاستمرار في رفع المشروع؟",
                    btnOkOnPress: (note){
                      localProjectsNotifier.uploadProjectWithPersons(item);
                    });*/
                  // },
                    onTap: (){
                    localProjectsNotifier.push(App.context, screen: ReceivedAidScreen(item: item,));;
                  },);

                }),
          ),]
      ),


    );
  }
}
