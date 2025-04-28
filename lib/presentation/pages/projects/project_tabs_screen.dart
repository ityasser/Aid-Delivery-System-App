

import 'package:aid_registry_flutter_app/presentation/pages/projects/live_projects/live_projects_screen.dart';
import 'package:aid_registry_flutter_app/presentation/pages/projects/local_projects/local_projects_screen.dart';
import 'package:flutter/material.dart';

class ProjectTabsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          tabs: [
            Tab(text: "المشاريع المحملة"),
            Tab(text: "المشاريع المتاحة"),
          ],
        ),
        body: TabBarView(

          children: [
            LocalProjectsScreen(), // شاشة المشاريع المحملة
            LiveProjectsScreen(), // شاشة المشاريع المتاحة
          ],
        ),
      ),
    );
  }
}

