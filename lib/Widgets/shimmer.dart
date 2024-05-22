import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final Color color;

  const ShimmerWidget({super.key, this.color = const Color(0xFFF7F7F7)});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: color,
      highlightColor: color.withOpacity(0.3),
      child: Container(
        width: 50.0,
        height: 20.0,
        color: Colors.white,
      ),
    );
  }
}
