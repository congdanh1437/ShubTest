// lib/models/data_model.dart
class DataModel {
  final String token;
  final List<int> data;
  final List<Query> queries;

  DataModel({required this.token, required this.data, required this.queries});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    var queriesJson = json['query'] as List;
    List<Query> queries = queriesJson.map((i) => Query.fromJson(i)).toList();

    return DataModel(
      token: json['token'],
      data: List<int>.from(json['data']),
      queries: queries,
    );
  }
}

class Query {
  final String type;
  final List<int> range;

  Query({required this.type, required this.range});

  factory Query.fromJson(Map<String, dynamic> json) {
    return Query(
      type: json['type'],
      range: List<int>.from(json['range']),
    );
  }
}
