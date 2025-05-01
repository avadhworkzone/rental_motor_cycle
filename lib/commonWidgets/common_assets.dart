import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:octo_image/octo_image.dart';
import 'package:rental_motor_cycle/utils/color_utils.dart';

class LocalAssets extends StatelessWidget {
  const LocalAssets({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.imgColor,
    this.boxFit,
    this.scaleSize,
  });
  final String imagePath;
  final double? height, width, scaleSize;
  final Color? imgColor;
  final BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    return imagePath.split('.').last != 'svg'
        ? Image.asset(
          imagePath,
          height: height,
          width: width,
          scale: scaleSize,
          // color: imgColor,
          fit: boxFit,
        )
        : SvgPicture.asset(
          imagePath,
          height: height,
          width: width,
          // color: imgColor,
        );
  }
}

class NetWorkAssets extends StatelessWidget {
  const NetWorkAssets({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.scaleSize,
    this.boxFit,
    this.radius,
  });
  final String imageUrl;
  final double? height, width, scaleSize, radius;
  final BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 100),
      child:
          imageUrl.contains('.svg')
              ? SvgPicture.network(imageUrl)
              : OctoImage(
                height: height ?? 10.w,
                width: width ?? 10.w,
                image: CachedNetworkImageProvider(imageUrl),
                errorBuilder: OctoError.icon(color: ColorUtils.red),
                fit: boxFit ?? BoxFit.contain,
              ),
    );
  }
}
