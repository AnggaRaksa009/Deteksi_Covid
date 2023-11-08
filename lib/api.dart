import 'package:http/http.dart' as http;

class ApiService {
  Future<String> fetchData() async {
    final response = await http.get(Uri.parse('https://127.0.0.1/predict'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
