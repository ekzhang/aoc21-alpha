import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';

const inf = 1000000000;

class Box {
  final bool on;
  final int minX, maxX;
  final int minY, maxY;
  final int minZ, maxZ;

  Box(this.on, this.minX, this.maxX, this.minY, this.maxY, this.minZ,
      this.maxZ);

  static final regexp = RegExp(r'^\w=([0-9-]+)\.\.([0-9-]+)');

  factory Box.parse(final String s) {
    final parts = s.split(" ");
    final coords = parts[1].split(",");
    final matches = coords.map((e) => regexp.firstMatch(e)!).toList();
    return Box(
      parts[0] == "on",
      int.parse(matches[0].group(1)!),
      int.parse(matches[0].group(2)!) + 1,
      int.parse(matches[1].group(1)!),
      int.parse(matches[1].group(2)!) + 1,
      int.parse(matches[2].group(1)!),
      int.parse(matches[2].group(2)!) + 1,
    );
  }

  @override
  String toString() {
    return "${on ? "on" : "off"} [$minX...$maxX, $minY...$maxY, $minZ...$maxZ]";
  }

  bool isValid() => minX < maxX && minY < maxY && minZ < maxZ;

  Box? intersect(final Box other) {
    final box = Box(
      on,
      max(minX, other.minX),
      min(maxX, other.maxX),
      max(minY, other.minY),
      min(maxY, other.maxY),
      max(minZ, other.minZ),
      min(maxZ, other.maxZ),
    );
    if (box.isValid()) return box;
    return null;
  }

  List<Box> complement() {
    return [
      Box(on, -inf, minX, -inf, inf, -inf, inf),
      Box(on, maxX, inf, -inf, inf, -inf, inf),
      Box(on, minX, maxX, -inf, minY, -inf, inf),
      Box(on, minX, maxX, maxY, inf, -inf, inf),
      Box(on, minX, maxX, minY, maxY, -inf, minZ),
      Box(on, minX, maxX, minY, maxY, maxZ, inf),
    ];
  }

  List<Box> difference(final Box other) {
    if (intersect(other) != null) {
      final parts = other.complement();
      return [for (final part in parts) intersect(part)]
          .whereNotNull()
          .toList();
    } else {
      return [this];
    }
  }

  List<Box> differenceMany(final List<Box> others, {final int i = 0}) {
    if (i == others.length) {
      return [this];
    } else {
      final List<Box> ret = [];
      for (final cpt in difference(others[i])) {
        ret.addAll(cpt.differenceMany(others, i: i + 1));
      }
      return ret;
    }
  }

  int volume() => on ? (maxX - minX) * (maxY - minY) * (maxZ - minZ) : 0;
}

int compress(final List<int> coords, final int value) {
  final idx = binarySearch(coords, value);
  if (idx == -1) {
    throw Exception("failed to compress $value in list $coords");
  }
  return idx;
}

List<int> diffs(final List<int> coords) {
  final List<int> ret = [];
  for (var i = 0; i < coords.length - 1; i++) {
    ret.add(coords[i + 1] - coords[i]);
  }
  return ret;
}

int solve(final List<Box> boxes) {
  return boxes.reversed
      .fold<List<Box>>([], (parts, box) => parts + box.differenceMany(parts))
      .map((e) => e.volume())
      .sum;
}

void main() {
  final List<Box> boxes = [];

  while (true) {
    final line = stdin.readLineSync(encoding: utf8);
    if (line == null) {
      break;
    }
    final box = Box.parse(line);
    boxes.add(box);
  }

  print(solve(boxes.sublist(0, 20)));
  print(solve(boxes));
}
