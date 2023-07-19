import 'dart:collection';

// TODO: Needs revision
List<String> sortKeysIncreasingValue(Map<String, int> districtTempMap) {
  final sortedKeys = districtTempMap.keys.toList(growable: false)
    ..sort(
      (k1, k2) {
        if (districtTempMap.containsKey(k1) &&
            districtTempMap.containsKey(k2)) {
          return districtTempMap[k1]!.compareTo(districtTempMap[k2]!);
        }
        return 0;
      },
    );
  return sortedKeys;
}

class NowStats {
  final String man;
  final String aerial;
  final String cars;
  final String total;

  NowStats({
    required this.man,
    required this.aerial,
    required this.cars,
    required this.total,
  });

  factory NowStats.empty() {
    return NowStats(man: '0', aerial: '0', cars: '0', total: '0');
  }

  factory NowStats.fromJson(Map<String, dynamic> parsedJson) {
    return NowStats(
        man: parsedJson['man'].toString(),
        aerial: parsedJson['aerial'].toString(),
        cars: parsedJson['cars'].toString(),
        total: parsedJson['total'].toString());
  }
}

class TodayStats {
  final List<IntervalStats> intervalStatsList;
  final List<District> districtList;

  TodayStats({
    required this.intervalStatsList,
    required this.districtList,
  });

  factory TodayStats.empty() {
    return TodayStats(intervalStatsList: [], districtList: []);
  }

  factory TodayStats.fromJson(Map<String, dynamic> parsedJson) {
    List<IntervalStats> intervalStatsList = <IntervalStats>[];
    List<District> districtList = <District>[];
    Map<String, int> districtTempMap = Map<String, int>();

    parsedJson
        .forEach((i, j) => intervalStatsList.add(IntervalStats.fromJson(j, i)));

    // Checks for double entries and sums them
    intervalStatsList.forEach((d) {
      d.districtMap.forEach((k, v) {
        if (districtTempMap.containsKey(k)) {
          districtTempMap.update(k, (dynamic val) => val + v);
        } else {
          districtTempMap[k] = v;
        }
      });
    });

    // TODO: Needs revision
    // Sort by increasing values

    List<String> sortedKeys = sortKeysIncreasingValue(districtTempMap);
    LinkedHashMap sortedMap = LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => districtTempMap[k]);

    // Convert the map to a List for chart data
    sortedMap.forEach((k, v) {
      districtList.add(District(district: k, fires: v));
    });

    return TodayStats(
      intervalStatsList: intervalStatsList,
      districtList: districtList,
    );
  }
}

class YesterdayStats {
  final List<IntervalStats> intervalStatsList;
  final List<District> districtList;

  YesterdayStats({
    required this.intervalStatsList,
    required this.districtList,
  });

  factory YesterdayStats.empty() {
    return YesterdayStats(intervalStatsList: [], districtList: []);
  }

  factory YesterdayStats.fromJson(Map<String, dynamic> parsedJson) {
    List<IntervalStats> intervalStatsList = <IntervalStats>[];
    List<District> districtList = <District>[];
    Map<String, int> districtTempMap = Map<String, int>();

    parsedJson
        .forEach((i, j) => intervalStatsList.add(IntervalStats.fromJson(j, i)));

    // Checks for double entries and sums them
    intervalStatsList.forEach((d) {
      d.districtMap.forEach((k, v) {
        if (districtTempMap.containsKey(k)) {
          districtTempMap.update(k, (dynamic val) => val + v);
        } else {
          districtTempMap[k] = v;
        }
      });
    });

    // Sort by increasing values
    List<String> sortedKeys = sortKeysIncreasingValue(districtTempMap);
    LinkedHashMap sortedMap = LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => districtTempMap[k]);

    // Convert the map to a List for chart data
    sortedMap.forEach((k, v) {
      districtList.add(District(district: k, fires: v));
    });

    return YesterdayStats(
        intervalStatsList: intervalStatsList, districtList: districtList);
  }
}

class LastNightStats {
  final int total;
  final List<District> districtList;

  LastNightStats({
    required this.total,
    required this.districtList,
  });

  factory LastNightStats.fromJson(Map<String, dynamic> json) {
    List<District> districtList = <District>[];
    int total = json['total'];

    if (total != 0) {
      json['distritos']
          ?.forEach((i, j) => districtList.add(District.fromJson(i, j)));
    }

    districtList.sort((k1, k2) => k1.fires.compareTo(k2.fires));

    return LastNightStats(total: total, districtList: districtList);
  }
}

class WeekStats {
  final List<Day> days;

  WeekStats({
    required this.days,
  });

  factory WeekStats.empty() {
    return WeekStats(days: []);
  }

  factory WeekStats.fromJson(List<dynamic> json) {
    List<Day> days = <Day>[];

    days = json.map((i) => Day.fromJson(i)).toList();

    return WeekStats(days: days);
  }
}

class Day {
  final String label;
  final int total;
  final int fake;

  Day({
    required this.label,
    required this.total,
    required this.fake,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(label: json['label'], total: json['total'], fake: json['false']);
  }
}

class LastHoursStats {
  final List<LastHour> lastHours;

  LastHoursStats({
    required this.lastHours,
  });

  factory LastHoursStats.fromJson(List<dynamic> json) {
    List<LastHour> lastHours = <LastHour>[];
    lastHours = json.map((i) => LastHour.fromJson(i)).toList();
    return LastHoursStats(lastHours: lastHours);
  }
}

class LastHour {
  final int man;
  final int aerial;
  final int cars;
  final int total;
  final DateTime label;

  LastHour({
    required this.man,
    required this.aerial,
    required this.cars,
    required this.total,
    required this.label,
  });

  factory LastHour.fromJson(Map<String, dynamic> parsedJson) {
    DateTime dateLabel = DateTime.fromMillisecondsSinceEpoch(
        parsedJson['created'].runtimeType == int
            ? parsedJson['created'] * 1000
            : parsedJson['created']['sec'] * 1000);

    return LastHour(
      man: parsedJson['man'],
      aerial: parsedJson['aerial'],
      cars: parsedJson['cars'],
      total: parsedJson['total'],
      label: dateLabel,
    );
  }
}

class IntervalStats {
  final String label;
  final int total;
  final Map<String, int> districtMap;

  IntervalStats({
    required this.total,
    required this.districtMap,
    required this.label,
  });

  factory IntervalStats.fromJson(Map<String, dynamic> json, String label) {
    int total = json['total'];

    Map<String, int> districtMap = Map<String, int>();

    if (total != 0) {
      json['distritos']?.forEach((i, j) => districtMap[i] = j);
    }

    return IntervalStats(total: total, label: label, districtMap: districtMap);
  }
}

class District {
  final String district;
  final int fires;

  District({
    required this.district,
    required this.fires,
  });

  factory District.fromJson(String district, int fire) {
    return District(district: district, fires: fire);
  }
}
