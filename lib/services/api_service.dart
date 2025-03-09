import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl =
      "https://t3ctkkoosb.execute-api.ap-south-2.amazonaws.com/prod/fetch-data";

  Future<List<String>> fetchData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        // Extract only the "message" field from each item
        return jsonData
            .where((item) => item is Map<String, dynamic> && item.containsKey("message"))
            .map((item) => item["message"].toString())
            .toList();
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}