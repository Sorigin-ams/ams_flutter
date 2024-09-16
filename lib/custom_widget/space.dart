import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Space extends LeafRenderObjectWidget {
  final double mainAxisExtent;

  const Space(this.mainAxisExtent, {super.key}) : assert(mainAxisExtent >= 0 && mainAxisExtent <= double.infinity);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSpace(mainAxisExtent: mainAxisExtent);
  }

  @override
  void updateRenderObject(BuildContext context, RenderSpace renderObject) {
    renderObject.mainAxisExtent = mainAxisExtent;
  }
}


class RenderSpace extends RenderBox {
  double _mainAxisExtent;

  RenderSpace({double? mainAxisExtent}) : _mainAxisExtent = mainAxisExtent!;

  double get mainAxisExtent => _mainAxisExtent;

  set mainAxisExtent(double value) {
    if (_mainAxisExtent != value) {
      _mainAxisExtent = value;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {

    final RenderObject flex = parent!;

    if (flex is RenderFlex) {
      if (flex.direction == Axis.horizontal) {
        size = constraints.constrain(Size(mainAxisExtent, 0));
      } else {
        size = constraints.constrain(Size(0, mainAxisExtent));
      }
    } else {
      throw 'Space widget is not inside flex parent';
    }
  }
}
