import 'dart:convert';
import 'dart:developer';

import 'package:ai_image_generator/api_key.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static final _url = Uri.parse('https://api.openai.com/v1/images/generations');
  static const _headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  static generateImage({
    required String description,
    required String size,
  }) async {
    var response = await http.post(
      _url,
      headers: _headers,
      body: jsonEncode({
        'prompt': description,
        'n': 1,
        'size': size,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      log('------------------------ generateImage RESPONSE ------------------------\n$data');
      return data['data'][0]['url'].toString();
    } else {
      log('------------------------ generateImage ERROR ------------------------');
    }
  }
}
