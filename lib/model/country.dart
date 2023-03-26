import 'package:latlong2/latlong.dart';

class Country {
  final int id;
  final String name;
  final String code;
  final LatLng location;

  Country({required this.name, required this.code, required this.id, required this.location});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      location: LatLng.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'code': code,
        'location': location.toJson(),
      };
}