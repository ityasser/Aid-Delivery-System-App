import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/identifiable.dart';
import '../../../../core/models/loading_status.dart';
import '../../../../core/web_services/BaseResponseList.dart';
import '../statuses/empty_widgets.dart';
import '../statuses/error_widget.dart';
import '../statuses/no_internet_widget.dart';
import '../statuses/shimmer_widget.dart';
import '../statuses/un_auth_widget.dart';
import 'list_notifier.dart';

typedef OnGetRequest<T> = Future<BaseResponseList<T>?> Function(int);
enum ListType { list, grid }

enum LoadMoreType { listener, notification }

enum SelectionType { none, single, multi, toggle }


class ListGeneral<T extends Identifiable> extends ConsumerStatefulWidget {
  String? tag;
  Widget Function(BuildContext, int, T, bool)? itemBuilder;
  Widget Function(BuildContext, int, T)? separatorBuilder;
  OnGetRequest<T>? onGetRequest;
  Function(ListNotifier<T>?)? onGetListController;
  ScrollController? scrollController;
  SliverGridDelegate? gridDelegate;
  ListType listType;
  LoadMoreType loadMoreType;
  bool isPagination;
  bool isSort;
  bool isRefresh;
  Axis scrollDirection;
  Widget? loadingWidget;
  Widget? emptyWidget;
  List<T>? listItem;
  List<T>? listItemSelected;
  List<T>? removedItemSelected;
  EdgeInsetsGeometry? padding;
  SelectionType selectionType;
  bool shrinkWrap;
  ScrollPhysics? physics;

  ListNotifier<T> listNotifier;
  ListGeneral({
    required this.listNotifier,
    this.tag,
    this.scrollController,
    this.listItem,
    this.listItemSelected,
    this.removedItemSelected,
    this.listType = ListType.list,
    this.loadMoreType = LoadMoreType.listener,
    this.selectionType = SelectionType.none,
    this.padding,
    this.isPagination = false,
    this.isRefresh = false,
    this.isSort = false,
    this.shrinkWrap = false,
    this.onGetRequest,
    this.itemBuilder,
    this.separatorBuilder,
    this.onGetListController,
    this.gridDelegate,
    this.loadingWidget,
    this.emptyWidget,
    this.physics,
    this.scrollDirection = Axis.vertical,
  });

  @override
  _ListGeneralState<T> createState() => _ListGeneralState<T>();
}

