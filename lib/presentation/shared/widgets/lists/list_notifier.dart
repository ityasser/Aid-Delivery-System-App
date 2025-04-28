import 'package:aid_registry_flutter_app/core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/identifiable.dart';
import '../../../../core/models/loading_status.dart';
import '../../../../core/web_services/BaseResponseList.dart';
import 'list_general.dart';


class ListNotifier<T extends Identifiable> extends StateNotifier<List<T>> {
  ListNotifier() : super([]);
  Future<BaseResponseList<T>?> Function(int)? onGetRequest;

  final GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey<RefreshIndicatorState>();

  var status = LoadingStatus.loading;
  var isMoreDataAvailable = true;
  bool isSort = true;
  bool isLoadScreen = false;
  SelectionType selectionType = SelectionType.none;
  List<T> originItems = [];
  List<T> listItemSelected = [];
  List<T> removedItemSelected = [];
  String? error ;
  int page = 1;

  Future<void> init() async {
    if (state.isNotEmpty) {
      if (selectionType != SelectionType.none) {
        if (state.length < originItems.length) {
          state = List.from(originItems);
        }
        if (isSort) sortItemsBySelection();
      }
      print("List isNotEmpty ");
      status = LoadingStatus.completed;

        state = [...state];
        print("status: ${status}");


    } else {
      await getData();
    }
  }
  Future<void> indicatorRefresh() async {
    page = 1;
    refreshKey.currentState?.show();
    print("pullToRefreshc");

    if(isLoadScreen)
      await getData();
  }
  void searchFromList(String query) {
    if (query.isEmpty) {
      state = List.from(originItems);
    } else {
      state = originItems
          .where((i) => i.toString().toLowerCase().contains(query.toLowerCase()) || i.toString().toLowerCase().endsWith(query.toLowerCase()))
          .toList();
    }

    status = state.isEmpty ? LoadingStatus.empty : LoadingStatus.completed;
  }

  Future<void> refreshList() async {
    page = 1;
    refreshKey.currentState?.show();
    if (isLoadScreen) await getData();
  }
  Future<void> reGetList() async {
    page = 1;
    if (isLoadScreen) await getData();
  }

  Future<void> getData() async {
    if (onGetRequest != null) {
      final response = await onGetRequest!(page);
      if (response != null && response.status==true) {
        if (page == 1) {
          state.clear();
        }
        state = [...state, ...response.data ?? []];
        if (isSort) sortItemsBySelection();
        print("removedItemSelected.isNotEmpty ${removedItemSelected.isNotEmpty}");
        if(removedItemSelected.isNotEmpty){
          for (int i = 0; i < removedItemSelected.length; i++) {
            print("id");
            print(removedItemSelected[i].object_id);
          }
          state = state.where((element) => !removedItemSelected.any((el) => el.object_id == element.object_id)).toList();
        }
        if (state.isNotEmpty) {
          status = LoadingStatus.completed;
        } else {
          status = LoadingStatus.empty;
        }
        originItems = List.from(state);
      } else {
        if (response?.code == 500) {
          status = LoadingStatus.newWorkError;
        } else if (response?.code == 401 || response?.code == 203) {
          status = LoadingStatus.unauthenticated;
        } else {
          status = LoadingStatus.error;
          error = response?.message?? "Response Error";;
        }
      }
    } else {
      status = state.isEmpty ? LoadingStatus.empty : LoadingStatus.completed;
    }
  state = [...state];
    print("status: ${status}");
  }

  updateView() {
    if (isSort) sortItemsBySelection();
    if(removedItemSelected.isNotEmpty){
      state = state.where((element) => !removedItemSelected.any((el) => el.object_id == element.object_id)).toList();
    }
    status = state.isEmpty ? LoadingStatus.empty : LoadingStatus.completed;

    state = [...state];
  }
  void updateItem(T updatedT) {
    state = state.map((item) => item.object_id == updatedT.object_id ? updatedT : item).toList();
  }


  void addItem(T item) {
    if (!state.any((element) => element.object_id == item.object_id)) {
      state = [...state, item];
    }
  }

  void removeItem(T item) {
    state = state.where((element) => element.object_id != item.object_id).toList();
  }

  void sortItemsBySelection() {
    state.sort((a, b) => listItemSelected.any((el) => el.object_id == b.object_id) ? 1 : -1);
  }

  addPostFrameCallback(BuildContext context) {
    isLoadScreen=true;
  }


void addIdSelected(int? id) {

  T? it=state.firstWhere((element) =>element.id==id);
  if(it!=null){
    listItemSelected.add(it);
    state = [...state];
  }
}
void addItemsSelected(List<T> list) {
  listItemSelected.addAll(list);
  state = [...state];
}

void updateSelectionItem(bool isSelected, T item, int index) {
  switch (selectionType) {
    case SelectionType.single:
      bool oldStatus = !isSelected;
      if (oldStatus) {
        listItemSelected.clear();
      } else {
        listItemSelected.clear();
        listItemSelected.add(item);
      }
      state = [...state];
      break;
    case SelectionType.multi:
      if (isSelected && (listItemSelected.indexOf(item) == -1)) {
        if (index != -1) {
          if(isSort)
            state.insert(listItemSelected.length, state.removeAt(index));
          listItemSelected.add(item);
        }
      } else {
        listItemSelected.remove(item);
        if(isSort)
          state.insert(listItemSelected.length, state.removeAt(index));
      }
      state = [...state];
      break;
    case SelectionType.toggle:
      listItemSelected.clear();
      listItemSelected.add(item);
      state = [...state];
      break;
    case SelectionType.none:
      print("none");
      break;
  }
}

List<T> getListSelections() {
  return listItemSelected;
}



}
/*final listProviderc = StateNotifierProvider<ListNotifier<Identifiable>, List<Identifiable>>(
      (ref) => ListNotifier(null),
);*/