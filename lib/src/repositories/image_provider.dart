import 'dart:typed_data';
import 'package:http/http.dart';
import '../models/photos.dart';
import '../models/state.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../logger.dart';

class ImageProvider {
  final logger = getLogger('ImageProvider');

  //Singleton
  static final ImageProvider _imageProvider = ImageProvider._private();
  ImageProvider._private();
  factory ImageProvider() => _imageProvider;

  Client _client = Client();

  String _apiKey = DotEnv().env['API_KEY'];
  static const String _baseUrl = "https://api.unsplash.com";

  //Get list of images based on the query
  Future<State> getImagesByName(String query) async {
    Response response;
    if (_apiKey == 'api-key') {
      return State<String>.error("Please enter your API Key");
    }
    logger.d(_apiKey);

    logger.d(query);

    response = await _client
        .get("$_baseUrl/search/photos?page=1&query=$query&client_id=$_apiKey");
    logger.d(response.body);
    if (response.statusCode == 200)
      return State<Photos>.success(Photos.fromJson(json.decode(response.body)));
    else
      return State<String>.error(response.statusCode.toString());
  }

  Future<Uint8List> getImageFromUrl(String url) async {
    var response = await _client.get(url);
    Uint8List bytes = response.bodyBytes;
    return bytes;
  }
}
