// To parse this JSON data, do
//
//     final regions = regionsFromJson(jsonString);

import 'dart:convert';
import 'dart:ui';
List<Regions> regionsFromJson(String str) => List<Regions>.from(json.decode(str).map((x) => Regions.fromJson(x)));
String regionsToJson(List<Regions> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Regions {
  Regions({
    this.regionName,
    this.cities,
  });

  String regionName;
  List<City> cities;

  factory Regions.fromJson(Map<String, dynamic> json) => Regions(
    regionName: json["region_name"],
    cities: List<City>.from(json["cities"].map((x) => City.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "region_name": regionName,
    "cities": List<dynamic>.from(cities.map((x) => x.toJson())),
  };
}

class City {
  City({
    this.id,
    this.text,
    this.textSimple,
    this.textGray,
    this.lon,
    this.lat,
    this.zoom,
    this.url,
    this.districts,
  });

  String id;
  String text;
  String textSimple;
  String textGray;
  String lon;
  String lat;
  String zoom;
  String url;
  List<District> districts;

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    text: json["text"],
    textSimple: json["text_simple"],
    textGray: json["text_gray"],
    lon: json["lon"],
    lat: json["lat"],
    zoom: json["zoom"],
    url: json["url"],
    districts: List<District>.from(json["districts"].map((x) => District.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
    "text_simple": textSimple,
    "text_gray": textGray,
    "lon": lon,
    "lat": lat,
    "zoom": zoom,
    "url": url,
    "districts": List<dynamic>.from(districts.map((x) => x.toJson())),
  };
  @override
  String toString() {
    return '$textSimple';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is City && other.text == text && other.id == id && other.textSimple==textSimple;
  }

  @override
  int get hashCode => hashValues(textSimple, id);
}

class District {
  District({
    this.id,
    this.cityId,
    this.text,
    this.textDistrict,
    this.textGray,
    this.lon,
    this.lat,
    this.zoom,
  });

  String id;
  String cityId;
  String text;
  String textDistrict;
  String textGray;
  String lon;
  String lat;
  int zoom;

  factory District.fromJson(Map<String, dynamic> json) => District(
    id: json["id"],
    cityId: json["city_id"],
    text: json["text"],
    textDistrict: json["text_district"],
    textGray: json["text_gray"],
    lon: json["lon"],
    lat: json["lat"],
    zoom: json["zoom"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "city_id": cityId,
    "text": text,
    "text_district": textDistrict,
    "text_gray": textGray,
    "lon": lon,
    "lat": lat,
    "zoom": zoom,
  };
}
