
import 'dart:async';

import 'package:draggable_animation/draggable_animation_helper.dart';
import 'package:draggable_animation/screen_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



class DraggableAnimation<T> extends StatefulWidget {

  const DraggableAnimation({
    super.key,
    required this.items,
    required this.displayer,
    required this.builder,
    this.feedbackBuilder,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
    this.clipBehavior = Clip.none,
    this.onChange,
    this.onDragStart,
    this.onDragStop,
    this.onDragMove,
  });

  final Clip clipBehavior;
  final List<T> items;
  final Widget Function(T data) builder;
  final Widget Function(T data)? feedbackBuilder;
  final DraggableAnimationDisplay displayer;
  final Duration duration;
  final Curve curve;
  final Function(T from,T to)? onChange;
  final Function? onDragStart; 
  final Function? onDragStop; 
  final Function(Offset)? onDragMove; 


  @override
  State<DraggableAnimation<T>> createState() => _DraggableAnimationState<T>();
}

class _DraggableAnimationState<T> extends State<DraggableAnimation<T>> {

  List<DraggableAnimationItem> _itemList = [];
  DraggableAnimationItem? _dragItem;
  Size _layoutSize = const Size(0, 0);
  Map<String,GlobalKey> itemKeyMap = {};
  final _scrollController = ScrollController();
  final _itemRowLayout = GlobalKey();
  bool _rowLayoutOnScrolling = false;
  Timer? _rowLayoutOnScrollingTimer;
  bool _isStateLoaded = false;

  void _generateItemList(){
    _itemList = List.generate(
      widget.items.length,
      (index)=> DraggableAnimationItem.init(widget.items[index])
    ).toList();
  }

