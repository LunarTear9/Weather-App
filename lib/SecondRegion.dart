/*import 'dart:convert';
import 'package:http/http.dart' as http;

int tempflag2 = 0;

class WeatherApiClient {
  late List<double> hourlyTemperature2;

  List<List<double>> TempMatrix2 =
      List.generate(7, (index) => List<double>.filled(24, 0));

  final String apiUrl; // Replace with your API endpoint
  List<Map<String, dynamic>> weatherDataList = [];

  WeatherApiClient(this.apiUrl);

  Future<void> fetchData2(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=39.1601&longitude=20.9856&hourly=temperature_2m&forecast_days=3'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON data
      final weatherData = json.decode(response.body);
      weatherDataList.add(weatherData);
      final List<double> temperatureList =
          List<double>.from(weatherData['hourly']['temperature_2m']);
      for (int i = 0; i <= 2; i++) {
        tempflag2 = 0;
        for (int j = 0; j <= 23; j++) {
          TempMatrix2[i][j] = temperatureList[tempflag2];
          tempflag2++;
        }
      }
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load weather data');
    }
  }
}

void main() async {
  // Replace 'YOUR_API_URL' with the actual API endpoint
  final apiUrl =
      'https://api.open-meteo.com/v1/forecast?latitude=39.1601&longitude=20.9856&hourly=temperature_2m&forecast_days=3';

  // Replace with the desired latitude and longitude
  final latitude = 39.125;
  final longitude = 21.0;

  final weatherApiClient = WeatherApiClient(apiUrl);

  try {
    await weatherApiClient.fetchData2(latitude, longitude);

    // Access the saved weather data
    for (var weatherData in weatherApiClient.weatherDataList) {
      // Process the weather data as needed
      print(weatherData);
    }
  } catch (e) {
    // Handle errors
    print('Error: $e');
  }
}
*/