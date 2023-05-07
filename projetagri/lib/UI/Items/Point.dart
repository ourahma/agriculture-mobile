import 'package:collection/collection.dart';

class Point{
  final double x;
  final double y;
  Point({required this.x , required this.y});
}

List<Point> get point{
  final data =<double>[2,4,6,11,3,6,4];
  return data.mapIndexed(
      (index,element) => Point(x: index.toDouble(), y: element)
  ).toList();
}