  @override
  void initState() {
    super.initState();
    _generateItemList();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
      setState(() {
        widget.displayer.setLayoutPosition(_itemList,_layoutSize);
      });
    });
    Timer(const Duration(milliseconds: 500), () { 
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          _isStateLoaded = true;
        });
      });

    });
  }

  ItemOffset getItemOffset(GlobalKey targetKey) {
    final RenderBox box = targetKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = box.localToGlobal(Offset.zero);
    final Size size = box.size;

    return ItemOffset(
      dx: position.dx,
      dy: position.dy,
      width: size.width,
      height: size.height,
    );
  }

  double _itemRowLayoutScrollX(){
    return _scrollController.offset.clamp(0.0,_scrollController.position.maxScrollExtent);
  }

  ItemOffset getItemOffsetWhenDisplayAsRow(DraggableAnimationItem menu){
    double dx = menu.dx - _itemRowLayoutScrollX();
    double dy = menu.dy;
    return ItemOffset(dx: dx, dy: dy, width: menu.width, height: menu.height);
  }


  _handleMoveItem(PointerMoveEvent details){
    if(_dragItem != null){
      bool isGridDisplay = widget.displayer is DraggableAnimationGridDisplay;
      setState(() {
        _dragItem!.dx += details.delta.dx;
        _dragItem!.dy += details.delta.dy;
        if(!isGridDisplay) _maybeAutoScroll(details.position.dx);
        widget.onDragMove?.call(Offset(_dragItem!.dx, _dragItem!.dy));
        if(_rowLayoutOnScrolling) return;
        for(var item in _itemList){
          ItemOffset? itemOffset = isGridDisplay ? null : getItemOffsetWhenDisplayAsRow(item);
          if(item.id == _dragItem!.id) continue;
          if( 
            widget.displayer.compareItemPosition == null ? 
            widget.displayer.compareItemPositionWithPercentag(_dragItem!,item,itemOffset: itemOffset):
            widget.displayer.compareItemPosition!(_dragItem!,item)
          ){
            DraggableAnimationHelper.changeItemPosition(_itemList,_dragItem!,item);
            widget.displayer.setLayoutPosition(_itemList,_layoutSize);
            widget.onChange?.call(_dragItem!.data,item.data);
            break;
          }
        }
      });
      
      
    }
  }

  void _maybeAutoScroll(double globalDx) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localDx = renderBox.globalToLocal(Offset(globalDx, 0)).dx;

    double edgeThreshold = 50;
    double scrollSpeed = 10; 
    var rowLayoutOffset = getItemOffset(_itemRowLayout);
    double dragItemY = _dragItem!.dy + rowLayoutOffset.dy;
    if(
      (dragItemY + _dragItem!.height) < rowLayoutOffset.dy - 50 || 
      dragItemY > (rowLayoutOffset.dy + rowLayoutOffset.height + 50)) 
    {
      return;
    }
    if (localDx < edgeThreshold) {
      if(_scrollController.offset - scrollSpeed > 0){
        _rowLayoutOnScrolling = true;
      }
      _scrollController.jumpTo(
        (_scrollController.offset - scrollSpeed).clamp(0.0,_scrollController.position.maxScrollExtent)
      );
    } else if (localDx > renderBox.size.width - edgeThreshold) {
      if(_scrollController.offset + scrollSpeed < _scrollController.position.maxScrollExtent){
        _rowLayoutOnScrolling = true;
      }
      _scrollController.jumpTo(
        (_scrollController.offset + scrollSpeed).clamp(0.0,_scrollController.position.maxScrollExtent)
      );
    }
    _rowLayoutOnScrollingTimer?.cancel();
    _rowLayoutOnScrollingTimer = Timer(const Duration(milliseconds: 50),(){
      _rowLayoutOnScrolling = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget child;
    Stack content = Stack(
      clipBehavior: Clip.none,
      children: [
        ..._itemList.map((item) => _buildItem(item)).toList(),
        _buildItemDragFeedback()
      ],
    );
    if(widget.displayer is DraggableAnimationGridDisplay){
      child = content;
    }else {
      var lastItem = _itemList.last;
      child = SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        physics : _dragItem == null ? 
          const AlwaysScrollableScrollPhysics() : 
          const NeverScrollableScrollPhysics(),
        child: SizedBox(
          key: _itemRowLayout,
          width: lastItem.dx + lastItem.width,
          child: content
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        _layoutSize = Size(constraints.maxWidth, constraints.maxHeight);
        return ScreenDetector(
          destroy: (){
            if(_dragItem != null){
              widget.onDragStop?.call();
            }
            setState(() {
              _dragItem = null;
            });
          },
          onLongPressAndMove: _handleMoveItem,
          child: child
          
        );
      },
    );
  }
  _buildItem(DraggableAnimationItem item){
    if(itemKeyMap[item.id] == null){
      itemKeyMap[item.id] = GlobalKey();
    }
    return AnimatedPositioned(
      key: itemKeyMap[item.id],
      duration: _isStateLoaded ?  widget.duration : Duration.zero,
      curve: widget.curve,
      left: item.dx,
      top: item.dy,
      child: ScreenDetector(
        onLongPress: (){
          widget.onDragStart?.call();
          setState(() {
            if(widget.displayer is DraggableAnimationGridDisplay){
              _dragItem = item.copyWith();
            }else {
              GlobalKey currentItemKey = itemKeyMap[item.id]!;
              double dx = getItemOffset(currentItemKey).dx;
              final renderBox = context.findRenderObject() as RenderBox;
              final position = renderBox.localToGlobal(Offset.zero);
              _dragItem = item.copyWith(
                dx: dx - position.dx
              );
            }
          });
        },
        child: Container(
          width: item.width,
          height: item.height,
          child: Opacity(
            opacity: _dragItem?.id == item.id ? 0 : 1.0,
            child: widget.builder(item.data),
          ),
        ),
      ),
    );
  }
  double _getFeedbackDragLeft(){
    bool isGridDisplay = widget.displayer is DraggableAnimationGridDisplay;
    return isGridDisplay ? _dragItem!.dx : _itemRowLayoutScrollX() + _dragItem!.dx;
  }
  _buildItemDragFeedback(){
    if(_dragItem == null) return const SizedBox();
    DraggableAnimationItem item = _dragItem!;
    if(itemKeyMap['feedbackitem'] == null){
      itemKeyMap['feedbackitem'] = GlobalKey();
    }
    T data = _itemList.singleWhere((element) => element.id == item.id).data;
    Widget feedbackChild = widget.feedbackBuilder != null ? 
      widget.feedbackBuilder!(data) : 
      Transform.scale(scale: 1.1,child: widget.builder(data));

    return Positioned(
      key: itemKeyMap['feedbackitem'],
      left: _getFeedbackDragLeft(),
      top: item.dy,
      child: Container(
        height: item.height,
        width: item.width,
        child: feedbackChild,
      ),
    );
  }

}