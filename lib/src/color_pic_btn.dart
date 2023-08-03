import 'package:flutter/material.dart';

import 'drawing_controller.dart';
import 'helper/color_pic.dart';
import 'helper/ex_value_builder.dart';

/// 选择颜色按钮
class ColorPicBtn extends StatelessWidget {
  const ColorPicBtn({
    Key? key,
    this.builder,
    this.decoration,
    this.colorPickerBuilder,
    this.closeAfterPicked = false,
    required this.controller,
  }) : super(key: key);

  final Widget Function(Color color)? builder;
  final ColorPickerBuilder? colorPickerBuilder;
  final DrawingController controller;
  final BoxDecoration? decoration;
  final bool closeAfterPicked;

  /// 选择颜色
  Future<void> _pickColor(BuildContext context) async {
    final Color? newColor = await showModalBottomSheet<Color?>(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      builder: (_) => ColorPic(
        nowColor: controller.getColor,
        builder: colorPickerBuilder,
        closeAfterPicked: closeAfterPicked,
      ),
    );

    if (newColor == null) {
      return;
    }

    if (newColor != controller.getColor) {
      controller.setStyle(color: newColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickColor(context),
      child: ExValueBuilder<DrawConfig>(
        valueListenable: controller.drawConfig,
        shouldRebuild: (DrawConfig p, DrawConfig n) => p.color != n.color,
        builder: (_, DrawConfig dc, __) =>
            builder?.call(dc.color) ??
            Container(
              decoration: (decoration ?? const BoxDecoration()).copyWith(
                color: dc.color,
              ),
              width: 24,
              height: 24,
            ),
      ),
    );
  }
}
