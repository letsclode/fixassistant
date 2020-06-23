import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime currentTime, LocaleType locale}) : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.day);
    this.setMiddleIndex(this.currentTime.month);
    this.setRightIndex(this.currentTime.year);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 1 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  // @override
  // String middleStringAtIndex(int index) {
   
  //     return this.digits(index, 1);
   
  // }

  // @override
  // String rightStringAtIndex(int index) {
   
  //     return this.digits(index,1);
   
  // }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(currentTime.day, currentTime.month, currentTime.year,
            this.currentLeftIndex(), 
            this.currentMiddleIndex(), 
            this.currentRightIndex())
        : DateTime(currentTime.day, currentTime.month, currentTime.year, this.currentLeftIndex(),
            this.currentMiddleIndex(), this.currentRightIndex());
  }
}