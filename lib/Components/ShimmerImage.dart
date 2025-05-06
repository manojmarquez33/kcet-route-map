import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class _ShimmerImage extends StatefulWidget {
  final String url;

  const _ShimmerImage({required this.url});

  @override
  State<_ShimmerImage> createState() => _ShimmerImageState();
}

class _ShimmerImageState extends State<_ShimmerImage> {
  bool _isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!_isLoaded)
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 200,
              color: Colors.white,
            ),
          ),
        Image.network(
          widget.url,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 200,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              Future.delayed(Duration.zero, () {
                if (mounted) {
                  setState(() {
                    _isLoaded = true;
                  });
                }
              });
              return child;
            } else {
              return const SizedBox(); // Empty until loaded
            }
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Text('Image load error'));
          },
        ),
      ],
    );
  }
}
