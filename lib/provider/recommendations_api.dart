import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dismov_app/models/pet_model.dart';

class RecommendationsApi {
  static Future<List<PetModel>> getRecommendations(userId) async {
    String baseURL = 'https://pawtnerup.pythonanywhere.com';
    String endpoint = '/recommendations/$userId';
    final response = await http.get(Uri.parse('$baseURL$endpoint'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<PetModel> pets = data.map((e) => PetModel.fromJson(e)).toList();
      return pets;
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Failed to load recommendations');
    }
  }
}