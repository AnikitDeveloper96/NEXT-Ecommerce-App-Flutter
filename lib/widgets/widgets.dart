import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppWidgets {
  loadingImageAssets(String assetsname) {
    return SvgPicture.asset(
      "assets/images/$assetsname",
      fit: BoxFit.cover,
      height: 204,
    );
  }

  commonTextStyles() {
    return Container();
  }
}
