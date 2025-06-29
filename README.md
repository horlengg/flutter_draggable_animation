# flutter_animation_draggable

A smooth, customizable drag-and-drop animation library for Flutter — inspired by iOS-style app rearranging. Create interactive menus or reorderable UI elements with ease.


![Demo](https://github.com/horlengg/flutter_draggable_animation/raw/main/demo.gif) <!-- Replace with actual demo if available -->

---


## ✨ Features

- Drag & drop between menu areas
- Animated movement and reordering
- Works with `Stack`, `AnimatedPositioned`, and global coordinate tracking
- Responsive design — works on different screen sizes
- Support for both grid and row layouts

---

## 🚀 Getting Started

### 1. Add dependency

```yaml
dependencies:
  draggable_animation : ^0.0.1

```


## Usage

```dart

SizedBox(
  height: 300,
  width: double.infinity,
  child: DraggaleAnimationMaker(
    items: monthList, 
    displayer: DraggaleAnimationMakerGridDisplay(
      columnCount: 4,
      rowHeight: 80,
      spacingX: 20,
      spacingY: 20
    ),
    // duration: Duration(milliseconds: 100),
    builder: (data) => _buildCard(data), 
    // feedbackBuilder: (data) => _buildCard(data,feedback: true), //custom style
  ),
),

```



## 👤 Contact Me

- GitHub: [horlengg](https://github.com/horlengg/flutter_draggable_animation)
- Portfolio: [horleng.vercel.app](https://horleng.vercel.app/)

Feel free to open issues or pull requests if you'd like to contribute or report bugs.
