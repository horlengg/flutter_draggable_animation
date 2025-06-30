




import 'dart:math';

import 'package:flutter/material.dart';


abstract class DraggableAnimationDisplay {

  final double spacingX;
  final double percentag;
  final bool Function(DraggableAnimationItem dragItem,DraggableAnimationItem item)? compareItemPosition;

  // Constructor to initialize them
  const DraggableAnimationDisplay({
    required this.spacingX,
    required this.percentag,
    this.compareItemPosition
  });

  
  void setLayoutPosition(
    List<DraggableAnimationItem> targetItemList,
    Size layoutSize
  );
  bool compareItemPositionWithPercentag (
    DraggableAnimationItem item, 
    DraggableAnimationItem compareItem,
    {
      ItemOffset? itemOffset
    }
  );
  
}

class DraggableAnimationGridDisplay extends DraggableAnimationDisplay {

  final double columnCount;
  final double spacingY;
  final double rowHeight;

  DraggableAnimationGridDisplay({
    required this.columnCount,
    required this.rowHeight,
    required this.spacingY,
    required double spacingX,
    double percentag = .5,
    bool Function(DraggableAnimationItem dragItem,DraggableAnimationItem item)? compareItemPosition,
  }):super(spacingX: spacingX,percentag :percentag,compareItemPosition:compareItemPosition);

  @override
  void setLayoutPosition(
    List<DraggableAnimationItem> targetItemList,
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
    DraggableAnimationItem item, 
    DraggableAnimationItem compareItem,{
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
class DraggableAnimationRowDisplay extends DraggableAnimationDisplay {

  double colWidth;

  DraggableAnimationRowDisplay({
    required this.colWidth,
    required double spacingX,
    double percentag = .5,
    bool Function(DraggableAnimationItem dragItem,DraggableAnimationItem item)? compareItemPosition,
  }):super(spacingX: spacingX,percentag: percentag,compareItemPosition:compareItemPosition);

  @override
  void setLayoutPosition(
    List<DraggableAnimationItem> targetItemList,
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
    DraggableAnimationItem item, 
    DraggableAnimationItem compareItem,{
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

class DraggableAnimationItem<T> {

  String id;
  double dx;
  double dy;
  double width;
  double height;
  T data;

  DraggableAnimationItem({
    required this.id,
    required this.dx,
    required this.dy,
    required this.width,
    required this.height,
    required this.data,
  });

  DraggableAnimationItem copyWith({
    String? id,
    double? dx,
    double? dy,
    double? width,
    double? height,
  }) {
    return DraggableAnimationItem(
      id : id ?? this.id,
      dx : dx ?? this.dx,
      dy : dy ?? this.dy,
      width : width ?? this.width,
      height : height ?? this.height,
      data : this.data
    );
  }

  static DraggableAnimationItem init<T>(T data){
    return DraggableAnimationItem(
      dx: 0,
      dy: 0,
      id: (100000 + Random().nextInt(900000)).toString(),
      width: 0,
      height: 0,
      data: data
    );
  }

@override
  String toString() {
    return """
        id     : $id, \n,
        dx     : $dx,\n
        dy     : $dy,\n
        width  : $width,\n
        height : $height,\n
        data   : $data,\n
      """;
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
    List<DraggableAnimationItem> menuList,
    DraggableAnimationItem fromMenu,
    DraggableAnimationItem toMenu
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

