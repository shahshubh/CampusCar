import 'package:CampusCar/enum/direction.dart';

class Utils {
  static int directionToNum(Direction direction) {
    switch (direction) {
      case Direction.Entering:
        return 0;
      case Direction.Leaving:
        return 1;
      default:
        return 0;
    }
  }

  static Direction numToDirection(int number) {
    switch (number) {
      case 0:
        return Direction.Entering;
      case 1:
        return Direction.Leaving;
      default:
        return Direction.Entering;
    }
  }
}
