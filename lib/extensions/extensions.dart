import 'package:flutter/material.dart';

extension PercentSize on BuildContext {
  double percentWidth(double percent) =>
      MediaQuery.of(this).size.width * percent;
  double percentHeight(double percent) =>
      MediaQuery.of(this).size.height * percent;
}