class _ListGeneralState<T extends Identifiable> extends ConsumerState<ListGeneral<T>> {



  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) =>widget.listNotifier. addPostFrameCallback(context));

    widget.listNotifier.onGetRequest = widget.onGetRequest;
    widget.listNotifier.selectionType = widget.selectionType;
    widget.listNotifier.isSort = widget.isSort;
    print(" widget.removedItemSelected ${ widget.removedItemSelected?.length}");

    widget.listNotifier.listItemSelected = widget.listItemSelected ?? widget.listNotifier.listItemSelected;
    print("listItemSelected ${ widget.listNotifier.listItemSelected}");
    widget.listNotifier.removedItemSelected = widget.removedItemSelected ?? widget.listNotifier.removedItemSelected;

    if (widget.scrollController == null && widget.isPagination && widget.loadMoreType == LoadMoreType.listener) {
      widget.scrollController = ScrollController();
      print("inil  scrollController");

    }

    print("start  scrollController ${widget.isPagination}  ${widget.loadMoreType}  ${(widget.isPagination && widget.loadMoreType == LoadMoreType.listener)}");

    if (widget.isPagination && widget.loadMoreType == LoadMoreType.listener) {
      print("start  scrollController scrollController is ${widget.scrollController == null}");
      widget.scrollController ??= ScrollController();
      widget.scrollController!.addListener(_scrollListener);
    }

    if (widget.onGetListController != null)
      widget.onGetListController!(widget.listNotifier);

    if((widget.listItem?.isNotEmpty??false)&&widget.selectionType!=SelectionType.none)
      widget.listNotifier.originItems=widget.listItem??[];

    //widget.listNotifier.init();
    Future(() {
      widget.listNotifier.state = widget.listItem ?? widget.listNotifier.state;

      widget.listNotifier.init();

    });
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      //  color: CustomColors.mainColor,
        child: widget.isRefresh
            ? RefreshIndicator(
            key: widget.listNotifier.refreshKey,
            onRefresh: widget.listNotifier.indicatorRefresh,
            child: getView())
            : Container(
            alignment: Alignment.center, child: getView()));


  }

  Widget getListWidget(ListNotifier<T> listState) {
    return widget.listType == ListType.list
        ? ListView.separated(
      shrinkWrap: widget.shrinkWrap,

      controller: widget.scrollController,
      physics:widget. physics,
      padding: widget.padding,
      itemCount: widget.listNotifier.state.length,
      itemBuilder:(context, index) => updateItemBuilder(
        context,
        index,
      ),

      separatorBuilder: separatorBuilder,
    )
        : GridView.builder(
      shrinkWrap: widget.shrinkWrap,
      controller: widget.scrollController,
      physics:widget. physics,
      padding: widget.padding,
      gridDelegate: widget.gridDelegate ??
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 12,
          ),
      itemCount: widget.listNotifier.state.length,
      itemBuilder: (context, index) => updateItemBuilder(
        context,
        index,
      )
      ,
    );
  }
  Widget separatorBuilder(BuildContext context, int index) {
    return widget.separatorBuilder != null
        ? widget.separatorBuilder!(context, index, widget.listNotifier.state[index])
        : SizedBox.shrink();
  }

  Widget updateItemBuilder(BuildContext context, int index) {
    bool length2 = widget.listNotifier.state.length < 12;
    if (length2) {
      return widget.itemBuilder!(
        context,
        index,
        widget.listNotifier.state[index], widget.selectionType != SelectionType.none
          ? widget.listNotifier.listItemSelected.any((item) => item.object_id == widget.listNotifier.state[index].object_id)
          : false,
      );
    } else {
      if (index == widget.listNotifier.state.length - 1 &&
          widget.listNotifier.isMoreDataAvailable == true &&
          widget.isPagination) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return widget.itemBuilder!(
            context,
            index,
            widget.listNotifier.state[index],
            widget.selectionType != SelectionType.none
                ? widget.listNotifier.listItemSelected.any((item) => item.object_id == widget.listNotifier.state[index].object_id)
                : false);
      }
    }
  }


  bool _onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels >= notification.metrics.maxScrollExtent &&
          !notification.metrics.outOfRange) {
        widget.listNotifier.page++;
        print("_onNotification");
        widget.listNotifier.getData();
        return true;
      }
    }
    return false;
  }

  void _scrollListener() async {
    print("scrollController 1");

    if (widget.scrollController!.offset >= widget.scrollController!.position.maxScrollExtent &&
        !widget.scrollController!.position.outOfRange) {
      print("scrollController 2");

      if (widget.listNotifier.isMoreDataAvailable && widget.isPagination) {
        widget.listNotifier.page++;
        print("scrollController getData");

        widget.listNotifier.getData();
      }
    }
  }

  Widget getView() {

    print("getView status is ${widget.listNotifier.status}");
    switch (widget.listNotifier.status) {
      case LoadingStatus.loading:

        return widget.loadingWidget??
            Container(
                alignment: Alignment.center,
                child: const Center(
                  child: ShimmerWidget(),
                ));
      case LoadingStatus.unauthenticated:
        return UnAuthWidget();
      case LoadingStatus.newWorkError:
        return NoInternetWidget(onPressed: widget.listNotifier.refreshList,);
      case LoadingStatus.error:
        return ErrorWidgets(error: widget.listNotifier.error,onPressed: widget.listNotifier.refreshList);
      case LoadingStatus.empty:
        return widget.emptyWidget ??  CustomScrollView(
          slivers: <Widget>[
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(

                alignment: Alignment.center,
                child:  Center(
                  child: EmptyWidgets(),
                ),
              ),
            ),
          ],
        );
      case LoadingStatus.refreshing:
        return const CircularProgressIndicator();
      case LoadingStatus.completed:
        return (widget.isPagination && widget.loadMoreType == LoadMoreType.notification)
            ? NotificationListener<ScrollNotification>(
          onNotification: _onNotification,
          child: getListWidget(widget.listNotifier),
        )
            : getListWidget(widget.listNotifier);
      default:
        return const Center(child:  CircularProgressIndicator());
    }
  }


}
