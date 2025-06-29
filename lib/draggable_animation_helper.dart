




import 'dart:math';

import 'package:flutter/material.dart';


abstract class DraggaleAnimationMakerDisplay {

  final double spacingX;
  final double percentag;

  // Constructor to initialize them
  const DraggaleAnimationMakerDisplay({
    required this.spacingX,
    required this.percentag
  });

  
  void setLayoutPosition(
    List<DraggableAnimationMakerItem> targetItemList,
    Size layoutSize
  );
  bool compareItemPositionWithPercentag (
    DraggableAnimationMakerItem item, 
    DraggableAnimationMakerItem compareItem,
    {
      ItemOffset? itemOffset
    }
  );
}

class DraggaleAnimationMakerGridDisplay extends DraggaleAnimationMakerDisplay {

  final double columnCount;
  final double spacingY;
  final double rowHeight;

  DraggaleAnimationMakerGridDisplay({
    required this.columnCount,
    required this.rowHeight,
    required this.spacingY,
    required double spacingX,
    double percentag = .5,
  }):super(spacingX: spacingX,percentag :percentag);

  @override
  void setLayoutPosition(
    List<DraggableAnimationMakerItem> targetItemList,
    Size layoutSize
  ){
    final itemWidth = (layoutSize.width - spacingX * (columnCount -1) ) / columnCount ;

    double rowCount = 0;
    double colCount = 0;
    int index = 0;
    for(var item in targetItemList){
      if(index % columnCount == 0) {
        if(index != 0 ) rowCount++;
        colCount = 0;
      }else {
        colCount++;
      }
      double top = rowCount * (rowHeight + spacingY);
      double left = colCount * (itemWidth + spacingX);

      index++;

      item.width = itemWidth;
      item.height = rowHeight;
      item.dx = left;
      item.dy = top;
      
    }

  }

  @override
  bool compareItemPositionWithPercentag(
    DraggableAnimationMakerItem item, 
    DraggableAnimationMakerItem compareItem,{
      ItemOffset? itemOffset
    }
  ) {
    double dx = 0;
    double dy = 0;
    dx = (item.dx - compareItem.dx).abs();
    dy = (item.dy - compareItem.dy).abs();
    final thresholdX = percentag * 100;
    final thresholdY = percentag * 100;
    return dx <= thresholdX && dy <= thresholdY;
  }


}
class DraggaleAnimationMakerRowDisplay extends DraggaleAnimationMakerDisplay {

  double colWidth;

  DraggaleAnimationMakerRowDisplay({
    required this.colWidth,
    required double spacingX,
    double percentag = .5,
  }):super(spacingX: spacingX,percentag: percentag);

  @override
  void setLayoutPosition(
    List<DraggableAnimationMakerItem> targetItemList,
    Size layoutSize
  ){
    double colCounter = 0;
    for(var item in targetItemList){
      double left = colCounter * (colWidth + spacingX);
      item.width = colWidth;
      item.height = layoutSize.height;
      item.dx = left;
      colCounter++;
    }

  }

  @override
  bool compareItemPositionWithPercentag(
    DraggableAnimationMakerItem item, 
    DraggableAnimationMakerItem compareItem,{
      ItemOffset? itemOffset 
    }
  ) {
    if(itemOffset == null) return false;
    double dx = 0;
    double dy = 0;
    dx = (item.dx - itemOffset.dx).abs();
    dy = (item.dy - itemOffset.dy).abs();
    final thresholdX = percentag * 100;
    final thresholdY = percentag * 100;
    return dx <= thresholdX && dy <= thresholdY;
  }

}

class DraggableAnimationMakerItem<T> {

  String id;
  double dx;
  double dy;
  double width;
  double height;
  T data;

  DraggableAnimationMakerItem({
    required this.id,
    required this.dx,
    required this.dy,
    required this.width,
    required this.height,
    required this.data,
  });

  DraggableAnimationMakerItem copyWith({
    String? id,
    double? dx,
    double? dy,
    double? width,
    double? height,
  }) {
    return DraggableAnimationMakerItem(
      id : id ?? this.id,
      dx : dx ?? this.dx,
      dy : dy ?? this.dy,
      width : width ?? this.width,
      height : height ?? this.height,
      data : this.data
    );
  }

  static DraggableAnimationMakerItem init<T>(T data){
    return DraggableAnimationMakerItem(
      dx: 0,
      dy: 0,
      id: (100000 + Random().nextInt(900000)).toString(),
      width: 0,
      height: 0,
      data: data
    );
  }


}
class ItemOffset {
  double width;
  double height;
  double dy;
  double dx;
  ItemOffset({
    required this.dx,
    required this.dy,
    required this.width,
    required this.height,
  });
  
}

class DraggableAnimationHelper {


  static void changeItemPosition(
    List<DraggableAnimationMakerItem> menuList,
    DraggableAnimationMakerItem fromMenu,
    DraggableAnimationMakerItem toMenu
  ){
    int fromIndex = menuList.indexWhere((e) => e.id == fromMenu.id);
    int toIndex = menuList.indexWhere((e) => e.id == toMenu.id);
    if (fromIndex == -1 || toIndex == -1) {
      print('One or both items not found in the list.');
      return;
    }
    var removedItem = menuList.removeAt(fromIndex);
    menuList.insert(toIndex, removedItem);
  }
}

